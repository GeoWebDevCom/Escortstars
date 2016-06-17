//
//  ContactTableViewCell.h
//  Escortstars
//
//  Created by TecOrb on 17/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIButton *deleteButton;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *numberLabel;
@end
