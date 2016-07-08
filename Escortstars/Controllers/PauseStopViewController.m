//
//  PauseStopViewController.m
//  Escortstars
//
//  Created by TecOrb on 11/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "PauseStopViewController.h"

@interface PauseStopViewController ()
{
    User *user;
    NSString *lastDropInID;
}
@end

@implementation PauseStopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CommonMethods makeViewCircular:_pauseButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
    [CommonMethods makeViewCircular:_lastDropinContainerView withBorderColor:kNavigationColor withBorderWidth:1 withCornerRadius:5];
    [CommonMethods makeViewCircular:_stopButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
    [self getLastDropIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(NSString*)currentTimeString{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSLog(@"Now is :%@",[dateFormatter stringFromDate:today]);
    return [dateFormatter stringFromDate:today];
}
-(NSString*)getTimeStringFromString:(NSString*)dateString{
    NSArray *listItems = [dateString componentsSeparatedByString:@" "];
    return listItems.lastObject;
}

-(NSString*)getDateStringFromString:(NSString*)dateString{
    NSArray *listItems = [dateString componentsSeparatedByString:@" "];
    return listItems.firstObject;
}

-(void)getLastDropIn{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_getdropin" forKey:@"action"];
    [params setValue:[self currentTimeString] forKey:@"curr_datetime"];
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
         NSDictionary *dropInDict = responseObject[@"dropin"];
         if ([responseObject[@"dropin"] isKindOfClass:[NSDictionary class]]){
             NSString *status = dropInDict[@"status"];
             NSString *eTime = [self getTimeStringFromString:dropInDict[@"in_end"]];
             NSString *sTime = [self getTimeStringFromString:dropInDict[@"in_start"]];
             NSString *date = [self getDateStringFromString: dropInDict[@"in_start"]];
             lastDropInID = dropInDict[@"id"];
             if ([status isEqualToString:@"1"]) {
                 _statusLabel.text = @"Active";
                 _pauseButton.enabled = NO;
                 _pauseButton.alpha = 0.5;
                 _stopButton.alpha = 1.0;
                 _stopButton.enabled = YES;
             } else {
                 _statusLabel.text = @"Paused";
                 _pauseButton.alpha = 1.0;
                 _stopButton.alpha = 0.5;
                 _pauseButton.enabled = YES;
                 _stopButton.enabled = NO;
             }
             _dateLabel.text = date;
             _startTimeLabel.text = sTime;
             _endTimeLabel.text = eTime;
         }else{
             [self showAlertWithMessage:@"No details found, You should add a drop-in first" title:@"Message!"];
             _statusLabel.text = @"Not Found";
             _pauseButton.alpha = 0.5;
             _stopButton.alpha = 0.5;
             _pauseButton.enabled = NO;
             _stopButton.enabled = NO;
         }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
         [self showAlertWithMessage:@"OOPSS!! Some thing went wrong" title:@"Error!"];
     }];


}
-(IBAction)onClickPause:(UIButton*)sender{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_dropstatus" forKey:@"action"];
    [params setValue:lastDropInID forKey:@"id_drop"];
    [params setValue:@"0" forKey:@"status"];

    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     [self getLastDropIn];
     //[self showAlertWithMessage:@"You have paused successfully" title:@"Message"];
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
         [self showAlertWithMessage:@"OOPSS!! Some thing went wrong" title:@"Error!"];
     }];

}
-(IBAction)onClickStart:(UIButton*)sender{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_dropstatus" forKey:@"action"];
    [params setValue:lastDropInID forKey:@"id_drop"];
    [params setValue:@"1" forKey:@"status"];
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     [self getLastDropIn];
     // [self showAlertWithMessage:@"You have started successfully" title:@"Message"];
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
         [self showAlertWithMessage:@"OOPSS!! Some thing went wrong" title:@"Error!"];
     }];

}



-(void)showAlertWithMessage:(NSString*)message title:(NSString*)title{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okayAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
