//
//  UIView+FormScroll.m
//  InvisionApp
//
//  Created by Reetika on 5/23/15.
//  Copyright (c) 2015 Reetika. All rights reserved.
//

#import "UIView+FormScroll.h"

@implementation UIView (FormScroll)

-(void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    self.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

-(void)scrollToView:(UIView *)view WithConstant:(int)constant
{
    CGRect theFrame = view.frame;
    float y = theFrame.origin.y +constant;
    y -= (y/1.7);
    [self scrollToY:-y];
}


-(void)scrollElement:(UIView *)view toPoint:(float)y
{
    CGRect theFrame = view.frame;
    float orig_y = theFrame.origin.y;
    float diff = y - orig_y;
    if (diff < 0) {
        [self scrollToY:diff];
    }
    else {
        [self scrollToY:0];
    }
    
}

-(UITableViewCell *)tableViewCell {
    UIView *aView = self.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)aView;
        }
        aView = aView.superview;
    }
    return nil;
}

-(NSIndexPath *)indexPathInTableView:(UITableView *)tableView{
    UITableViewCell *cell = [self tableViewCell];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    return indexPath;
}

@end
