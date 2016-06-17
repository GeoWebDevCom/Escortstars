//
//  ContactsBaseViewController.m
//  Escortstars
//
//  Created by TecOrb on 30/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "ContactsBaseViewController.h"

@interface ContactsBaseViewController ()
{
    User *user;
    UIImage *emergecyImage;
    __weak IBOutlet UITextField *blacklistNumberTextField;
    __weak IBOutlet UITextField *whitelistNumberTextField;
    __weak IBOutlet UITextField *whitelistNameTextField;
}
@end

@implementation ContactsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL contactCreated = [kUserDefault boolForKey:kContactCreated];
        if (!contactCreated) {
            [self addContacts];
            [self syncronizeBlackList];
            [self syncronizeWhiteList];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onClickAddToBlackList:(UIButton*)sender{
    [self.view endEditing:YES];
    if ([blacklistNumberTextField.text  isEqual: @""] ||[blacklistNumberTextField.text containsString:@" "] || blacklistNumberTextField.text == nil) {
        [self showAlertWithMessage:@"Please enter a number first" title:@"Error!"];
    } else {
        [self addNumberOnServer:BlackList withName:@"Blacklisted Caller" andNumber:blacklistNumberTextField.text];
    }

}
-(IBAction)onClickAddToWhiteList:(UIButton*)sender{
    [self.view endEditing:YES];
    if ([whitelistNumberTextField.text  isEqual: @""] ||[whitelistNumberTextField.text containsString:@" "] || whitelistNumberTextField.text == nil) {
        [self showAlertWithMessage:@"Please enter a number first" title:@"Error!"];
        return;
    }

        NSString *name;
        if ([whitelistNameTextField.text  isEqual: @""] || whitelistNameTextField.text == nil) {
            name = @"Whitelisted Caller";
        }else{
            name = whitelistNameTextField.text;
        }
        [self addNumberOnServer:WhiteList withName:name andNumber:whitelistNumberTextField.text];
}
-(IBAction)onClickViewMyBlackList:(UIButton*)sender{
    [self.view endEditing:YES];

    //add blacklist view as childviewcontroller
    BlackListViewController *blackListVC = [[UIStoryboard storyboardWithName:@"Main"
                                                                      bundle: nil] instantiateViewControllerWithIdentifier:@"BlackListViewController"];
    [self addChildViewController:blackListVC];
    blackListVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    [self.view addSubview:blackListVC.view];
    [blackListVC didMoveToParentViewController:self];

}
-(IBAction)onClickViewMyWhiteList:(UIButton*)sender{
    [self.view endEditing:YES];

    // add whitelist view as childviewcontroller
    WhiteListViewController *whiteListVC = [[UIStoryboard storyboardWithName:@"Main"
                                                                      bundle: nil] instantiateViewControllerWithIdentifier:@"WhiteListViewController"];
    [self addChildViewController:whiteListVC];
    whiteListVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    [self.view addSubview:whiteListVC.view];
    [whiteListVC didMoveToParentViewController:self];


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




-(void)syncronizeBlackList{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_getphones" forKey:@"action"];
    [params setValue:@"0" forKey:@"list_type"];
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     NSDictionary *phones = responseObject[@"phones"];
     [self addSyncronizedListInSystemContacts:phones inlistType:BlackList];
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
     }];

}

-(void)syncronizeWhiteList{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_getphones" forKey:@"action"];
    [params setValue:@"1" forKey:@"list_type"];
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     NSLog(@"whitelist syncronize response is : %@", responseObject);
     NSDictionary *phones = responseObject[@"phones"];
     [self addSyncronizedListInSystemContacts:phones inlistType:WhiteList];
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
     }];

}

-(void)addSyncronizedListInSystemContacts:(NSDictionary*)phones inlistType:(NumberListType)listType{

    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

        [self presentViewController:alert animated:TRUE completion:nil];

        return;

    }

    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                return ;
            } else {
                NSMutableArray *numbers = [[NSMutableArray alloc]init];
                [numbers removeAllObjects];
                NSUInteger i = 1;
                for (NSString * key in phones)
                    {
                    NSString *rId = key;
                    NSDictionary *details = phones[rId];
                    NSString *name;
                    if(listType == BlackList){
                        name = [NSString stringWithFormat:@"Blacklisted Caller%d",i];
                        i++;
                    }else{
                        name = details[@"name"];
                    }
                    NSString *number = details[@"phone"];
                    if ( name == nil || name == NULL || name.class == [NSNull class]) {
                        name = number;
                    }
                    CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@ |%@",name,rId] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",number]]];
                    [numbers addObject:aLabel];
                    }
                NSString *searchingContact;
                if (listType == BlackList) {
                    searchingContact = @"Blacklisted Callers";
                } else if (listType == WhiteList){
                    searchingContact = @"Whitelisted Callers";
                }
                BOOL found = NO;
                for (CNContact *contact in cnContacts) {
                    if ([contact.givenName isEqualToString:searchingContact])
                        {
                        found = YES;
                        CNMutableContact *cont = [contact mutableCopy];
                        //                        [numbers addObjectsFromArray:contact.phoneNumbers];
                        cont.phoneNumbers = numbers;
                        CNSaveRequest *request = [[CNSaveRequest alloc] init];
                        [request updateContact:cont];
                        NSError *saveError;
                        if (![store executeSaveRequest:request error:&saveError]) {
                            NSLog(@"error in saving contact..");
                        }else{
                            //[self calledViewWillAppear];
                        }
                        }
                }
                if (!found) {
                    //[self addContactsForList:listType rowID:rowID];
                }
            }
        }else{
            [CommonMethods showAlertWithMessage:@"Not Authorised!" title:@"Error!" inViewController:self];
        }
    }];
    
    
}


-(void)addToContactList:(NumberListType)listType withRowId:(NSString*)rowID withName:(NSString*)name andNumber:(NSString*)number{
    blacklistNumberTextField.text = @"";
    whitelistNumberTextField.text = @"";
    whitelistNameTextField.text = @"";
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

        [self presentViewController:alert animated:TRUE completion:nil];

        return;

    }

    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                return ;
            } else {
                NSString *searchingContact;
                NSString *nameToStore;
                if (listType == BlackList) {
                    searchingContact = @"Blacklisted Callers";
                    nameToStore = @"Blacklisted Caller";
                } else if (listType == WhiteList){
                    nameToStore = name;
                    searchingContact = @"Whitelisted Callers";
                }
                BOOL found = NO;
                for (CNContact *contact in cnContacts) {
                    if ([contact.givenName isEqualToString:searchingContact])
                        {
                        found = YES;
                        NSMutableArray *numbers = [[NSMutableArray alloc]init];
                        if (listType == BlackList) {
                            NSUInteger count = contact.phoneNumbers.count + 1;
                            nameToStore = [NSString stringWithFormat:@"Blacklisted Caller %d",count];
                        }
                        CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@ |%@",nameToStore,rowID] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",number]]];
                        [numbers removeAllObjects];
                        [numbers addObject:aLabel];
                        CNMutableContact *cont = [contact mutableCopy];
                        [numbers addObjectsFromArray:contact.phoneNumbers];
                        cont.phoneNumbers = numbers;
                        CNSaveRequest *request = [[CNSaveRequest alloc] init];
                        [request updateContact:cont];
                        NSError *saveError;
                        if (![store executeSaveRequest:request error:&saveError]) {
                            NSLog(@"error in saving contact..");
                        }else{
                            [self showAlertWithMessage:@"Saved successfully" title:@"Message"];
                        }
                        }
                }
                if (!found) {
//                    [self addContactsForList:self.listType rowID:rowID];
                }
            }
        }else{
            [CommonMethods showAlertWithMessage:@"Not Authorised!" title:@"Error!" inViewController:self];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)addNumberOnServer:(NumberListType)listType withName:(NSString*)name andNumber:(NSString*)number{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (listType == BlackList) {
            [params setValue:@"0" forKey:@"list"];
        } else if (listType == WhiteList){
            [params setValue:@"1" forKey:@"list"];
        }
        NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
        user = [User modelObjectWithDictionary:userDict];
        [params setValue:user.userID forKey:@"id_user"];
        [params setValue:@"app_addnumber" forKey:@"action"];
        [params setValue:number forKey:@"phone"];
        [params setValue:name forKey:@"name"];

        [CommonMethods showLoader:@"Please wait.."];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
        [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         [CommonMethods hideLoader];
         NSLog(@"response is : %@", responseObject);
         NSString *rId = responseObject[@"id"];
         [self addToContactList:listType withRowId:rId withName:name andNumber:number];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [CommonMethods hideLoader];
         }];
    });
    
}


//-(void)addContactsForList:(NumberListType)listType rowID:(NSString*)rowID{
//    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
//    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//        [self.presentingViewController presentViewController:alert animated:TRUE completion:nil];
//        return;
//    }
//
//
//
//    CNContactStore *store = [[CNContactStore alloc] init];
//
//    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//
//        if (!granted) {
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@" store request error = %@", error);
//
//            });
//
//            return;
//
//        }
//
//        // create contact
//        CNMutableContact *contact = [[CNMutableContact alloc] init];
//        if (listType == BlackList) {
//            contact.givenName = @"Blacklisted Callers";
//            contact.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"spam"], 1.0);
//            contact.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported spammers by Escorts. It’s updated every time you refresh your Spam List — so please don’t delete this contact!";
//        } else {
//            contact.givenName = @"Whitelisted Callers";
//            contact.note = @"Hi there 👋! This contact was created by Escortstars and contains the latest reported whitelist custumers by Escorts. It’s updated every time you refresh your WhiteList — so please don’t delete this contact!";
//        }
//        NSMutableArray *numbers = [[NSMutableArray alloc]init];
//        CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@|%@",_nameTextField.text,rowID] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",_numberTextField.text]]];
//        [numbers removeAllObjects];
//        [numbers addObject:aLabel];
//        contact.phoneNumbers = numbers;
//        CNSaveRequest *request = [[CNSaveRequest alloc] init];
//        NSString *containerId = store.defaultContainerIdentifier;
//        [request addContact:contact toContainerWithIdentifier:containerId];
//        NSError *saveError;
//
//        if (![store executeSaveRequest:request error:&saveError]) {
//            [kUserDefault setBool:NO forKey:kContactCreated];
//        }
//        else{
//            [kUserDefault setBool:YES forKey:kContactCreated];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
//}


-(void)showAlertWithMessage:(NSString*)message title:(NSString*)title{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okayAction];
    [self presentViewController:alert animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
