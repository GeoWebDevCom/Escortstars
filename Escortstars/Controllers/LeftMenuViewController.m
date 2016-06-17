//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

@interface LeftMenuViewController()
{
    NSArray *leftMenuOptions;
    User *user;
}

@end
@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = NO;
	
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
    leftMenuOptions = @[@"Home",@"Block Number",@"FAQ",@"Privacy Policy",@"Emergency Settings",@"Share",@"Logout"];
	[super viewDidLoad];
	[SlideNavigationController sharedInstance].enableShadow = YES;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [SlideNavigationController sharedInstance].portraitSlideOffset = [UIScreen mainScreen].bounds.size.width*1/4;
	self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets = NO;
	
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = kNavigationColor;
    self.tableView.backgroundView=imageView;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return leftMenuOptions.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    user.userProfileLink = [kUserDefault valueForKey:kUserProfileLink];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    cell.imageView.image = [UIImage imageNamed:@"escortstar"];
    cell.textLabel.text = user.userDisplayName;
    cell.textLabel.textColor = kNavigationColor;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    cell.textLabel.text = leftMenuOptions[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"starIcon"];
    cell.imageView.backgroundColor = [UIColor clearColor];
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	UIViewController *vc ;
	
	switch (indexPath.row)
	{
		case 0:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ProfileViewController"];
			break;
        case 1:
        //block permanently
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"BlockPermanently"];
            vc.navigationController.title = @"Block Permanently";
            break;
        case 2:
        //FAQ
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FAQ"];
            vc.navigationController.title = @"FAQ";
            break;
        case 3:
        //Privacy Policy
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"PrivacyPolicy"];
            vc.navigationController.title = @"Privacy Policy";
            break;
        case 4:
        //Settings
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Settings"];
            vc.navigationController.title = @"Settings";
            break;
        case 5:
        //Share
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Share"];
            self.navigationController.title = @"Share";
            break;
        default:
        //logout
        [self logout];
        //[self showAlertForLogout];
            return;
            break;
	}
	
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}

-(void)showAlertForLogout{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Escortstars!" message:@"Would you really like to logout?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    }];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self logout];
    }];
    [alert addAction:okayAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)logout
{
    [kUserDefault setBool:NO forKey:kLoggedIN];
    [kUserDefault setValue:@"" forKey:kAppToken];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard
                                                                 instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    LoginViewController *loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = nil;
    SlideNavigationController *navController = [[SlideNavigationController alloc]initWithRootViewController:loginViewController];
    navController.leftMenu = leftMenu;
    navController.menuRevealAnimationDuration = .18;
    appDelegate.window.rootViewController = navController;

}

@end
