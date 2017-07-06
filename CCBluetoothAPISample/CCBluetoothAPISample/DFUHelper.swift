//
//  DFUHelper.swift
//  IphoneApp
//
//  Created by 莫锹文 on 2017/5/3.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import CoreBluetooth
import iOSDFULibrary

public typealias DFUHelperSuccess = (Int, String) -> Swift.Void
public typealias DFUHelperFailure = (Int, String) -> Swift.Void
public typealias DFUHelperProgress = (Int, String) -> Swift.Void

class DFUHelper: NSObject {

    fileprivate static var legacyDfuServiceUUID = CBUUID(string: "00001530-1212-EFDE-1523-785FEABCD123")

    fileprivate var centralManager: CBCentralManager?

    fileprivate var dfuController: DFUServiceController?
    fileprivate var targetPeripheral: CBPeripheral?
    fileprivate var targetPeripheralName: String?
    fileprivate var selectedFirmware: DFUFirmware?

    fileprivate var success: DFUHelperSuccess?
    fileprivate var failure: DFUHelperFailure?
    fileprivate var progress: DFUHelperProgress?

    /// DFU结束时候，会发送验证指令，然后重启设备，这时候设备会断开，此参数为避免跟主动断开（如关掉蓝牙）冲突
    /// iOSDFULibrary will send valid command to peripheral and reset when finish DFU task. this param resolve conflict for DFUState.disconnecting(or DFUState.aborted) and disconnect manually.
    fileprivate var isValided: Bool = false

    /// scan timer
    fileprivate var scanTimer: Timer?

    /// scaned peripherals
    fileprivate lazy var scanedPeripherals: [CBPeripheral] = []

    /// 初始化，每次DFU（无论结果失败还是成功）都应是一个对象实例
    /// init. Each DFU (whether the result is failed or successful) should be an instance
    ///
    /// - Parameters:
    ///   - peripheralName: name of peripheral in DFU mode
    ///   - url: package name with zip
    init(peripheralName: String, url: URL, progress: @escaping DFUHelperProgress, success: @escaping DFUHelperSuccess, failure: @escaping DFUHelperProgress) {

        super.init()
        self.targetPeripheralName = peripheralName
        self.success = success
        self.failure = failure
        self.progress = progress
        self.selectedFirmware = DFUFirmware(urlToZipFile: url)
        self.isValided = false

        self.centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }

    fileprivate func startDFUProcess() {

        guard self.targetPeripheral != nil else {
            print("No DFU peripheral was set")
            self.finishWithFailure()
            return
        }

        let dfuInitiator = DFUServiceInitiator(centralManager: centralManager!, target: self.targetPeripheral!)
        dfuInitiator.delegate = self
        dfuInitiator.progressDelegate = self
        dfuInitiator.logger = self
        dfuInitiator.packetReceiptNotificationParameter = 20

        dfuController = dfuInitiator.with(firmware: selectedFirmware!).start()

    }

    fileprivate func finishWithSuccess() {
        if let _ = self.success {
            self.success!(0, "test")
        }

        self.scanTimer?.invalidate()
    }

    fileprivate func finishWithFailure() {
        if let _ = self.failure {
            self.failure!(0, "fail")
        }
        self.scanTimer?.invalidate()
    }

    deinit {
        printLog("[DFUHelper deinit]")
    }

}

// MARK: - CBCentralManagerDelegate
extension DFUHelper: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        if central.state == .poweredOn {
            self.scanedPeripherals.removeAll()

            // 添加已连接的设备
            self.scanedPeripherals += central.retrieveConnectedPeripherals(withServices: [DFUHelper.legacyDfuServiceUUID])

            // 开始搜索
            self.centralManager?.scanForPeripherals(withServices: [DFUHelper.legacyDfuServiceUUID], options: nil)

            // 添加超时计时器

            self.scanTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(DFUHelper.timer_handler(timer:)), userInfo: nil, repeats: false)
        } else {
            printLog("蓝牙状态非开启")
            self.finishWithFailure()
        }
    }

    func timer_handler(timer: Timer) {
        printLog("scan complete")

        self.centralManager?.stopScan()

        if let peripheral = self.scanedPeripherals.filter({ $0.name == self.targetPeripheralName }).first {
            // 发现目标
            self.targetPeripheral = peripheral
            self.centralManager?.connect(peripheral, options: nil)
        } else {
            self.finishWithFailure()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        printLog("search for new peripheral:\(peripheral)")
        self.scanedPeripherals.append(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        printLog("connect with device")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        printLog("disconnect with device")
        self.finishWithFailure()
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.finishWithFailure()
    }

}

// MARK: - CBPeripheralDelegate
extension DFUHelper: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // Find DFU Service
        let services = peripheral.services!
        for service in services {
            if service.uuid.isEqual(DFUHelper.legacyDfuServiceUUID) {
                break
            }
        }

        self.startDFUProcess()
    }

}

// MARK: - DFUServiceDelegate
extension DFUHelper: DFUServiceDelegate {

    func dfuStateDidChange(to state: DFUState) {
        switch state {

        case .completed:
            printLog("completed")

            self.finishWithSuccess()
        case .disconnecting, .aborted:
            if self.isValided == false {
                self.finishWithFailure()
            }

        case .validating:
            self.isValided = true

        default:
            printLog("other")
        }

        //        dfuStatusLabel.text = state.description()
        printLog("Changed state to: \(state.description())")

        // Forget the controller when DFU is done
        if state == .completed {
            dfuController = nil
        }
    }

    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {

        printLog("Error \(error.rawValue): \(message)")

        // Forget the controller when DFU finished with an error
        dfuController = nil

        self.finishWithFailure()
    }

}

// MARK: - DFUProgressDelegate
extension DFUHelper: DFUProgressDelegate {
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        //        dfuUploadProgressView.setProgress(Float(progress)/100.0, animated: true)
        let progressString = String(format: "Part: %d/%d Speed: %.1f KB/s Average Speed: %.1f KB/s", part, totalParts, currentSpeedBytesPerSecond / 1024, avgSpeedBytesPerSecond / 1024)
        printLog(progressString)
        if let _ = self.progress {
            self.progress!(progress, "test")
        }
    }
}

// MARK: - LoggerDelegate
extension DFUHelper: LoggerDelegate {
    internal func logWith(_ level: LogLevel, message: String) {
        printLog("\(level.name()): \(message)")
    }

}

// MARK: - other

func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"

    #if DEBUG
        print("[\(formatter.string(from: Date()))] -[\((file as NSString).lastPathComponent) \(method)] line:\(NSString(format: "%04d", Int(line))) content:\(message)")
    #endif
}
