//
//  ProtocolTestTableViewController.m
//  CCBluetoothAPI
//
//  Created by Calvin Cheung on 15/10/12.
//  Copyright © 2015年 Calvin Cheung. All rights reserved.
//

#import "ProtocolTestTableViewController.h"

#define MasterCreate CCBluetoothMaster * master = [CCBluetoothMaster sharedInstance]; master.mainDeviceName = self.device.name;
#define MasterCommit [master commit];

@interface ProtocolTestTableViewController ()
@property (strong, nonatomic) NSArray *titlesArray;
@end

@implementation ProtocolTestTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

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
		TR(@"关闭紫外灯监控")

	];

	//do not set delegate when using CCBluetoothMaster
//	self.device.delegate = self;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveShortTapNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveLongTapNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveShutDownTapNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_handler:) name:CCBluetoothDidReceiveLowPowerNotification object:nil];
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
}

- (void)showMessage:(NSString *)message
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:TR(@"响应")
														message:message
													   delegate:self
											  cancelButtonTitle:TR(@"取消")
											  otherButtonTitles:nil];

	[alertView show];
}

- (void)showResponse:(id)r error:(NSError *)error
{
	[self showMessage:[NSString stringWithFormat:@"%@, %@", r, error ? error.localizedDescription : TR(@"成功")]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCellID" forIndexPath:indexPath];

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = _titlesArray[indexPath.row];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = indexPath.row;

	NSString *title = self.titlesArray[row];

	__weak MasterCreate;

	[master setDevice:self.device];

	MyWeakSelf;

	CCBluetoothMasterSuccess successBlock = ^(id object)
	{
		[ws showResponse:object error:nil];
	};

	CCBluetoothMasterFailure failureBlock = ^(NSError *error)
	{
		[ws showResponse:nil error:error];
	};

	dispatch_group_t group = dispatch_group_create();

	if ([TR(@"电量") isEqualToString:title])
	{
		[master addTask:@selector(gettingBatteryPower)
				 params:nil
				success:successBlock
				failure:failureBlock];
	}
	else if ([TR(@"Watch ID") isEqualToString:title])
	{
		[master addTask:@selector(gettingWatchID)
				 params:nil
				success:successBlock
				failure:failureBlock];
	}
	else if ([TR(@"固件版本") isEqualToString:title])
	{
		[master addTask:@selector(gettingFirmwareVersion)
				 params:nil
				success:successBlock
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
		NSArray *lights = @[@0, @3, @4, @5, @6, @7, @8, @9, @10, @11];

		for (int i = 0; i < 200; i++)
		{
			CCBluetoothLightControlModel *model = [[CCBluetoothLightControlModel alloc] init];

			NSMutableArray *list = [NSMutableArray array];

			int index = i % 10;
			int toLightIndex = [lights[index] intValue];

			for (int j = 0; j < 12; j++)
			{
				[list addObject:toLightIndex == j ? @YES : @NO];
			}

			model.lightingList = list;
			model.threeColorsLightState = i % 5;

			[master addTask:@selector(setLightStateForHer:)
					 params:@[model]
					success:nil
					failure:nil];

			if (index == 0)
			{
				CCBluetoothLightControlModel *model = [CCBluetoothLightControlModel allOpenModel];
				[master addTask:@selector(setLightStateForHer:) params:@[model] success:nil failure:nil];
			}
		}

		CCBluetoothLightControlModel *model = [CCBluetoothLightControlModel allCloseModel];
		[master addTask:@selector(setLightStateForHer:) params:@[model] success:nil failure:nil];
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

	MasterCommit;
}

@end
