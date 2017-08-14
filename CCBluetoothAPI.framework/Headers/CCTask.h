//
//  CCTask.h
//  IphoneApp
//
//  Created by 莫锹文 on 2017/6/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBluetoothMaster.h"

@interface CCTask : NSObject
@property (nonatomic, assign, readonly) SEL selector;
@property (nonatomic, strong, readonly) NSArray *params;
@property (nonatomic, copy, readonly) CCBluetoothMasterSuccess success;
@property (nonatomic, copy, readonly) CCBluetoothMasterFailure failure;
@property (nonatomic, assign, readonly) SEL callback;
@property (nonatomic, strong, readonly) NSObject *callbackTarget;

@property (nonatomic, strong, readonly) NSInvocation *sendInv;
@property (nonatomic, strong, readonly) NSInvocation *callbackInv;

/**
 *  以Block回调形式创建CCTask
 *
 *  @param selector CCBluetoothDevice的命令SEL
 *  @param params 命令SEL的参数
 *  @param success ...
 *  @param failure ...
 */
+ (instancetype)taskWithSelector:(SEL)selector params:(NSArray *)params success:(CCBluetoothMasterSuccess)success failure:(CCBluetoothMasterFailure)failure;

/**
 *  以Selector回调形式创建CCTask
 *
 *  @param selector CCBluetoothDevice的命令SEL
 *  @param params 命令SEL的参数
 *  @param callback 回调SEL，最多只能有两个参数（CCBluetoothDeviceProtocol里面定义的接口最多为两个）
 *  @param callbackTarget 回调SEL的target
 */
+ (instancetype)taskWithSelector:(SEL)selector params:(NSArray *)params callback:(SEL)callback callbackTarget:(NSObject *)callbackTarget;

@end
