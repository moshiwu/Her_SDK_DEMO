//
//  ViewController.m
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/9.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "ViewController.h"
#import "ProtocolTestTableViewController.h"
#import <iOSDFULibrary/iOSDFULibrary-Swift.h>
#import "Sample-Swift.h"
#import <AFNetworking/AFNetworking.h>
#import "UIViewController+HudAndTimer.h"

@interface ViewController ()

@property (nonatomic, strong) DFUHelper *dfuHelper;

@property (strong, nonatomic) NSArray *devices;
@property (assign, nonatomic) NSInteger selected;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.devices = [NSArray new];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self scanDevices];
    
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(scanDevices)];
    self.navigationItem.rightBarButtonItem = refreshBarButtonItem;
    
    //    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:TR(@"OTA(failed device)") style:UIBarButtonItemStyleDone target:self action:@selector(retryToUpgradeFailedDevice)];
    //    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)scanDevices
{
    self.devices = nil;
    [self.tableView reloadData];
    
    [self showHudWithLoading];
    
    [[CCBluetoothManager sharedInstance] scanDevicesWithInterval:5
#if DEBUG
#else
//                                                      filterName:@"WT10A"
#endif
                                                      completion:^(NSArray *arr, NSError *error) {
                                                          [self hideHud];
                                                          
                                                          if (error)
                                                          {
                                                              NSLog(@"%@", error);
                                                          }
                                                          else
                                                          {
#if DEBUG
                                                              NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"name LIKE[c] 'WT10A*' OR name LIKE[c] 'SW12#A*' OR name LIKE[c] 'L91*'"];
#else
                                                              NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"name LIKE[c] 'WT10A*' OR name LIKE[c] 'SW12#A*'"];
#endif
                                                              self.devices = [arr filteredArrayUsingPredicate:filterPredicate];
                                                              [self.tableView reloadData];
                                                          }
                                                      }];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReusedID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CCBluetoothDevice *device = [_devices objectAtIndex:indexPath.row];
    
    UILabel *txtLabel = (UILabel *)[cell viewWithTag:1];
    
    txtLabel.text = device.name;
    
    UILabel *rssiLabel = (UILabel *)[cell viewWithTag:2];
    rssiLabel.text = @(device.RSSI).stringValue;
    
    if (device.macAddress)
    {
        rssiLabel.text = [NSString stringWithFormat:@"%@ MAC : %@", rssiLabel.text, device.macAddress];
    }
    
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:3];
    statusLabel.text = device.connected ? TR(@"已连接") : TR(@"已断开");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCBluetoothDevice *device = [_devices objectAtIndex:indexPath.row];
    
    [self showHudWithLoading];
    [device connectWithinterval:15 completion:^(CCBluetoothDevice *dev, NSError *error) {
        if (error)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:TR(@"错误")
                                                                message:error.localizedDescription
                                                               delegate:self
                                                      cancelButtonTitle:TR(@"取消")
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            [self hideHud];
            self.selected = indexPath.row;
            [self performSegueWithIdentifier:@"ShowProtocolTest" sender:self];
        }
    }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowProtocolTest"])
    {
        ProtocolTestTableViewController *p = (ProtocolTestTableViewController *)[segue destinationViewController];
        p.device = _devices[_selected];
    }
}

#pragma mark - retryToUpgradeFailedDevice
- (void)retryToUpgradeFailedDevice
{
    MyWeakSelf;
    //query file path
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
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
              
              NSString *updateUrl = responseObject[@"crmProductVersion"][@"updateUrl"];
              
              //download file
              AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
              
              NSURLSessionDownloadTask *task2 = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:updateUrl]]
                                                                        progress:^(NSProgress *_Nonnull downloadProgress) {
                                                                            NSLog(@"file download progress : %@", downloadProgress);
                                                                        }
                                                                     destination:^NSURL *_Nonnull (NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response) {
                                                                         NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                                         return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                     }
                                                               completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
                                                                   //START OTA
                                                                   NSLog(@"file path : %@", filePath);
                                                                   [ws upgradingWithFilePath:filePath];
                                                               }];
              
              [task2 resume];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
              NSLog(@"query remote firmware version fail");
          }];
}

@end
