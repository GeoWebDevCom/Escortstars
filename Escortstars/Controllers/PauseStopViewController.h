//
//  PauseStopViewController.h
//  Escortstars
//
//  Created by TecOrb on 11/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface PauseStopViewController : BaseViewController<SlideNavigationControllerDelegate>
@property IBOutlet UIButton *pauseButton;
@property IBOutlet UIButton *stopButton;
@property IBOutlet UILabel *statusLabel;
@property IBOutlet UILabel *dateLabel;
@property IBOutlet UILabel *startTimeLabel;
@property IBOutlet UILabel *endTimeLabel;
@property IBOutlet UIView *lastDropinContainerView;





@end
