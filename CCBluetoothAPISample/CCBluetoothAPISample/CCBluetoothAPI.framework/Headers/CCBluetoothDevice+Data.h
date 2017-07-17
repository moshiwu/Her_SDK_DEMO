//
//  CCBluetoothDevice+Data.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/13.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "CCBluetoothDevice.h"

@interface CCBluetoothDevice (Activity)
///获取运动数据
- (void)getActivityData;
///获取运动数据数量
- (void)getActivityDataCount;
///获取睡眠数据
- (void)getSleepData;
///获取睡眠数据数量
- (void)getSleepDataCount;
///是否设置成手动删除运动数据和睡眠数据模式（默认自动），YES:手动, NO:自动
- (void)setManuallyDeleteMode:(BOOL)deleteMode;
///手动删除运动数据
- (void)manuallyDeleteActivityData;
///手动删除睡眠数据
- (void)manuallyDeleteSleepData;
///获取 设备端运动/睡眠模式
- (void)getDeviceSportOrSleepStatus;
///获取心率数据
- (void)getHeartRateData;
///删除心率命令
- (void)manuallyDeleteHeartRateData;
///获取当天汇总运动数据
- (void)getAllActivityData;
- (void)getActivityDataByCount:(int)count;
- (void)getSleepDataByCount:(int)count;

///获取心率总数
- (void)getHeartRateOrEmotionDataCount;
///根据总条数获取心率数据
- (void)getHeartRateDataOrEmotionDataByCount:(int)count isHeartRateData:(BOOL)isHeartRateData;

#pragma mark - BloodPressure
///获取血压总数
- (void)getBloodPressureCount;
///根据血压总条数获取血压数据
- (void)getBloodPressureByCount:(int)count;

- (void)manuallyDeleteBloodPressureData;

- (void)manuallyOpenModule:(CCBlueToothManuallyModule)module;

@end
