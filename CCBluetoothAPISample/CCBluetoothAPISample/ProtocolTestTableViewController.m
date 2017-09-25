//
//  ProtocolTestTableViewController.m
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/12.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "ProtocolTestTableViewController.h"
#import <iOSDFULibrary/iOSDFULibrary-Swift.h>
#import "Sample-Swift.h"
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#define MasterCreate CCBluetoothMaster * master = [CCBluetoothMaster sharedInstance]; master.mainDeviceName = self.device.name;
#define MasterCommit [master commit];

@interface ProtocolTestTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *titlesArray;

@property (nonatomic, strong) DFUHelper *dfuHelper;

@property (strong, nonatomic) UITextField *tf;

@end

@implementation ProtocolTestTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    _titlesArray = @[
                     TR(@"电量"),
                     TR(@"Watch ID"),
                     TR(@"固件版本"),
                     TR(@"恢复出厂设置"),
                     TR(@"运动数据"),
                     TR(@"运动数据数量"),
                     TR(@"睡眠数据"),
                     TR(@"睡眠数据数量"),
                     TR(@"手动删除运动数据"),
                     TR(@"手动删除睡眠数据"),
                     TR(@"灯光控制"),
                     TR(@"打开计步"),
                     TR(@"关闭计步"),
                     TR(@"打开紫外灯监控"),
                     TR(@"关闭紫外灯监控"),
                     TR(@"OTA"),
                     TR(@"心率(心情)数据"), //某些型号使用心率模块当成心情数据
                     TR(@"心率(心情)数据数量"),
                     TR(@"主动开启心率测量"),
                     TR(@"血压数据"),
                     TR(@"血压数据数量"),
                     TR(@"主动开启血压测量")
     ];
    
    //do not set delegate when using CCBluetoothMaster
    //    self.device.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveShortTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveLongTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveShutDownTapNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveLowPowerNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveHeartRateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveBloodPressureRateNotification object:nil];
}

- (void)notification_handler:(NSNotification *)noti
{
    NSLog(@"receive notification : %@", noti.name);
    
    if ([noti.name isEqualToString:CCBluetoothDidReceiveShortTapNotification])
    {
        [self showMessage:TR(@"收到短按通知")];
    }
    else if ([noti.name isEqualToString:CCBluetoothDidReceiveLongTapNotification])
    {
        [self showMessage:TR(@"收到长按通知")];
    }
    else if ([noti.name isEqualToString:CCBluetoothDidReceiveShutDownTapNotification])
    {
        [self showMessage:TR(@"收到关机通知")];
    }
    else if ([noti.name isEqualToString:CCBluetoothDidReceiveLowPowerNotification])
    {
        [self showMessage:TR(@"收到低电通知")];
    }
    else if ([noti.name isEqualToString:CCBluetoothDidReceiveHeartRateNotification])
    {
        //        [self showMessage:[NSString stringWithFormat:@"%@ %@", TR(@"收到即时心率"), noti.object]];
        NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", TR(@"收到即时心率"), noti.object]);
    }
    else if ([noti.name isEqualToString:CCBluetoothDidReceiveBloodPressureRateNotification])
    {
        [self showMessage:[NSString stringWithFormat:@"%@ %@", TR(@"收到单条血压数据"), noti.object]];
    }
}

- (void)showMessage:(NSString *)message
{
    [self showHudAutoHideStringWithSuccess:message];
}

- (void)showResponse:(id)r error:(NSError *)error
{
    if (error)
    {
        [self showHudAutoHideStringWithError:[NSString stringWithFormat:@"%@, %@", r, error.localizedDescription]];
    }
    else
    {
        [self showMessage:r == nil ? r :[NSString stringWithFormat:@"%@", r]];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? _titlesArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSString *reuseId = [NSString stringWithFormat:@"BasicCellID-%@", indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _titlesArray[indexPath.row];
        
        return cell;
    }
    else
    {
        NSString *reuseId = @"太麻烦了随便写";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(btn_handler:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:TR(@"修改") forState:UIControlStateNormal];
            [cell addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell).offset(-12);
                make.centerY.equalTo(cell);
                make.width.equalTo(@50);
                make.height.equalTo(cell).multipliedBy(0.8);
            }];
            
            UITextField *tf = [[UITextField alloc] init];
            tf.placeholder = TR(@"输入8位后缀");
            tf.text = @"1739";
            tf.delegate = self;
            tf.keyboardType = UIKeyboardTypeNumberPad;
        
            [cell addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell).offset(12);
                make.centerY.equalTo(cell);
                make.height.equalTo(cell).multipliedBy(0.8);
                make.right.equalTo(btn.mas_left).offset(-12);
            }];
            
            self.tf = tf;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    
    NSString *title = self.titlesArray[row];
    
    __weak MasterCreate;
    
    [master setDevice:self.device];
    
    MyWeakSelf;
    
    CCBluetoothMasterSuccess successBlock = ^(id object)
    {
        [ws hideHud];
        [ws showResponse:object error:nil];
    };
    
    CCBluetoothMasterFailure failureBlock = ^(NSError *error)
    {
        [ws hideHud];
        [ws showResponse:nil error:error];
    };
    
    dispatch_group_t group = dispatch_group_create();
    
    if ([TR(@"电量") isEqualToString:title])
    {
        [master addTask:@selector(gettingBatteryPower)
                 params:nil
                success:^(id object)
         {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", object];
             successBlock(nil);
         }
                failure:failureBlock];
    }
    else if ([TR(@"Watch ID") isEqualToString:title])
    {
        [master addTask:@selector(gettingWatchID)
                 params:nil
                success:^(id object)
         {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", object];
             successBlock(nil);
         }
                failure:failureBlock];
    }
    else if ([TR(@"固件版本") isEqualToString:title])
    {
        [master addTask:@selector(gettingFirmwareVersion)
                 params:nil
                success:^(id object)
         {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", object];
             successBlock(nil);
         }
                failure:failureBlock];
    }
    else if ([TR(@"恢复出厂设置") isEqualToString:title])
    {
        [master addTask:@selector(resetDevice)
                 params:nil
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"运动数据数量") isEqualToString:title])
    {
        [master addTask:@selector(getActivityDataCount)
                 params:nil
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"运动数据") isEqualToString:title])
    {
        //sample 1
        [master addTask:@selector(getActivityDataCount)
                 params:nil
                success:^(id object) {
                    int sportCount = [object intValue];
                    
                    [master addTask:@selector(getActivityDataByCount:)
                             params:@[@(sportCount)]
                            success:successBlock
                            failure:failureBlock];
                    
                    //如果在block里面增加任务，不要使用commit
                    //do not commit in add task block
                    //MasterCommit
                } failure:failureBlock];
    }
    else if ([TR(@"睡眠数据数量") isEqualToString:title])
    {
        [master addTask:@selector(getSleepDataCount)
                 params:nil
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"睡眠数据") isEqualToString:title])
    {
        //sample 2
        __block int sleepCount = 0;
        
        dispatch_group_enter(group);
        [master addTask:@selector(getSleepDataCount)
                 params:nil
                success:^(id object) {
                    sleepCount = [object intValue];
                    dispatch_group_leave(group);
                } failure:^(NSError *error) {
                    dispatch_group_leave(group);
                }];
        
        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
        
        if (sleepCount > 0)
        {
            [master addTask:@selector(getSleepDataByCount:)
                     params:@[@(sleepCount)]
                    success:successBlock
                    failure:failureBlock];
            
            //must commit outside add task block
            MasterCommit;
        }
    }
    else if ([TR(@"手动删除运动数据") isEqualToString:title])
    {
        [master addTask:@selector(manuallyDeleteActivityData)
                 params:nil
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"手动删除睡眠数据") isEqualToString:title])
    {
        [master addTask:@selector(manuallyDeleteSleepData)
                 params:nil
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"灯光控制") isEqualToString:title])
    {
        CCBluetoothLightControlModel *model1 = [CCBluetoothLightControlModel allOpenModel];
        model1.threeColorsLightState = CCBluetoothLightStateRed;
        CCBluetoothLightControlModel *model2 = [CCBluetoothLightControlModel allOpenModel];
        model2.threeColorsLightState = CCBluetoothLightStateBlue;
        CCBluetoothLightControlModel *model3 = [CCBluetoothLightControlModel allOpenModel];
        model3.threeColorsLightState = CCBluetoothLightStateGreen;
        CCBluetoothLightControlModel *model4 = [CCBluetoothLightControlModel allOpenModel];
        model4.threeColorsLightState = CCBluetoothLightStateAllOpen;
        
        CCBluetoothLightControlModel *modelClose = [CCBluetoothLightControlModel allCloseModel];
        
        int count = 1;
        
        for (int i = 0; i < count; i++)
        {
            [master addTask:@selector(setLightStateForHer:) params:@[model1] success:nil failure:nil];
            [master addTask:@selector(setLightStateForHer:) params:@[modelClose] success:nil failure:nil];
            [master addTask:@selector(setLightStateForHer:) params:@[model2] success:nil failure:nil];
            [master addTask:@selector(setLightStateForHer:) params:@[modelClose] success:nil failure:nil];
            [master addTask:@selector(setLightStateForHer:) params:@[model3] success:nil failure:nil];
            [master addTask:@selector(setLightStateForHer:) params:@[modelClose] success:nil failure:nil];
            [master addTask:@selector(setLightStateForHer:) params:@[model4] success:nil failure:nil];
            [master addTask:@selector(setLightStateForHer:) params:@[modelClose] success:i == count - 1 ? successBlock : nil failure:i == count - 1 ? failureBlock : nil];
        }
    }
    else if ([TR(@"打开计步") isEqualToString:title])
    {
        [master addTask:@selector(setDeviceStateIsOpen:andIsOpen:)
                 params:@[@(CCBluetoothDeviceStateTagPodemeter), @1]
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"关闭计步") isEqualToString:title])
    {
        [master addTask:@selector(setDeviceStateIsOpen:andIsOpen:)
                 params:@[@(CCBluetoothDeviceStateTagPodemeter), @0]
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"打开紫外灯监控") isEqualToString:title])
    {
        [master addTask:@selector(setDeviceStateIsOpen:andIsOpen:)
                 params:@[@(CCBluetoothDeviceStateTagUVMonitoring), @1]
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"关闭紫外灯监控") isEqualToString:title])
    {
        [master addTask:@selector(setDeviceStateIsOpen:andIsOpen:)
                 params:@[@(CCBluetoothDeviceStateTagUVMonitoring), @0]
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"OTA") isEqualToString:title])
    {
        dispatch_async(dispatch_queue_create("no-label", DISPATCH_QUEUE_CONCURRENT), ^{
            __block NSString *localVersion = nil;
            __block NSString *remoteVersion = nil;
            __block NSString *updateUrl = nil;
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            dispatch_group_enter(group);
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [manager POST:@"https://new.fashioncomm.com/device/queryProductVersion"
               parameters:@{
                            @"seq" : [NSString stringWithFormat:@"%f", [NSDate date].timeIntervalSince1970],
                            @"versionNo" : @"112",
                            @"clientType" : @"iphone",
                            @"productCode" : @"wt10ahk_oem_her",
                            @"customerCode" : @"WT10A_HK",
                            }
                 progress:nil
                  success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                      NSLog(@"%@", responseObject);
                      remoteVersion = responseObject[@"crmProductVersion"][@"deviceVersion"];
                      updateUrl = responseObject[@"crmProductVersion"][@"updateUrl"];
                      
                      dispatch_group_leave(group);
                  }
                  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                      NSLog(@"query remote firmware version fail");
                  }];
            
            dispatch_group_enter(group);
            
            [master addTask:@selector(gettingFirmwareVersion)
                     params:nil
                    success:^(id object) {
                        localVersion = (NSString *)object;
                        dispatch_group_leave(group);
                    }
                    failure:^(NSError *error) {
                        NSLog(@"query local firmware version fail");
                    }];
            
            MasterCommit;
            
            long mask = dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
            
            if (mask != 0)
            {
                NSLog(@"error");
            }
            else
            {
                NSLog(@"local : %@  remote : %@", localVersion, remoteVersion);
                
                if (remoteVersion.floatValue > localVersion.floatValue)
                {
                    NSLog(@"need upgrade");
                    
                    __block NSURL *filePath = nil;
                    
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    dispatch_group_enter(group);
                    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:updateUrl]]
                                                                             progress:^(NSProgress *_Nonnull downloadProgress) {
                                                                                 NSLog(@"file download progress : %@", downloadProgress);
                                                                             }
                                                                          destination:^NSURL *_Nonnull (NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response) {
                                                                              NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                                              return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                          }
                                                                    completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable path, NSError *_Nullable error) {
                                                                        NSLog(@"file path : %@", path);
                                                                        filePath = path;
                                                                        dispatch_group_leave(group);
                                                                    }];
                    
                    [task resume];
                    
                    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC));
                    
                    if (filePath)
                    {
                        //change device mode for DFU
                        [master addTask:@selector(beginUpdateByType:) params:@[@9] success:^(id object) {
                            NSLog(@"change mode success");
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [ws upgradingWithFilePath:filePath];
                            });
                        } failure:^(NSError *error) {
                            NSLog(@"change mode fail");
                        }];
                        
                        MasterCommit;
                    }
                    else
                    {
                        NSLog(@"file download fail");
                    }
                }
                else
                {
                    NSLog(@"No upgrade required");
                }
            }
        });
        return;
    }
    else if ([TR(@"心率(心情)数据") isEqualToString:title]) //某些型号使用心率模块当成心情数据
    {
        [master addTask:@selector(getHeartRateOrEmotionDataCount)
                 params:nil
                success:^(id object) {
                    int count = [object intValue];
                    
                    [master addTask:@selector(getHeartRateDataOrEmotionDataByCount:isHeartRateData:)
                             params:@[@(count), @YES]
                            success:successBlock
                            failure:failureBlock];
                    
                    //如果在block里面增加任务，不要使用commit
                    //do not commit in add task block
                    //MasterCommit
                } failure:failureBlock];
    }
    else if ([TR(@"心率(心情)数据数量") isEqualToString:title])
    {
        [master addTask:@selector(getHeartRateOrEmotionDataCount)
                 params:nil
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"血压数据") isEqualToString:title])
    {
        [master addTask:@selector(getBloodPressureCount)
                 params:nil
                success:^(id object) {
                    int count = [object intValue];
                    
                    [master addTask:@selector(getBloodPressureByCount:)
                             params:@[@(count)]
                            success:successBlock
                            failure:failureBlock];
                    
                    //如果在block里面增加任务，不要使用commit
                    //do not commit in add task block
                    //MasterCommit
                } failure:failureBlock];
    }
    else if ([TR(@"血压数据数量") isEqualToString:title])
    {
        [master addTask:@selector(getBloodPressureCount)
                 params:nil
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"主动开启心率测量") isEqualToString:title])
    {
        //开启心率测量后，在30~60秒后，设备里面心率条数会增加1，不会主动推送消息过来（区别于血压），所以需要自己定时用getHeartRateOrEmotionDataCount来查询条数
        [master addTask:@selector(manuallyOpenModule:)
                 params:@[@(CCBlueToothManuallyModuleHeartRate)]
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"主动开启血压测量") isEqualToString:title])
    {
        //开启血压测量后，30~60秒后，会主动推送一条消息（CCBluetoothDidReceiveBloodPressureRateNotification）
        [master addTask:@selector(manuallyOpenModule:)
                 params:@[@(CCBlueToothManuallyModuleBloodPressure)]
                success:successBlock
                failure:failureBlock];
    }
    else if ([TR(@"固件MAC地址") isEqualToString:title])
    {
        [master addTask:@selector(gettingFirmwareMACAddress)
                 params:nil
                success:^(id object)
         {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", object];
             successBlock(nil);
         }
                failure:failureBlock];
    }
    else if ([TR(@"主动断开连接") isEqualToString:title])
    {
        [master.mainDevice disableReconnect]; //如果不是使用CCBluetoothMaster，直接使用CCBluetoothDevice也可以
        [master.mainDevice disConnectWithCompletion:^(CCBluetoothDevice *device, NSError *error) {
            NSLog(@"断开连接");
        }];
        
        return;
    }
    else if ([TR(@"测试Sensor") isEqualToString:title])
    {
        //        [master addTask:@selector(testSensor) params:nil success:successBlock failure:failureBlock];
        [master addTask:@selector(testSensor) params:nil success:^(id object) {
            [ws hideHud];
            [ws showResponse:nil error:nil];
        } failure:failureBlock];
    }
    
    [self showHudWithLoading];
    MasterCommit;
}

- (void)upgradingWithFilePath:(NSURL *)filePath
{
    NSString *deviceName = @"10#00000";
    
    NSLog(@"try to start OTA");
    self.dfuHelper = [[DFUHelper alloc] initWithPeripheralName:deviceName
                                                           url:filePath
                                                      progress:^(NSInteger progress, NSString *_Nonnull message) {
                                                          NSLog(@"progress %ld %@", progress, message);
                                                      } success:^(NSInteger code, NSString *_Nonnull message) {
                                                          NSLog(@"success %ld %@", code, message);
                                                      } failure:^(NSInteger code, NSString *_Nonnull message) {
                                                          NSLog(@"faile %ld %@", code, message);
                                                      }];
}

- (void)btn_handler:(id)sender
{
    __weak MasterCreate;
    
    [master setDevice:self.device];
    
    MyWeakSelf;
    
    CCBluetoothMasterSuccess successBlock = ^(id object)
    {
        [ws hideHud];
        [ws showResponse:object error:nil];
    };
    
    CCBluetoothMasterFailure failureBlock = ^(NSError *error)
    {
        [ws hideHud];
        [ws showResponse:nil error:error];
    };
    
    [master addTask:@selector(testForChangeWatchId:)
             params:@[self.tf.text]
            success:successBlock
            failure:failureBlock];
    
    [master commit];
}

#pragma mark - UITextFiele Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (result.length > 8)
    {
        return NO;
    }
    
    return YES;
}

@end
