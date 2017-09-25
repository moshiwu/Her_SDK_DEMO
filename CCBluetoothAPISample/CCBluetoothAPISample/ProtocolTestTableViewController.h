//
//  ProtocolTestTableViewController.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/12.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import <CCBluetoothAPI/CCBluetoothAPI.h>
//#import "CCBluetoothAPI.h"


@class CCBluetoothDevice;
@interface ProtocolTestTableViewController : UITableViewController
@property (nonatomic, strong) CCBluetoothDevice *device;
@end
