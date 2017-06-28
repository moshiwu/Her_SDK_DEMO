//
//  CCBluetoothDevice+UserInfo.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/15.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "CCBluetoothDevice.h"
#import <UIKit/UIKit.h>

@interface CCBluetoothDevice (UserInfo)

/**
 * 设置用户的个人信息
 *
 * @param isFemale    性别，Yes为女
 * @param height      身高，单位为cm
 * @param weight      体重，单位为g
 * @param birthday    生日，格式为"yyyy-MM-dd"
 * @param isCleanData 是否清除设备的数据
 */
- (void)setUserInformationWithGender:(BOOL)isFemale
							  height:(CGFloat)height
							  weight:(CGFloat)weight
							birthday:(NSInteger)birthday
						   cleanData:(BOOL)isCleanData;

/**
 * 获取用户的个人信息
 */
- (void)getUserInformation;
@end
