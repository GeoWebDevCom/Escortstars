//
//  PrivacyPolicyViewController.m
//  Escortstars
//
//  Created by TecOrb on 06/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()<UIWebViewDelegate>{
    __weak IBOutlet UIWebView *privacyPolicyWebView;

}
@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSString *currentURL = @"http://escortstars.eu/faq/";
    NSString *currentURL = [NSString stringWithFormat:@"%@/privacy",[kUserDefault valueForKey:kUserProfileLink]];
    [privacyPolicyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]]];
    privacyPolicyWebView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
