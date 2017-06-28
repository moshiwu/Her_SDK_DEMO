//
//  CCBluetoothDeviceProtocol.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/12.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#ifndef CCBluetoothDeviceProtocol_h
#define CCBluetoothDeviceProtocol_h
#import <Foundation/Foundation.h>
#import "CCBluetoothDataTypes.h"

/**
 * 设备响应的协议
 */
@protocol CCBluetoothDeviceDelegate <NSObject>
@required

#pragma mark - Firmware Information
///获取产品类型
- (void)bleResponseForDeviceType:(CCBluetoothDeviceType)devicetype error:(NSError *)error;
///获取设备电量，percent为百分比，平均分成20等分，等于大于100时都表示满格
- (void)bleResponseForBatteryPower:(NSUInteger)percent error:(NSError *)error;
///获取watchID
- (void)bleResponseForWatchID:(NSString *)watchID error:(NSError *)error;
///获取固件版本
- (void)bleResponseForFirmwareVersion:(NSString *)version error:(NSError *)error;
///获取固件ID
- (void)bleResponseForFirmwareID:(NSString *)firmwareID error:(NSError *)error;

#pragma mark - Data
///获取运动数据，data的子项类型为 CCBluetoothActivityData
- (void)bleResponseForActivityData:(NSArray *)data error:(NSError *)error;
- (void)bleResponseForAllActivityData:(NSArray *)data error:(NSError *)error;
///获取运动数据数量
- (void)bleResponseForActivityDataCount:(NSUInteger)count error:(NSError *)error;
///获取睡眠数据
- (void)bleResponseForSleepData:(NSArray *)data error:(NSError *)error;
///获取睡眠数据数量
- (void)bleResponseForSleepDataCount:(NSUInteger)count error:(NSError *)error;
///设置删除模式
- (void)bleResponseForSetManuallyDeleteMode:(NSError *)error;
///手动删除运动数据
- (void)bleResponseForDeletingActivityData:(NSError *)error;
///手动删除睡眠数据
- (void)bleResponseForDeletingSleepData:(NSError *)error;
///回调 获取设备端运动/睡眠模式
- (void)bleResponseForDeviceSportOrSleepState:(NSUInteger)state error:(NSError *)error;
///回调获取心率数据
- (void)bleResponseForHeartRateData:(NSArray *)data error:(NSError *)error;
///删除心率数据
- (void)bleResponseForDeleteHeartRateData:(NSError *)error;

#pragma mark - User Information
///设置个人信息
- (void)bleResponseForSettingUserInformation:(NSError *)error;
///获取个人信息
- (void)bleResponseForGettingUserGender:(BOOL)isFemail
								 height:(NSUInteger)height
								 weight:(NSUInteger)weight
							   birthday:(NSString *)birthday
								  error:(NSError *)error;
#pragma mark - Reminders
///添加提醒
- (void)bleResponseForAddingReminder:(NSError *)error;
///修改提醒
- (void)bleResponseForReplacingReminder:(NSError *)error;
///删除单条提醒
- (void)bleResponseForDeletingReminder:(NSError *)error;
///清空提醒
- (void)bleResponseForCleanUpReminder:(NSError *)error;
///查询所有提醒
- (void)bleResponseForQueryingReminders:(NSArray *)reminders error:(NSError *)error;
///查询震动
- (void)bleResponseForVibration:(int)data error:(NSError *)error;
///查询时间格式
- (void)bleResponseForQueryTimeFormat:(int)data error:(NSError *)error;
- (void)bleResponseForqueryUnitFormat:(int)data error:(NSError *)error;
#pragma mark - Settings
///恢复出厂设置
- (void)bleResponseForResetting:(NSError *)error;
///设置日期时间
- (void)bleResponseForSetDateTime:(NSError *)error;
///设置OLED亮度
- (void)bleResponseForSetOLEDLightness:(NSError *)error;

///获取目标
- (void)bleResponseForGetDeviceGoals:(CCBluetoothGoalData *)goals error:(NSError *)error;

///设置步数 目标
- (void)bleResponseForSetStepsTarget:(NSError *)error;
///设置距离目标(米)
- (void)bleResponseForSetDistanceTarget:(NSError *)error;
///设置卡路里目标(千卡)
- (void)bleResponseForSetCaloryTarget:(NSError *)error;

///回调设置运动时长目标
- (void)bleResponseForSetActiveMinutesTarget:(NSError *)error;

///设置自动进入睡眠时间
- (void)bleResponseForSetAutoSleepWithTime:(NSError *)error;
///回调设置通知
- (void)bleResponseForSetNotifyState:(NSError *)error;
///回调久坐提醒
- (void)bleResponseForSetInactivityAlert:(NSError *)error;
///回调设置显示日期、时间、是否英制单位格式
- (void)bleResponseForSetDateTimeUnitFormat:(NSError *)error;
///获取音量
- (void)bleResponseForVolume:(CCBluetoothVolumeLevel)volume error:(NSError *)error;
///OTA进度回调
- (void)bleResponseForOTA:(float)percent error:(NSError *)error;

///回调设置用户名称
- (void)bleResponseForSetUserName:(NSError *)error;

///回调发送设备是否绑定的状态
- (void)bleResponseForsendDeviceIsBindState:(NSUInteger)bindState error:(NSError *)error;

///回调设置自动心率监测
- (void)bleResponseForSetHeartRateFrequency:(NSError *)error;
///回调设置心率 上限 下限值及报警
- (void)bleResponseForSetHeartRateRangeOrAlarm:(NSError *)error;

///回调设置心率打开 报警
- (void)bleResponseForSetHeartRateOpenAlarm:(NSError *)error;

///回调设置心率 关闭 报警
- (void)bleResponseForSetHeartRateCloseAlarm:(NSError *)error;

///回调设置心率 上限
- (void)bleResponseForSetHeartRateMaxValue:(NSError *)error;

///回调设置心率 下限值
- (void)bleResponseForSetHeartRateMinValue:(NSError *)error;
- (void)bleResponseForSetHeartLowHighValueAndAlarm:(NSError *)error;
///设置自定义提醒名称
- (void)bleResponseForSendCustomRemindName:(NSError *)error;

///回调设置用户ID
- (void)bleResponseForSetUserIDToDevice:(BOOL)boolState error:(NSError *)error;

///回调获取用户ID
- (void)bleResponseForGetUserIDFromDevice:(NSUInteger)userID error:(NSError *)error;
- (void)bleResponseForSetVibrationOrder:(NSError *)error;
- (void)bleResponseForSetBeginBindOrder:(BOOL)boolState error:(NSError *)error;
- (void)bleResponseForSetEndBindOrder:(NSError *)error;

- (void)bleResponseForSetSleepTarget:(NSError *)error;
- (void)bleResponseForSetDeviceStateIsOpen:(NSError *)error;

///获取心率数据总数量
- (void)bleResponseForHeartRateDataCount:(NSUInteger)count error:(NSError *)error;

- (void)bleResponseForSetDateTimeFormat:(NSError *)error;

- (void)bleResponseForSetUnitFormat:(NSError *)error;

- (void)bleResponseForBeginUpdateByType:(NSError *)error;

///获取心率监测间隔
- (void)bleResponseForGetHeartMonitorFrequency:(NSUInteger)i error:(NSError *)error;

- (void)bleResponseForGetHeartLowHighAlarm:(NSArray *)data error:(NSError *)error;

- (void)bleResponseForGetDeviceOnOffState:(NSArray *)state error:(NSError *)error;

- (void)bleResponseForGetInactivityAlert:(CCBluetoothInactivityAlertyData *)data error:(NSError *)error;
- (void)bleResponseForSendInactivityAlert:(NSError *)error;

///获取设备睡眠状态
- (void)bleResponseForGetDevicePresentState:(NSArray *)data error:(NSError *)error;

///获取久坐提醒提醒状态
- (void)bleResponseForgetDeviceSedentaryReminder:(NSArray *)data error:(NSError *)error;

///获取当前情绪值
- (void)bleResponseForGetCurrentEmotionNumber:(NSInteger)emtionNumber error:(NSError *)error;

///Her灯光控制
- (void)bleResponseForSetLightStateForHer:(NSError *)error;

@end

#endif /* CCBluetoothDeviceProtocol_h */
