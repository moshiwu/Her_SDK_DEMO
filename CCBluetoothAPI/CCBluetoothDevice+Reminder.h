//
//  CCBluetoothDevice+Reminder.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/13.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "CCBluetoothDevice.h"

@interface CCBluetoothDevice (Reminder)
///添加提醒
- (void)addReminder:(CCBluetoothReminder *)reminder;

///自定义提醒
- (void)addCustomReminder:(CCBluetoothReminder *)reminder strCustomName:(NSString *)strCustomName;

/**
 * 修改提醒
 *
 * @param src  原提醒
 * @param dest 新提醒
 */
- (void)replaceReminder:(CCBluetoothReminder *)src withDest:(CCBluetoothReminder *)dest;

///查询所有提醒
- (void)queryReminder:(CCBluetoothReminder *)reminder;
///删除提醒
- (void)deleteReminder:(CCBluetoothReminder *)reminder;
///删除全部提醒
- (void)cleanUpAllReminders;
@end
