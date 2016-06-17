//
//  CommonMethods.h
//  Escortstars
//
//  Created by TecOrb on 10/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <KVNProgress.h>

@interface CommonMethods : NSObject

+(void)makeViewCircular:(UIView *)view withBorderColor:(UIColor*)borderColor withBorderWidth:(CGFloat)borderWidth;
+(void)makeViewCircular:(UIView *)view withBorderColor:(UIColor*)borderColor withBorderWidth:(CGFloat)borderWith withCornerRadius:(CGFloat)cornerRadius;
+(void)showAlertWithMessage:(NSString*)message title:(NSString*)title inViewController :(id)viewControlle;
+(void)configureProgressBar;
+(void)showLoader:(NSString*)status;
+(void)hideLoader;
+(void)showLoader:(NSString*)status inView:(UIView*)view;
+(void)showErrorWithStatus:(NSString*)status inView:(UIView*)view;
+(void)showSuccessWithStatus:(NSString*)status inView:(UIView*)view;
+(void)showSuccessWithStatus:(NSString*)status;
+(void)showProgressWithStatus:(NSString*)status andFraction :(CGFloat)fraction;
+(void)updateProgressWithStatus:(NSString*)status andFraction :(CGFloat)fraction;
+(BOOL)isEmail:(NSString*)emailString;
@end
