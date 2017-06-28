//
//  CCBluetoothManager.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/9.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSNotificationName const CCBlueToothPowerStateNotification;
extern NSNotificationName const CCPeripheralConnectStateNotification;
extern NSNotificationName const CCBluetoothDidReceiveMediaNotification;
extern NSNotificationName const CCBluetoothDidHeartRateNotification;

extern NSNotificationName const CCBluetoothDidReceiveShortTapNotification;
extern NSNotificationName const CCBluetoothDidReceiveLongTapNotification;
extern NSNotificationName const CCBluetoothDidReceiveShutDownTapNotification;


#ifdef MyWeakSelf
  #undef MyWeakSelf
#endif
#define MyWeakSelf __weak __typeof(self) ws = self;

@class CBCentralManager;

/**
 * 扫描回调
 *
 * @param peripherals 设备列表
 * @param error       错误信息
 */
typedef void (^CCBluetoothManagerScanDevicesCallback)(NSArray *peripherals, NSError *error);

/**
 * 系统蓝牙管理类：系统蓝牙开关状态，扫描设备
 */
@interface CCBluetoothManager : NSObject

///蓝牙是否开启
@property (assign, nonatomic, readonly) BOOL bluetoothOpened;

@property (strong, nonatomic, readonly) CBCentralManager *centralManager;

//@property (strong, nonatomic) NSMutableArray *scannedPeripherals;

//单例，系统启动时先调用一次这个函数，将会初始化蓝牙模块
+ (instancetype)sharedInstance;

///API的版本号
- (NSString *)apiVersion;

/**
 * 扫描设备
 *
 * @param interval 扫描时间
 * @param callback 回调
 */
- (void)scanDevicesWithInterval:(NSTimeInterval)interval
					 completion:(CCBluetoothManagerScanDevicesCallback)callback;

/**
 * 扫描设备
 *
 * @param interval   扫描时间
 * @param filterName 过滤设备名称
 * @param callback   回调
 */
- (void)scanDevicesWithInterval:(NSTimeInterval)interval
					 filterName:(NSString *)filterName
					 completion:(CCBluetoothManagerScanDevicesCallback)callback;

- (void)cancelScan;

- (BOOL)checkBluetoothOpenedAndAlert;

- (void)releaseScanedDevices;

@end
