//
//  DropInViewController.h
//  Escortstars
//
//  Created by TecOrb on 05/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownListView.h"

@interface DropInViewController : BaseViewController<kDropDownListViewDelegate>
{
        NSArray *arryList;
        DropDownListView * Dropobj;
        User *user;

}
@property IBOutlet UIView *containerView;
@property IBOutlet UIButton *selectDateButton;
@property IBOutlet UITextField *startTimeTextFiled;
@property IBOutlet UITextField *endTimeTextFiled;
@property IBOutlet UIButton *activateButton;
@property IBOutlet UITextField *startDateTextFiled;
@property IBOutlet UITextField *endDateTextFiled;
@property IBOutlet UIButton *pauseButton;
@property IBOutlet UILabel *dateLabel;




- (IBAction)DropDownPressed:(id)sender;
@end
