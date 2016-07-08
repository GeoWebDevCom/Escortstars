//
//  FAQTableViewCell.h
//  Escortstars
//
//  Created by TecOrb on 24/06/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *questionLabel;
@property (nonatomic,weak) IBOutlet UILabel *answerLabel;
@property (nonatomic,weak) IBOutlet UIImageView *hintImage;

@end
