//
//  ProtocolTestTableViewController.h
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/12.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TR(a) NSLocalizedString(a, a)

@class CCBluetoothDevice;
@interface ProtocolTestTableViewController : UITableViewController
@property (nonatomic, strong) CCBluetoothDevice *device;
@end
