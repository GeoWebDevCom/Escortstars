//
//  AppDelegate.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "ContactsBaseViewController.h"
@interface AppDelegate(){
    UIApplication *app;
    User *user;
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                            bundle: nil];
	LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
													   instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];

    [CommonMethods configureProgressBar];
    self.callCenter = [[CTCallCenter alloc] init];
    [self handleCall];
    BOOL isLoggedIN = (BOOL)[kUserDefault boolForKey:kLoggedIN];
    if(isLoggedIN){
        [kUserDefault setBool:YES forKey:kNewSession];
         ContactsBaseViewController *home = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactsBaseViewController"];
        SlideNavigationController *navController = [[SlideNavigationController alloc]initWithRootViewController:home];
        navController.leftMenu = leftMenu;
        navController.menuRevealAnimationDuration = .18;
        self.window.rootViewController = navController;
    }else{

        LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        SlideNavigationController *navController = [[SlideNavigationController alloc]initWithRootViewController:loginViewController];
        navController.leftMenu = leftMenu;

        navController.menuRevealAnimationDuration = .18;
        self.window.rootViewController = navController;
    }
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    [kUserDefault setBool:YES forKey:kNewSession];
//    _isBackgroundMode = YES;
//    [self.locationManager startUpdatingLocation];
//    [self handleCall];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [kUserDefault setBool:YES forKey:kNewSession];
//    [_locationManager startUpdatingLocation];
}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    _bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        // Clean up any unfinished task business by marking where you
//        // stopped or ending the task outright.
//        [application endBackgroundTask:_bgTask];
//        _bgTask = UIBackgroundTaskInvalid;
//    }];
//
//    // Start the long-running task and return immediately.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // Do the work associated with the task, preferably in chunks.
//        [_locationManager startUpdatingLocation];
//        [application endBackgroundTask:_bgTask];
//        _bgTask = UIBackgroundTaskInvalid;
//    });
//}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [kUserDefault setBool:YES forKey:kNewSession];

//    [_locationManager startUpdatingLocation];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [kUserDefault setBool:YES forKey:kNewSession];

	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [kUserDefault setBool:YES forKey:kNewSession];
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       // Check result of your operation and call completion block with the result
                       // [self.locationManager startUpdatingLocation];
                       completionHandler(UIBackgroundFetchResultNewData);
                   });
}
-(void)handleCall
{
    __weak typeof(self) weakSelf = self;
    self.callCenter.callEventHandler = ^(CTCall *call){

        if ([call.callState isEqualToString: CTCallStateConnected])
            {
            //NSLog(@"call stopped");
            }
        else if ([call.callState isEqualToString: CTCallStateDialing])
            {
            }
        else if ([call.callState isEqualToString: CTCallStateDisconnected])
            {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Escortstars!" message:@"Would you like to add this caller in list?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *whitelistAction = [UIAlertAction actionWithTitle:@"Add to Whitelist" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //whitelist
                [alert dismissViewControllerAnimated:YES completion:nil];

                [weakSelf onClickAddNewEntryToWhiteList];
            }];
            UIAlertAction *blacklistAction = [UIAlertAction actionWithTitle:@"Add to Blacklist" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //blacklist
                [alert dismissViewControllerAnimated:YES completion:nil];
                [weakSelf onClickAddNewEntryToBlackList];

            }];

            [alert addAction:blacklistAction];
            [alert addAction:whitelistAction];
            [alert addAction:cancelAction];
            [weakSelf.window.rootViewController presentViewController:alert animated:YES completion:nil];


            }
        else if ([call.callState isEqualToString: CTCallStateIncoming])
            {

            }
    };
}

-(void)onClickAddNewEntryToBlackList{
    //barTint, titleColor, backGround
    AddNewViewController *addNewVC = [[UIStoryboard storyboardWithName:@"Main"
                                                                bundle: nil] instantiateViewControllerWithIdentifier:@"AddNewViewController"];
    addNewVC.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addNewVC];
    navController.navigationBar.barTintColor = kNavigationColor;
    navController.navigationBar.backgroundColor = kNavigationColor;
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    addNewVC.listType = BlackList;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [_window.rootViewController presentViewController:navController animated:true completion:nil];

}
-(void)onClickAddNewEntryToWhiteList{
    AddNewViewController *addNewVC = [[UIStoryboard storyboardWithName:@"Main"
                                                                bundle: nil] instantiateViewControllerWithIdentifier:@"AddNewViewController"];
    addNewVC.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addNewVC];
    navController.navigationBar.barTintColor = kNavigationColor;
    navController.navigationBar.backgroundColor = kNavigationColor;
    navController.navigationBar.tintColor = [UIColor whiteColor];
    [navController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    addNewVC.listType = WhiteList;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [_window.rootViewController presentViewController:navController animated:true completion:nil];
}

#pragma CLLocationManager delegate methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //NSLog(@"updating location..");
    if (_isBackgroundMode)
        {
        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:5];
        }
    [self handleCall];
    }

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
}


-(void)numberDidSavedToList:(NumberListType)listType number:(NSString *)number{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (listType == BlackList) {
        [params setValue:@"0" forKey:@"list"];
    } else if (listType == WhiteList){
        [params setValue:@"1" forKey:@"list"];
    }
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_addnumber" forKey:@"action"];
    [params setValue:number forKey:@"phone"];

    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     //NSLog(@"response is : %@", responseObject);
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
     }];

}
-(void)addingNumberDidCanceled{}
@end
