//
//  ViewController.m
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/9.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "ViewController.h"
#import <CCBluetoothAPI/CCBluetoothAPI.h>
#import "ProtocolTestTableViewController.h"
@interface ViewController ()

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
}

- (void)scanDevices
{
	self.devices = nil;
	[self.tableView reloadData];
	[[CCBluetoothManager sharedInstance] scanDevicesWithInterval:5 completion:^(NSArray *arr, NSError *error) {
		if (error)
		{
			NSLog(@"%@", error);
		}
		else
		{
			self.devices = arr;
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

	UILabel *statusLabel = (UILabel *)[cell viewWithTag:3];
	statusLabel.text = device.connected ? TR(@"已连接") : TR(@"已断开");

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CCBluetoothDevice *device = [_devices objectAtIndex:indexPath.row];

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
			self.selected = indexPath.row;
			[self performSegueWithIdentifier:@"ShowProtocolTest" sender:self];
		}
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

@end
