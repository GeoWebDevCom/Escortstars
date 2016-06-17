//
//  ProfileViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "ProfileViewController.h"
@interface ProfileViewController()<UIWebViewDelegate>{
    __weak IBOutlet UIWebView *profileWebView;

}
@end
@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([kUserDefault boolForKey:kNewSession]){
        [self loginInToDashboard];
        [kUserDefault setBool:NO forKey:kNewSession];
    } else {
        [self loadWebView];
    }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

#pragma mark - UIWebViewDelegate Methods -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [CommonMethods showLoader:@"Loading.."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [CommonMethods hideLoader];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [CommonMethods showErrorWithStatus:@"Error in Loading" inView:self.view];
}

-(void)loginInToDashboard{
    [CommonMethods showLoader:@"Logging to Dashboard.."];
    NSString* token = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [kUserDefault setValue:token forKey:kAppToken];
    NSString *email = [kUserDefault valueForKey:kUserName];
    NSString *password = [kUserDefault valueForKey:kUserName];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:email,@"lg",password,@"ps",@"app_token_login",@"action",token,@"token",nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];

    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     BOOL result = (BOOL)responseObject[@"result"];
     if (result)
         {
         [self loadWebView];
         }
     else
         {
         [CommonMethods showAlertWithMessage:@"Couldn't login into Dashboard" title:@"Error!" inViewController:self];
         }
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
         [CommonMethods showAlertWithMessage:@"OOPSS!! Some thing went wrong" title:@"Error!" inViewController:self];
     }];
}

-(void)loadWebView{
        NSString *token = [kUserDefault valueForKey:kAppToken];
        NSString *currentURL = [NSString stringWithFormat:@"%@%@",PROFILE_URL,token];
        [profileWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]]];
        profileWebView.hidden = NO;
}

@end
