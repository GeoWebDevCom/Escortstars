//
//  ContactTableViewCell.m
//  Escortstars
//
//  Created by TecOrb on 17/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [CommonMethods makeViewCircular:_deleteButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
