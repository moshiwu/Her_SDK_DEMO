//
//  CCBluetoothMaster.h
//  IphoneApp
//
//  Created by 莫锹文 on 2017/6/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBluetoothDevice.h"
#import "CCBluetoothManager.h"

typedef void (^CCBluetoothMasterSuccess)(id object);
typedef void (^CCBluetoothMasterFailure)(NSError *error);

@interface CCBluetoothMaster : NSObject <CCBluetoothDeviceDelegate>

+ (instancetype)sharedInstance;

- (void)addTask:(SEL)selector params:(NSArray *)params success:(CCBluetoothMasterSuccess)success failure:(CCBluetoothMasterFailure)failure;
- (void)addTask:(SEL)selector params:(NSArray *)params callback:(SEL)callback callbackTarget:(NSObject *)callbackTarget;
- (void)commit;
- (void)commitWithSuccess:(CCBluetoothMasterSuccess)success failure:(CCBluetoothMasterFailure)failure;
- (void)cancel;

- (void)setDevice:(CCBluetoothDevice *)device;
- (void)releaseDevice;

/**
 *  让Master搜索并连接mainDeviceName的设备，只给第一次开启app后检测连接状态用，平时任务流程时候不要使用
 */
- (void)checkConnectionWithSuccess:(CCBluetoothMasterSuccess)success failure:(CCBluetoothMasterFailure)failure;

@property (nonatomic, strong, readonly) CCBluetoothDevice *mainDevice;
@property (nonatomic, strong) NSString *mainDeviceName;
@property (nonatomic, assign, readonly) BOOL isSending;

@end
