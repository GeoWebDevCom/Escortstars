//
//  BaseViewController.h
//  Escortstars
//
//  Created by TecOrb on 05/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BaseViewController : UIViewController<SlideNavigationControllerDelegate,UIScrollViewDelegate>
@property TabState tabState;
-(IBAction)onClickPauseDropIn:(UIButton*)sender;
-(IBAction)onClickContactBookButton:(UIButton*)sender;
-(IBAction)onClickPanicButton:(UIButton*)sender;
@end
