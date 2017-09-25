#import <UIKit/UIKit.h>
#import "GlobalHeader.h"

@interface UIViewController (HudAndTimer)
- (void)showAlertWithString:(NSString *)info;
- (void)showHudWithSetting;
- (void)showHudWithLoading;
- (void)showHudWithLoadingWithInteractions;
- (void)showHudWithSuccessInfo;
- (void)showHudWithFailedInfo;
- (void)showHudWithNetworkNotAvailable;   //网络不通的提示
- (void)showHudWithNetworkDisconnected;   //网络未连接
- (void)showHudWithBluetoothNotAvailable; //蓝牙不同的提示
- (void)showHudAutoHideStringWithError:(NSString *)info;
- (void)showHudAutoHideStringWithSuccess:(NSString *)info;
- (void)showHudWithCustomInfo:(NSString *)info;
- (void)showHudWithSyncingInfo;
- (void)showHudWithTryAgain;
- (void)showHudWithProgress:(float)progress withTitle:(NSString *)title;
- (void)showHudWithImage:(UIImage *)image status:(NSString *)string;
- (void)showWithStatus:(NSString *)status;
- (void)hideHud;
@end
