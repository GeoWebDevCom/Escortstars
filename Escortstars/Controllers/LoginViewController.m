//
//  LoginViewController.m
//  Escortstars
//
//  Created by TecOrb on 16/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseViewController.h"
#import "ProfileViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CommonMethods makeViewCircular:_loginButton withBorderColor:[UIColor clearColor] withBorderWidth:0 withCornerRadius:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onclickLogin:(UIButton*)sender{
    [self.view endEditing:YES];
    if([self validateParams]){
        [CommonMethods showLoader:@"Logging in.."];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_userNameTextField.text,@"lg",_passwordTextField.text,@"ps",@"app_login",@"action",nil];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer

                                      serializerWithReadingOptions:NSJSONReadingAllowFragments];

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];

        [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         [CommonMethods hideLoader];
         if ([responseObject[@"user"] isKindOfClass:[NSDictionary class]]) {
             NSDictionary *userDict = responseObject[@"user"];
             NSString *link  = [responseObject objectForKey:@"link"];
             [kUserDefault setValue:link forKey:kUserProfileLink];
             if(userDict != nil){
                 NSMutableDictionary *userData = userDict[@"data"];
                 if(userData){
                    [kUserDefault setValue:userData forKey:kUserInfo];

                    [kUserDefault setValue:_userNameTextField.text forKey:kUserName];
                    [kUserDefault setValue:_passwordTextField.text forKey:kPassword];
                    [self loginInToDashboard:_userNameTextField.text andPassword:_passwordTextField.text];
                 }
         }
         }else{
             [CommonMethods showAlertWithMessage:@"Incorrect username or password" title:@"Error!" inViewController:self];
             
         }
         
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             
             [CommonMethods hideLoader];
             
             [CommonMethods showAlertWithMessage:@"OOPSS!! Some thing went wrong" title:@"Error!" inViewController:self];
             
         }];
        
    }
}

-(void)loginInToDashboard:(NSString*)email andPassword:(NSString*)password{
    [CommonMethods showLoader:@"Logging to Dashboard.."];
    NSString* token = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [kUserDefault setValue:token forKey:kAppToken];
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
            ProfileViewController *profileVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            [self.navigationController pushViewController:profileVC animated:YES];
            [kUserDefault setBool:YES forKey:kLoggedIN];
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
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)loginIntoApp{

}
-(BOOL)validateParams{
    BOOL result = YES;
    NSString *userLogin = _userNameTextField.text;
    NSString *password = _passwordTextField.text;
    if([userLogin isEqualToString:@""]){
        [CommonMethods showAlertWithMessage:@"User login cann't be empty" title:@"Error!" inViewController:self];
        result = NO;
        return result;
    }

    if(![CommonMethods isEmail:userLogin]){
        [CommonMethods showAlertWithMessage:@"Please enter a valid email" title:@"Error!" inViewController:self];
        result = NO;
        return result;
    }

        if([password isEqualToString:@""] || password.length < 6 || [password containsString:@" "]){
        [CommonMethods showAlertWithMessage:@"Password cann't be empty" title:@"Error!" inViewController:self];
        result = NO;
        return result;
    }
    return result;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)addContacts{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

        [self presentViewController:alert animated:TRUE completion:nil];

        return;

    }



    CNContactStore *store = [[CNContactStore alloc] init];

    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {

        if (!granted) {

            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@" store request error = %@", error);

            });

            return;

        }

        // create contact
        CNMutableContact *contactToBlacklist = [[CNMutableContact alloc] init];
        contactToBlacklist.givenName = @"Blacklisted Callers";
        contactToBlacklist.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"spam"], 0.7);
        contactToBlacklist.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported spammers by Escorts. It’s updated every time you refresh your Spam List — so please don’t delete this contact!";
        CNMutableContact *contactToWhitelist = [[CNMutableContact alloc] init];
        contactToWhitelist.givenName = @"Whitelisted Callers";
        contactToWhitelist.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported whitelist custumers by Escorts. It’s updated every time you refresh your WhiteList — so please don’t delete this contact!";
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        NSString *containerId = store.defaultContainerIdentifier;

        [request addContact:contactToBlacklist toContainerWithIdentifier:containerId];
        [request addContact:contactToWhitelist toContainerWithIdentifier:containerId];

        NSError *saveError;

        if (![store executeSaveRequest:request error:&saveError]) {
            [kUserDefault setBool:NO forKey:kContactCreated];
        }
        else{
            [kUserDefault setBool:YES forKey:kContactCreated];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}

-(BOOL)didContactsAdded{
   __block BOOL result;
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                [CommonMethods showErrorWithStatus:@"Error in Loading Contacts!" inView:self.view];

            } else {
                for (CNContact *contact in cnContacts) {
                    if ([contact.givenName isEqualToString:@"Blacklisted Callers"])
                        {
                            result = YES;
                            break;
                        }
                }
            }
        }else{
            [CommonMethods showErrorWithStatus:@"Not authorised!" inView:self.view];
        }
    }];

    return result;

}

@end
