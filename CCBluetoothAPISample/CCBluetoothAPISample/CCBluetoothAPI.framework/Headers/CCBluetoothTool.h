//
//  CCBluetoothTool.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/9.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCBluetoothDataTypes.h"

@interface CCBluetoothTool : NSObject
///错误信息
+ (NSString *)errorMessageWithCode:(CCErrorCode)code;
///错误
+ (NSError *)errorWithCode:(CCErrorCode)code;
///从bytes的index开始获取4个字节组成整数
+ (NSUInteger)integerFromBytes:(const Byte *)bytes index:(Byte)index;
///获取integer的第index个字节
+ (Byte)byteFromInteger:(NSUInteger)integer atIndex:(NSUInteger)index;
@end

@interface NSString (binaryChange)

+ (NSString *)binaryStringWithInteger:(NSInteger)value;

@end
