#import "UIViewController+HudAndTimer.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation  UIViewController (HudAndTimer)

+(void)initialize
{
    [super initialize];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
        [SVProgressHUD setMinimumDismissTimeInterval:1];


    });
}

- (void)showHudWithSuccessInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:TR(@"Successfully")];
    });
}

- (void)showHudWithFailedInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:TR(@"Failed")];
    });
}

- (void)showHudWithTryAgain
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:TR(@"TryAgain")];
    });
}

- (void)showWithStatus:(NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:status];
    });
}

- (void)showHudWithImage:(UIImage *)image status:(NSString *)string
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showImage:(UIImage *)image status:(NSString *)string];
    });
}

- (void)showHudAutoHideStringWithError:(NSString *)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:info];
    });
}

- (void)showHudAutoHideStringWithSuccess:(NSString *)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setAnimationDuration:1.5];
        [SVProgressHUD showSuccessWithStatus:info];
    });
}

- (void)showHudWithLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:TR(@"Loading")];
    });
}

- (void)showHudWithLoadingWithInteractions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:TR(@"Loading")];
    });
}

- (void)showHudWithSetting
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithStatus:TR(@"Setting")];
    });
}

- (void)showHudWithCustomInfo:(NSString *)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:info];
    });
}

- (void)showHudWithSyncingInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHudWithCustomInfo:TR(@"Syncing")];
    });
}

- (void)showHudWithNetworkNotAvailable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:TR(@"Network_unavailable")];
    });
}

- (void)showHudWithNetworkDisconnected
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:TR(@"Network_disconnected")];
    });
}

- (void)showHudWithBluetoothNotAvailable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:TR(@"Bluetooth_unavailable")];
    });
}

- (void)hideHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)showAlertWithString:(NSString *)info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:info delegate:nil cancelButtonTitle:TR(@"OK") otherButtonTitles:nil];
    
    [alert show];
}

- (void)showHudWithProgress:(float)progress withTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showProgress:progress status:title];
    });
}

#pragma mark - other
- (void)dealloc
{
    NSLog(@"[%@ dealloc]", NSStringFromClass(self.class));
}

@end
