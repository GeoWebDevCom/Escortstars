//
//  SettingsViewController.h
//  Escortstars
//
//  Created by TecOrb on 06/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface SettingsViewController : BaseViewController <SlideNavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *numberTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property IBOutlet UIButton *editButton;

@end
