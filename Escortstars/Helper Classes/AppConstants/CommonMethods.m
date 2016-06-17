//
//  CommonMethods.m
//  Escortstars
//
//  Created by TecOrb on 10/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "CommonMethods.h"
@implementation CommonMethods
+(void)showLoader:(NSString*)status{
    [KVNProgress showWithStatus:status];
}

+(void)showLoader:(NSString*)status inView:(UIView*)view{
    [KVNProgress showWithStatus:@"Loading.."
                         onView:view];
}
+(void)showErrorWithStatus:(NSString*)status inView:(UIView*)view{
    [KVNProgress showErrorWithStatus:status onView:view];
}
+(void)showSuccessWithStatus:(NSString*)status inView:(UIView*)view{
    [KVNProgress showSuccessWithStatus:status onView:view];
}
+(void)showSuccessWithStatus:(NSString*)status;
{
    [KVNProgress showSuccessWithStatus:status];
}

+(void)updateProgressWithStatus:(NSString*)status andFraction :(CGFloat)fraction
{
    [KVNProgress updateStatus:[NSString stringWithFormat:@"Uploading...\n%d %% Done", (int) (fraction * 100)]];
    [KVNProgress updateProgress:fraction animated:YES];
}

+(void)showProgressWithStatus:(NSString*)status andFraction :(CGFloat)fraction
{
    [KVNProgress showProgress:fraction status:status];
}
+(void)hideLoader{
    [KVNProgress dismiss];
}

+(void)configureProgressBar{
    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];

    configuration.statusColor = [UIColor whiteColor];
    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    configuration.circleStrokeForegroundColor = [UIColor whiteColor];
    configuration.circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    configuration.circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    configuration.backgroundFillColor = kNavigationColor;
    configuration.backgroundTintColor = kNavigationColor;//[UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:1.0f];
    configuration.successColor = [UIColor whiteColor];
    configuration.errorColor = [UIColor whiteColor];
    configuration.stopColor = [UIColor whiteColor];
    configuration.circleSize = 110.0f;
    configuration.lineWidth = 1.5f;
    configuration.fullScreen = NO;
    configuration.showStop = YES;
    configuration.stopRelativeHeight = 0.4f;

    configuration.tapBlock = ^(KVNProgress *progressView) {
        // Do something you want to do when the user tap on the HUD
        // Does nothing by default
        [KVNProgress updateStatus:@"Still Loading, Please Wait"];
    };

    // You can allow user interaction for behind views but you will losse the tapBlock functionnality just above
    // Does not work with fullscreen mode
    // Default is NO
    configuration.allowUserInteraction = NO;

    [KVNProgress setConfiguration:configuration];

}
+(void)makeViewCircular:(UIView *)view withBorderColor:(UIColor*)borderColor withBorderWidth:(CGFloat)borderWidth{
    view.layer.borderColor=borderColor.CGColor;
    view.layer.borderWidth= borderWidth;
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds=YES;
}

+(void)makeViewCircular:(UIView *)view withBorderColor:(UIColor*)borderColor withBorderWidth:(CGFloat)borderWith withCornerRadius:(CGFloat)cornerRadius{
    view.layer.borderColor=borderColor.CGColor;
    view.layer.borderWidth= borderWith;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds=YES;
}
+(void)showAlertWithMessage:(NSString*)message title:(NSString*)title inViewController :(id)viewController{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okayAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}


+(BOOL)isEmail:(NSString*)emailString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

@end
