//
//  CCBluetoothDevice.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/9.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBluetoothDeviceProtocol.h"

@class CCBluetoothManager;
@class CBPeripheral;
@class CCBluetoothDevice;

typedef void (^CCBluetoothDeviceConnectCallback) (CCBluetoothDevice *device, NSError *error);

typedef void (^CCBluetoothDeviceDiscoverServicesCallback)(NSArray *services, NSError *error);

typedef void (^CCBluetoothDeviceSendDataCallback)(CCBluetoothDevice *device, NSData *data, NSError *error);

/**
 * 设备管理类：连接，断开，发送指令
 * 只能通过扫描来获取设备，无法通过自行init初始化
 */
@interface CCBluetoothDevice : NSObject

@property (weak, nonatomic, readonly) CCBluetoothManager *bluetoothManager;

@property (strong, nonatomic, readonly) CBPeripheral *cbPeripheral;

///连接状态
@property (assign, nonatomic, readonly) BOOL connected;

///设备名称
@property (weak, nonatomic, readonly) NSString *name;

///协议类型
@property (assign, nonatomic) CCBluetoothProtocolType protocolType;

///信号强度
@property (assign, nonatomic) NSInteger RSSI;

///MAC地址 只有通过广播搜索到的设备才能直接获取到MAC地址，如果是已经配对的设备则无法获取，需要通过指令读取
@property (nonatomic, strong) NSString *macAddress;

///响应回调超时时间
@property (assign, nonatomic) NSUInteger responseInterval;

@property (strong, nonatomic, readonly) NSArray *services;

@property (weak, nonatomic) id <CCBluetoothDeviceDelegate> delegate;

#pragma mark - OTA
@property (nonatomic, strong) NSArray *firmwareData;
@property (nonatomic, assign) NSInteger currentByteIndex;
@property (nonatomic, strong) NSTimer *OTATimer;
@property (nonatomic, assign) BOOL isSecondSending; //是否第二次发送

#pragma mark - Public Methods

/**
 * 连接设备
 *
 * @param device   需要连接的设备
 * @param interval 连接时间
 * @param callback 回调
 */
- (void)connectWithinterval:(NSTimeInterval)interval completion:(CCBluetoothDeviceConnectCallback)callback;

/**
 * 断开设备
 *
 * @param device   需要断开的设备
 * @param callback 回调
 */
- (void)disConnectWithCompletion:(CCBluetoothDeviceConnectCallback)callback;

/**
 * 发送数据
 *
 * @param data     需要发送的数据
 * @param callback 回调
 */
- (void)sendData:(NSData *)data completion:(CCBluetoothDeviceSendDataCallback)callback;
//发送数据
- (void)sendMediaData:(NSData *)data completion:(CCBluetoothDeviceSendDataCallback)callback;

/**
 * 发送数据
 *
 * @param bytes    需要发送的数据
 * @param bytesLen 数据长度
 * @param callback 回调
 */
- (void)sendBytes:(Byte *)bytes bytesLen:(NSUInteger)bytesLen completion:(CCBluetoothDeviceSendDataCallback)callback;
- (void)sendToMediaBytes:(Byte *)bytes bytesLen:(NSUInteger)bytesLen completion:(CCBluetoothDeviceSendDataCallback)callback;

/**
 * 获取错误信息
 *
 * @param code 错误码
 *
 * @return 错误信息
 */
- (NSString *)errorMessageWithCode:(CCErrorCode)code;

#pragma mark - Private Initializer -
- (instancetype)initWithPeripheral:(CBPeripheral *)aPeripheral manager:(CCBluetoothManager *)manager;

#pragma mark - Private Handlers -
//处理设备连接
- (void)handleConnectionWithError:(NSError *)anError;
//处理设备断开
- (void)handleDisconnectWithError:(NSError *)anError;

- (void)enableReconnect;
- (void)disableReconnect;
@end
