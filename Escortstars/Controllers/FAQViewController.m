//
//  FAQViewController.m
//  Escortstars
//
//  Created by TecOrb on 06/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "FAQViewController.h"
#import "FAQTableViewCell.h"

//#define questions = @[@"BLACK & WHITELIST",@"PANIC BUTTON",@"EMERGENCY SETTING FOR PANIC BUTTON",@"SHARE"]
//#define images = @[@"1.png",@"2.png",@"3.png",@"4.png"]
//#define answers @[@"BLACKLIST \n\nAdd a number to the blacklist and the next time this number calls you there will be a popup on your phone saying “This number is blacklisted!” and you can accept the call or ignore it.\n\nIf only you add a number the popup will only show for you, but if 2 or more adds the same number – it will show the popup for everyone using the app!\n\n\nWHITELIST\n\nAdd a number to the whitelist and the next time this number calls you there will be a popup on your phone saying “This number is whitelisted!”\n\nIf only you add a number the popup will only show for you, but if 2 or more adds the same number – it will show the popup for everyone using the app!\n\nIt’s also possible to add comments (Example: “This person is very nice and gives good tip“), and these comments will also show in the popup.",@"\nHopefully, this is a button you won’t need, but if you ever feel unsafe – click this!\n\nThe app will automatically take a picture and send it to the phone number and/or e-mail address you have entered in your emergency settings.",@"\nHere you will enter the phone number and/or e-mail address where you want the photo from the panic button to be sent.\n\nWhen you click the panic button a photo will automatically be taken and sent to the email and/or phone number you have entered here.",@"SHARE\n\nYou can share this application with your friends by email, sms, social media and other ways.\n\nNote. It will only work if they are/become advertisers on www.escortstars.eu."]

@interface FAQViewController (){
    __weak IBOutlet UITableView *FAQTableView;
    NSArray *questions;
    NSArray *answers;
    NSArray *images;
    NSIndexPath *pre_selected;
    NSIndexPath *selectedRowIndex;
}
@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pre_selected=[NSIndexPath indexPathForRow:-1 inSection:0];
    selectedRowIndex = [NSIndexPath indexPathForRow:-1 inSection:0];

    // images = @[@"1.png",@"2.png",@"3.png",@"4.png"];
    questions = @[@"BLACK & WHITELIST",@"PANIC BUTTON",@"EMERGENCY SETTING FOR PANIC BUTTON",@"SHARE"];
    answers = @[@"BLACKLIST \n\nAdd a number to the blacklist and the next time this number calls you there will be a popup on your phone saying “This number is blacklisted!” and you can accept the call or ignore it.\n\nIf only you add a number the popup will only show for you, but if 2 or more adds the same number – it will show the popup for everyone using the app!\n\n\nWHITELIST\n\nAdd a number to the whitelist and the next time this number calls you there will be a popup on your phone saying “This number is whitelisted!”\n\nIf only you add a number the popup will only show for you, but if 2 or more adds the same number – it will show the popup for everyone using the app!\n\nIt’s also possible to add comments (Example: “This person is very nice and gives good tip“), and these comments will also show in the popup.\n",

        @"\nHopefully, this is a button you won’t need, but if you ever feel unsafe – click this!\n\nThe app will automatically take a picture and send it to the phone number and/or e-mail address you have entered in your emergency settings.\n",

        @"\nHere you will enter the phone number and/or e-mail address where you want the photo from the panic button to be sent.\n\nWhen you click the panic button a photo will automatically be taken and sent to the email and/or phone number you have entered here.\n",

        @"\nYou can share this application with your friends by email, sms, social media and other ways."];
    
    FAQTableView.rowHeight = UITableViewAutomaticDimension;
    FAQTableView.estimatedRowHeight = 44;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return questions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 0, 0)];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == selectedRowIndex.row)
        {
        return UITableViewAutomaticDimension;
        }
    if (indexPath.row == pre_selected.row)
        {
        return 44;
        }
    return 44;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FAQTableViewCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[FAQTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FAQTableViewCell"];
    }
    cell.questionLabel.text = questions[indexPath.row];
    cell.answerLabel.text = answers[indexPath.row];
    // cell.hintImage.image = [UIImage imageNamed:images[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If expended row is selected again
    NSMutableArray *rowsToReload = [NSMutableArray array];
    //to collapse the expended row
    if (selectedRowIndex.row == indexPath.row)
        {
        pre_selected = selectedRowIndex;
        selectedRowIndex = [NSIndexPath indexPathForRow:-1 inSection:0];
        if(pre_selected.row >= 0)
            {
            NSIndexPath *rowToReload = [NSIndexPath indexPathForRow: pre_selected.row inSection: indexPath.section];
            [rowsToReload addObject:rowToReload];
            [tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
            }
        return;
        }

    //expend the selectedrow
    pre_selected = selectedRowIndex;
    selectedRowIndex = indexPath;

    if (pre_selected.row >= 0)
        {
         NSIndexPath *rowToReload = [NSIndexPath indexPathForRow: pre_selected.row inSection: indexPath.section];
        [rowsToReload addObject:rowToReload];
        }
    if (selectedRowIndex.row >= 0)
        {
        NSIndexPath *rowToReload = [NSIndexPath indexPathForRow: selectedRowIndex.row inSection: indexPath.section];
        [rowsToReload addObject:rowToReload];
        }
    [tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
}



@end
