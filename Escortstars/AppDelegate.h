//
//  AppDelegate.h
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import "AddNewViewController.h"
#import <CoreTelephony/CTCall.h>
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,AddNewNumberToListProtocol>//,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CTCallCenter* callCenter;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property BOOL isBackgroundMode;

@end
