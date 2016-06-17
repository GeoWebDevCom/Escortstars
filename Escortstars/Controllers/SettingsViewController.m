//
//  SettingsViewController.m
//  Escortstars
//
//  Created by TecOrb on 06/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITextFieldDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonMethods makeViewCircular:_editButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
    _numberTextField.delegate = self;
    _emailTextField.delegate = self;
    _numberTextField.text = [kUserDefault valueForKey:kEmergencyContact];
    _emailTextField.text = [kUserDefault valueForKey:kEmergencyEmailID];

    _numberTextField.enabled = YES;
    _emailTextField.enabled = YES;
    [_numberTextField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(IBAction)editButtnAction:(UIButton*)sender{
    [self.view endEditing:YES];
    NSString *number = _numberTextField.text;
    NSString *email = _emailTextField.text;
    if ([number  isEqual: @""] && [email isEqualToString:@""]) {
        [self showAlertWithMessage:@"You didn't enter any details, Nothing been saved" title:@"Message!"];
        return;
    }
    [kUserDefault setValue:number forKey:kEmergencyContact];
    [kUserDefault setValue:email forKey:kEmergencyEmailID];
    [kUserDefault synchronize];
    [self showAlertWithMessage:@"Details successfully saved" title:@"Message!"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField ==_emailTextField) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField ==_emailTextField) {
        return YES;
    }
    return YES;
}

-(void)showAlertWithMessage:(NSString*)message title:(NSString*)title{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okayAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
