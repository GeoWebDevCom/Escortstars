//
//  ShareViewController.m
//  Escortstars
//
//  Created by TecOrb on 06/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
@property IBOutlet UIButton *shareButton;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonMethods makeViewCircular:_shareButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
}

-(IBAction)onClickShare:(id)sender{
    NSString *profileLink = @"www.escortstars.eu -EU's #1 escort site!";
    NSString *textToShare = profileLink;
    NSArray *itemsToShare = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
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
