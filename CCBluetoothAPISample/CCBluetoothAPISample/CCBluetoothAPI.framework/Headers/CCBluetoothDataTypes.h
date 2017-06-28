//
//  CCBluetoothDataTypes.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/9.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Enum -
///设备类型
typedef NS_ENUM (NSInteger, CCBluetoothDeviceType)
{
	///未知设备
	CCBluetoothDeviceTypeUnknown = 0x00,
	///L28C中文版
	CCBluetoothDeviceTypeL28C_CN = 0x0A,
	///L28C英文版
	CCBluetoothDeviceTypeL28C_EN = 0x0B,
	///L28S英文版
	CCBluetoothDeviceTypeL28CA_EN = 0x0C,
	///L28S简体中文版
	CCBluetoothDeviceTypeL28CA_CN = 0x0D,
	///L28S繁体中文版
	CCBluetoothDeviceTypeL28CA_TR = 0x0E,
	///L28T
	CCBluetoothDeviceTypeL28T = 0x10,
	///L28T ICON版
	CCBluetoothDeviceTypeL28T_ICON = 0x11,
	///L28T中文版
	CCBluetoothDeviceTypeL28T_CN = 0x12,
	///L11A
	CCBluetoothDeviceTypeL11A = 0x20,
	///L28W
	CCBluetoothDeviceTypeL28W = 0x21,
	///L38A
	CCBluetoothDeviceTypeL38A = 0x30,
	///W01
	CCBluetoothDeviceTypeW01 = 0x50,
};

///协议类型
typedef NS_ENUM (NSInteger, CCBluetoothProtocolType)
{
	///统一协议
	CCBluetoothProtocolTypeUnite = 0,
	///L38协议
	CCBluetoothProtocolTypeL38 = 1,
	CCBluetoothProtocolType2016 = 2,
};

///错误码
typedef NS_ENUM (NSInteger, CCErrorCode)
{
	///蓝牙未打开
	CCErrorCodeBluetoothSettingNotOpened = 7001,
	///连接设备超时
	CCErrorCodeConnectingDeviceTimeout,
	///设备未连接
	CCErrorCodeDeviceNotConnected,
	///设备响应数据错误
	CCErrorCodeWrongResponseData,
	///设备未响应
	CCErrorCodeDeviceNoResponse,
	///设备响应错误参数
	CCErrorCodeResponseWithFailure,
	///设备响应非法命令
	CCErrorCodeResponseWithIllegalParameters,
	///OTA升级失败
	CCErrorCodeResponseWithOTAFail,
	///没有搜索到设备
	CCErrorCodeSearchNoDevice,
	///灯光配置错误
	CCErrorCodeLightSettingIncorrect,
};

/*
 *  提醒类型，每一种设备只支持6种类型
 */
typedef NS_ENUM (NSUInteger, CCBluetoothReminderType)
{
	///吃饭
	CCBluetoothReminderTypeEat = 0x01,
	///吃药
	CCBluetoothReminderTypeMadicine = 0x02,
	///运动
	CCBluetoothReminderTypeActivity = 0x03,
	///睡觉
	CCBluetoothReminderTypeSleep = 0x04,
	///喝水
	CCBluetoothReminderTypeDrinkWater = 0x05,
	///清醒(起床)
	CCBluetoothReminderTypeWakeup = 0x06,
	///会议
	CCBluetoothReminderTypeMeeting = 0x07,
	///自定义
	CCBluetoothReminderTypeCustom = 0x80,
};

/*
 *  周期类型
 */
typedef NS_OPTIONS (NSUInteger, CCBluetoothPeriod)
{
	///星期一
	CCBluetoothPeriodMonday = 1 << 0,
	    ///星期二
		CCBluetoothPeriodTuesday = 1 << 1,
	    ///星期三
		CCBluetoothPeriodWednesday = 1 << 2,
	    ///星期四
		CCBluetoothPeriodThursday = 1 << 3,
	    ///星期五
		CCBluetoothPeriodFriday = 1 << 4,
	    ///星期六
		CCBluetoothPeriodSaturday = 1 << 5,
	    ///星期日
		CCBluetoothPeriodSunday = 1 << 6,
};

/*
 *  睡眠类型
 */
typedef NS_ENUM (NSUInteger, CCBluetoothSleepType)
{
	///开始
	CCBluetoothSleepTypeStart = 16,
	///入睡(真正开始睡觉)
	CCBluetoothSleepTypeFallSleep = 3,
	///浅睡
	CCBluetoothSleepTypelightSleep = 1,
	///深睡
	CCBluetoothSleepTypeDeepSleep = 0,
	///清醒
	CCBluetoothSleepTypeWakeup = 2,
	///结束
	CCBluetoothSleepTypeEnd = 17,
	///预设睡眠时间
	CCBluetoothSleepTypePresetSleepTime = 18,
};

/**
 * 屏幕亮度等级,等级越高，屏幕越亮
 */
typedef NS_ENUM (NSInteger, CCBluetoothOLEDLightnessLevel)
{
	///亮度等级1
	CCBluetoothOLEDLightnessFirstLevel = 1,
	///亮度等级2
	CCBluetoothOLEDLightnessSecondLevel = 2,
	///亮度等级3
	CCBluetoothOLEDLightnessThirdLevel = 3,
	///亮度等级4
	CCBluetoothOLEDLightnessFourthLevel = 4,
	///亮度等级5
	CCBluetoothOLEDLightnessFifthLevel = 5,
};

/**
 * 音量等级,等级越高，音量越大
 */
typedef NS_ENUM (NSInteger, CCBluetoothVolumeLevel)
{
	///静音
	CCBluetoothVolumeSilent = 0,
	///音量等级1
	CCBluetoothVolumeFirstLevel = 1,
	///音量等级2
	CCBluetoothVolumeSecondLevel = 2,
	///音量等级3
	CCBluetoothVolumeThirdLevel = 3,
	///音量等级4
	CCBluetoothVolumeFourthLevel = 4,
	///音量等级5
	CCBluetoothVolumeFifthLevel = 5,
};

/**
 *  三色灯开关枚举，仅限Her
 *  enum for three-colors light, valid for Her only.
 */
typedef NS_ENUM (int, CCBluetoothLightState)
{
	CCBluetoothLightStateNone = 0x00,
	CCBluetoothLightStateRed = 0x01,
	CCBluetoothLightStateGreen = 0x02,
	CCBluetoothLightStateBlue = 0x03,
	CCBluetoothLightStateAllOpen = 0x04
};

/**
 * 设备开关，对应90指令
 */
typedef NS_ENUM (int, CCBluetoothDeviceStateTag)
{
	CCBluetoothDeviceStateTagAntiLost = 0x00,
	CCBluetoothDeviceStateTagAutoSync = 0x01,
	CCBluetoothDeviceStateTagSleep = 0x02,
	CCBluetoothDeviceStateTagAutoSleep = 0x03,
	CCBluetoothDeviceStateTagCall = 0x04,
	CCBluetoothDeviceStateTagMissedCall = 0x05,
	CCBluetoothDeviceStateTagMessage = 0x06,
	CCBluetoothDeviceStateTagSocialMessage = 0x07,
	CCBluetoothDeviceStateTagMail = 0x08,
	CCBluetoothDeviceStateTagCalendar = 0x09,
	CCBluetoothDeviceStateTagInactivityAlert = 0x0A,
	CCBluetoothDeviceStateTagLowPowerConsumption = 0x0B,
	CCBluetoothDeviceStateTagSecondReminder = 0x0C,
	CCBluetoothDeviceStateTagPodemeter = 0x0D,
	CCBluetoothDeviceStateTagUVMonitoring = 0x0E,
};

#pragma mark - Activity Data

/**
 * 运动数据
 */
@interface CCBluetoothActivityData : NSObject
///时间戳
@property (assign, nonatomic) NSUInteger timeStamp;
///步数
@property (assign, nonatomic) NSUInteger steps;
///卡路里
@property (assign, nonatomic) NSUInteger cals;
///距离
@property (assign, nonatomic) NSUInteger dist;
///运动时长
@property (assign, nonatomic) NSUInteger activeMinutes;
///索引值
@property (assign, nonatomic) NSUInteger index;

@property (assign, nonatomic) NSUInteger sleepTime;
@end;

#pragma mark - Sleep Data

/**
 *  睡眠详细数据类型
 */
@interface CCBluetoothSleepDetailData : NSObject
///睡眠类型
@property (nonatomic, assign) CCBluetoothSleepType sleepType;
///时间戳
@property (nonatomic, assign) NSUInteger timestamp;
@end

/**
 *  睡眠汇总数据类型
 */
@interface CCBluetoothSleepTotalData : NSObject
///详细数据,CCBluetoothSleepDetailData类型
@property (nonatomic, strong) NSArray *detailData;
///睡眠质量
@property (nonatomic, assign) NSUInteger quality;
///睡眠时长
@property (nonatomic, assign) NSUInteger sleepDuration;
///清醒时长
@property (nonatomic, assign) NSUInteger awakeDuration;
///浅睡时长
@property (nonatomic, assign) NSUInteger lightDuration;
///深睡时长
@property (nonatomic, assign) NSUInteger deepDuration;
///总的时间
@property (nonatomic, assign) NSUInteger totalDuration;
///清醒次数
@property (nonatomic, assign) NSUInteger awakeCount;
///睡眠日期(有预设睡眠的设备需要)，即这段睡眠所在的日期
@property (nonatomic, assign) NSUInteger sleepDate;

@end

#pragma mark - Reminder

/**
 *  提醒，用时间(hour，minute)和周期(period)作为唯一性的匹配条件,类似闹钟
 */
@interface CCBluetoothReminder : NSObject
///提醒类型
@property (nonatomic, assign) CCBluetoothReminderType type;

/**
 * 提醒周期, CCBluetoothPeriod类型，做'与'操作，
 * 比如周期是星期一和星期二，那么period就是CCBluetoothPeriodMonday | CCBluetoothPeriodTuesday
 */
@property (nonatomic, assign) NSUInteger period;
///提醒时间的小时
@property (nonatomic, assign) NSUInteger hour;
///提醒时间的分钟
@property (nonatomic, assign) NSUInteger minute;
///自定义类型的提醒内容
@property (nonatomic, copy) NSString *customContent;
///在设备里面的索引
@property (nonatomic, assign) NSUInteger index;

///是否等于另一个提醒
- (BOOL)isEqualWithObject:(CCBluetoothReminder *)object;
@end

#pragma mark - HeartRate

/**
 * 心率类型
 */
@interface CCBluetoothHeartRateData : NSObject
///0x00：停止, 0x01：自动, 0x02：手动, 0x03：心率数据上传状态
@property (nonatomic, assign) NSUInteger dataFlag;
///时间戳
@property (nonatomic, assign) NSUInteger timeStamp;
///心率值
@property (nonatomic, assign) NSUInteger heartRate;
@end

@interface HexData : NSObject
@property (nonatomic, strong) NSData *address;
@property (nonatomic, strong) NSData *data;
@end

#pragma mark - Goals

/**
 * 目标值
 */
@interface CCBluetoothGoalData : NSObject

@property (nonatomic, strong) NSNumber *steps;         //步数
@property (nonatomic, strong) NSNumber *distance;      //距离
@property (nonatomic, strong) NSNumber *activeMinutes; //运动时间-分钟
@property (nonatomic, strong) NSNumber *calories;      //卡路里
@property (nonatomic, strong) NSNumber *sleep;         //睡眠时间-小时

@end

#pragma mark - Inactivy Alert

@interface CCBluetoothInactivityAlertyData : NSObject

@property (nonatomic, assign) BOOL isOpen;           //开关
@property (nonatomic, assign) NSInteger internal;    //提醒间隔
@property (nonatomic, assign) NSInteger startHour;   //开始小时
@property (nonatomic, assign) NSInteger startMinute; //开始分钟
@property (nonatomic, assign) NSInteger endHour;     //结束小时
@property (nonatomic, assign) NSInteger endMinute;   //结束分钟
@property (nonatomic, assign) NSInteger steps;       //步数
@property (nonatomic, strong) NSString *period;      //周期

@end

#pragma mark - Emotion
@interface CCBluetoothEmotionData : NSObject
@property (nonatomic, assign) NSInteger emotionNumber;
@property (nonatomic, assign) long long timeStamp;
@end

#pragma mark - Light Control For Her
@interface CCBluetoothLightControlModel : NSObject
@property (nonatomic, strong) NSArray <NSNumber *> *lightingList; //list to lighting up, value from 1 to 12, and invalid at 2 or 3 o'clock.
@property (nonatomic, assign) CCBluetoothLightState threeColorsLightState;
+ (instancetype)allCloseModel;
+ (instancetype)allOpenModel;
@end
