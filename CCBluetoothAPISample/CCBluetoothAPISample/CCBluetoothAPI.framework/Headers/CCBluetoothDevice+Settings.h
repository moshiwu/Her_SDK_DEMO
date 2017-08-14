//
//  CCBluetoothDevice+Settings.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/13.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "CCBluetoothDevice.h"

@interface CCBluetoothDevice (Settings)
///重置设备
- (void)resetDevice;

///获取音量值
- (void)gettingVolume;

///获取设备所有目标值
- (void)getDeviceGoals;

///设置日期时间  dateTime 格式为"yyyy-MM-dd HH:mm:ss"
- (void)setDateTime:(NSString *)dateTime;

///设置OLED亮度  lightness 亮度等级
- (void)setOLEDLightness:(CCBluetoothOLEDLightnessLevel)lightness;

///设置步数目标
- (void)setStepsTarget:(int)stepsGoal;

///设置卡路里目标(千卡)
- (void)setCaloryTarget:(int)calGoal;

///设置距离目标(米)
- (void)setDistanceTarget:(int)distGoal;

///设置运动时长(分钟)
- (void)setActiveMinutesTarget:(int)activeMinutesGoal;

///设置自动进入睡眠时间
- (void)setAutoSleepWithStartHour:(int)startHour
					  andStartMin:(int)startMin
					   andEndHour:(int)endHour
						andEndMin:(int)endMin;

- (void)setAutoSleepWithStartHour:(int)startHour
					  andStartMin:(int)startMin
					   andEndHour:(int)endHour
						andEndMin:(int)endMin
						andPeriod:(int)period;

///设置消息通知开关
- (void)setCallsNotifyState:(BOOL)callIsOpened
	 missedCallsNotifyState:(BOOL)missedCallIsOpened
			 SMSNotifyState:(BOOL)SMSIsOpened
		   emailNotifyState:(BOOL)emailIsOpened
	 socialMediaNotifyState:(BOOL)socialIsOpened
		calendarNotifyState:(BOOL)calendarIsOpened
		antiLostNotifyState:(BOOL)antiLostIsOpened;

///获取通知开关状态
- (void)getDeviceOnOffState;

///久坐提醒
- (void)getInactivityAlert;
- (void)setInactivityAlert:(BOOL)isOpen
				  interval:(int)interval
				 startHour:(int)startHour
			   startMinute:(int)startMinute
				   endHour:(int)endHour
				 endMinute:(int)endMinute
					period:(NSString *)periodString;

///设置显示日期、时间、是否英制单位格式
- (void)setDateTimeUnitFormat:(int)dateFormat
				   timeFormat:(int)timeFormat
				   unitFormat:(int)unitFormat;

///设置名称
- (void)setUserName:(NSString *)userName;

///发送设备是否绑定的状态
- (void)sendDeviceIsBindState:(int)intState;

///设置自动心率监测
- (void)setHeartRateMonitorFrequency:(int)timeFrequency;

///设置心率 上限 下限值及报警
- (void)setHeartRateRangeOrAlarm:(int)intType intValue:(int)intValue;
- (void)setHeartLowHighValueAndAlarm:(int)intType intLowValue:(int)intLowValue intHignValue:(int)intHignValue;

///设置自定义提醒名称
- (void)sendCustomRemindNameOrder:(NSString *)remindName;

///设置用户ID
- (void)setUserIDToDevice:(int)userID;

///获取用户ID
- (void)getUserIDFromDevice;

///获取设备睡眠状态
- (void)getDevicePresentState;

///获取就坐提醒状态
- (void)getDeviceSedentaryReminder;

///查询震动
- (void)vibration;

///查询时间格式
- (void)queryTimeFormat;

///获取当前情绪值
- (void)getCurrentEmotion;

///设置震动
- (void)setVibrationOrder:(int)intValue;
- (void)setBeginBindOrder;
- (void)setEndBindOrder;

- (void)setDateTimeFormat:(int)dateFormat;

- (void)setDateUnitFormat:(int)unitFormat;


- (void)setSleepTarget:(int)goalValue;

- (void)setDeviceStateIsOpen:(CCBluetoothDeviceStateTag)intType andIsOpen:(int)isOpen;


- (void)beginUpdateByType:(int)intType;

- (void)getHeartMonitorFrequency;
- (void)getHeartLowHighValueAndAlarm;

- (void)sendInactivityAlert:(BOOL)isOpen
				   internal:(int)internal
				  startHour:(int)startHour
				startMinute:(int)startMinute
					endHour:(int)endHour
				  endMinute:(int)endMinute
					 period:(NSString *)strPeriod
					  steps:(int)steps;

/**
 *  查询设备端单位格式设置
 */
- (void)queryUnitFormat;

/**
 *  灯光控制，仅限Her
 *  light controll for Her only.
 */
- (void)setLightStateForHer:(CCBluetoothLightControlModel *)stateModel;

- (void)setWeather:(CCWeatherType)type temperature:(int)temperature aqi:(CCAirQualityIndexType)aqi city:(NSString *)city;



#pragma mark - 主动回复设备

- (void)responseToDeviceWithCode:(int)reponseCode status:(CCStatusResponseToDevice)status;

/// 查询当前系统音乐的播放状态  正在播放/未在播放
- (void)responseToDeviceWithPlaybackState:(BOOL)playing;
- (void)responseToDeviceWithPlayingMediaTitle:(NSString *)title isPlaying:(BOOL)playing;

@end
