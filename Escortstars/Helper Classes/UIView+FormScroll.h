//
//  UIView+FormScroll.h
//  InvisionApp
//
//  Created by Reetika on 5/23/15.
//  Copyright (c) 2015 Reetika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FormScroll)
-(void)scrollToView:(UIView *)view WithConstant:(int)constant;
-(void)scrollElement:(UIView *)view toPoint:(float)y;
-(void)scrollToY:(float)y;
-(UITableViewCell *)tableViewCell;
-(NSIndexPath *)indexPathInTableView:(UITableView *)tableView;
@end
