//
//  AddNewViewController.m
//  Escortstars
//
//  Created by TecOrb on 04/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "AddNewViewController.h"
#import <KVNProgress/KVNProgress.h>


@interface AddNewViewController ()
{
    NSString *phoneNumber;
    User *user;

}

@end

@implementation AddNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.listType == BlackList) {
        self.navigationItem.title = @"Add Number to Blacklist";
    } else if(self.listType == WhiteList) {
        self.navigationItem.title = @"Add Number to Whitelist";
    }
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,0,0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onClickSave:(id)sender{
    [self.view endEditing:YES];
    NSString *number = _numberTextField.text;
    NSString *name = _nameTextField.text;
    if([number isEqualToString:@""] || number == NULL || [number containsString:@" "]){
        [self showAlertWithMessage: @"Please enter a valid number" title:@"Error!"];
        return;
    }
    if([name isEqualToString:@""] || name == NULL){
        [self showAlertWithMessage: @"Please enter a valid number" title:@"Error!"];
        return;
    }
    [self addNumberOnServer];
}

-(IBAction)onClickCancel:(id)sender{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(addingNumberDidCanceled)]) {
        [_delegate addingNumberDidCanceled];
    }
}


-(void)addToContactList:(NSString*)rowID{
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
                CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@ |%@",_nameTextField.text,rowID] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",_numberTextField.text]]];
                [numbers removeAllObjects];
                [numbers addObject:aLabel];
                NSString *searchingContact;
                if (self.listType == BlackList) {
                    searchingContact = @"Blacklisted Callers";
                } else if (self.listType == WhiteList){
                    searchingContact = @"Whitelisted Callers";
                }
                BOOL found = NO;
                for (CNContact *contact in cnContacts) {
                    if ([contact.givenName isEqualToString:searchingContact])
                        {
                        found = YES;
                        CNMutableContact *cont = [contact mutableCopy];
                        [numbers addObjectsFromArray:contact.phoneNumbers];
                        cont.phoneNumbers = numbers;
                        CNSaveRequest *request = [[CNSaveRequest alloc] init];
                        [request updateContact:cont];
                        NSError *saveError;
                        if (![store executeSaveRequest:request error:&saveError]) {
                            //NSLog(@"error in saving contact..");
                        }else{
                            if ([_delegate respondsToSelector:@selector(numberDidSavedToList:number:)]) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                                [_delegate numberDidSavedToList:self.listType number:_numberTextField.text];
                            }
                            }
                        }
                }
                if (!found) {
                    [self addContactsForList:self.listType rowID:rowID];
                }
            }
        }else{
            [CommonMethods showAlertWithMessage:@"Not Authorised!" title:@"Error!" inViewController:self];
        }
    }];
}

-(void)addContactsForList:(NumberListType)listType rowID:(NSString*)rowID{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can add the desired contact" preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self.presentingViewController presentViewController:alert animated:TRUE completion:nil];
        return;
    }



    CNContactStore *store = [[CNContactStore alloc] init];

    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {

        if (!granted) {

            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@" store request error = %@", error);

            });

            return;

        }

        // create contact
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        if (listType == BlackList) {
            contact.givenName = @"Blacklisted Callers";

            contact.imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"spam"], 0.7);
            contact.note = @"Hi there 👋! This contact was created by E-stars and contains the latest reported spammers. It’s updated every time you refresh your Spam List — so please don’t delete this contact!";
        } else {
            contact.givenName = @"Whitelisted Callers";
            contact.note = @"Hi there 👋! This contact was created by E-stars and contains the latest reported spammers. It’s updated every time you refresh your Spam List — so please don’t delete this contact!";

        }
        NSMutableArray *numbers = [[NSMutableArray alloc]init];
        CNLabeledValue *aLabel = [CNLabeledValue labeledValueWithLabel:[NSString stringWithFormat:@"%@|%@",_nameTextField.text,rowID] value:[CNPhoneNumber phoneNumberWithStringValue:[NSString stringWithFormat:@"%@",_numberTextField.text]]];
        [numbers removeAllObjects];
        [numbers addObject:aLabel];
        contact.phoneNumbers = numbers;
        CNSaveRequest *request = [[CNSaveRequest alloc] init];
        NSString *containerId = store.defaultContainerIdentifier;
        [request addContact:contact toContainerWithIdentifier:containerId];
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

-(void)addNumberOnServer{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.listType == BlackList) {
            [params setValue:@"0" forKey:@"list"];
        } else if (self.listType == WhiteList){
            [params setValue:@"1" forKey:@"list"];
        }
        NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
        user = [User modelObjectWithDictionary:userDict];
        [params setValue:user.userID forKey:@"id_user"];
        [params setValue:@"app_addnumber" forKey:@"action"];
        [params setValue:_numberTextField.text forKey:@"phone"];
        [params setValue:_nameTextField.text forKey:@"name"];

        [CommonMethods showLoader:@"Please wait.."];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
        [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
         [CommonMethods hideLoader];
         //NSLog(@"response is : %@", responseObject);
         NSString *rId = responseObject[@"id"];
         [self addToContactList:rId];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             [CommonMethods hideLoader];
         }];
    });

}

-(void)showAlertWithMessage:(NSString*)message title:(NSString*)title{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okayAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
