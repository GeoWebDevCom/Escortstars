//
//  BlockPermanentlyViewController.m
//  Escortstars
//
//  Created by TecOrb on 06/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "BlockPermanentlyViewController.h"

@interface BlockPermanentlyViewController ()
@property IBOutlet UIButton *blockPermanentlyButton;

@end
@implementation BlockPermanentlyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonMethods makeViewCircular:_blockPermanentlyButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
}

-(IBAction)onClickBlockPermanently:(id)sender{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Phone&path=Blocked"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}



@end
