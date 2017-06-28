//
//  CCBluetoothDevice+FirmwareInfo.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/12.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBluetoothDevice.h"
@interface CCBluetoothDevice (FirmwareInfo)
///设备类型
- (void)gettingDeviceType;
///电池电量
- (void)gettingBatteryPower;
///watchid
- (void)gettingWatchID;
///固件版本
- (void)gettingFirmwareVersion;
///固件ID
- (void)gettingFirmwareID;

@end
