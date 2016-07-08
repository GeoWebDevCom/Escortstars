//
//  WhiteListViewController.m
//  Escortstars
//
//  Created by TecOrb on 04/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "WhiteListViewController.h"
#import "LeftMenuViewController.h"

@interface WhiteListViewController ()
{
    NSMutableArray *blockedContactsArray;
    User *user;

}
@end

@implementation WhiteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    blockedContactsArray = [[NSMutableArray alloc]init];
//    [self contactsDetailsFromAddressBook];
}

-(void)viewWillAppear:(BOOL)animated{
    blockedContactsArray = [[NSMutableArray alloc]init];
    [self contactsDetailsFromAddressBook];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Datasrouce -

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return blockedContactsArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    view.backgroundColor = [UIColor redColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell"];
    NSDictionary *contact = blockedContactsArray[indexPath.row];
    cell.nameLabel.text = [self getNameFromString:[contact valueForKey:@"label_name"]];    cell.numberLabel.text = [contact valueForKey:@"phone"];
    [cell.deleteButton addTarget:self action:@selector(onClickDelete:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.hidden = NO;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.deleteButton.hidden = NO;//!cell.deleteButton.hidden;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.deleteButton.hidden = NO;//YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger row = [indexPath row];
    NSUInteger count = [blockedContactsArray count];

    if (row < count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger row = [indexPath row];
    NSUInteger count = [blockedContactsArray count];

    if (row < count) {
        [blockedContactsArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(IBAction)onClickDelete:(UIButton*)sender{
    NSIndexPath *indexPath = [sender indexPathInTableView:_tableView];

    //hit the api
    NSDictionary *contact = blockedContactsArray[indexPath.row];
    NSString *rowID = [self getRowIDFromString:[contact valueForKey:@"label_name"]];
    [self tableView:_tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    [self deleteNumberOnServerWithRowID:rowID];
    //remove from contact
    [self deleteNumberOnLocal:indexPath.row];
}
#pragma mark
#pragma mark -- Getting Blacklisted Contacts by Escortstars From AddressBook
-(void)contactsDetailsFromAddressBook{
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            NSArray *keys = @[CNContactBirthdayKey,CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSPredicate *predicate =[CNContact predicateForContactsMatchingName:@"Whitelisted Callers"];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {

            } else {
                for (CNContact *contact in cnContacts) {

                    if ([contact.givenName isEqualToString:@"Whitelisted Callers"])
                        {
                        [blockedContactsArray removeAllObjects];
                        for (CNLabeledValue *label in contact.phoneNumbers) {

                            NSString *phone = [label.value stringValue];
                            NSString *labelName = label.label;

                            if ([phone length] > 0) {
                                NSDictionary* personDict = [[NSDictionary alloc]initWithObjectsAndKeys:labelName,@"label_name",phone,@"phone", nil];
                                [blockedContactsArray addObject:personDict];
                            }
                        }
                        break;
                        }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [CommonMethods hideLoader];
                    [self.tableView reloadData];
                });
            }
        }else{
            [CommonMethods showErrorWithStatus:@"Not authorised!" inView:self.view];
        }
    }];
}

-(void)deleteNumberOnLocal:(NSInteger)index{
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
                NSString *searchingContact;
                searchingContact = @"Whitelisted Callers";
                for (CNContact *contact in cnContacts) {
                    if ([contact.givenName isEqualToString:searchingContact])
                        {
                        CNMutableContact *cont = [contact mutableCopy];
                        [numbers addObjectsFromArray:contact.phoneNumbers];
                        [numbers removeObjectAtIndex:index];
                        cont.phoneNumbers = numbers;
                        CNSaveRequest *request = [[CNSaveRequest alloc] init];
                        [request updateContact:cont];
                        NSError *saveError;
                        if (![store executeSaveRequest:request error:&saveError]) {
                            //NSLog(@"error in saving contact..");
                        }else{
                        }
                        }
                }
            }
        }else{
            [CommonMethods showAlertWithMessage:@"Not Authorised!" title:@"Error!" inViewController:self];
        }
    }];
}

-(void)deleteNumberOnServerWithRowID:(NSString*)rowID{
    NSDictionary *userDict = [kUserDefault valueForKey:kUserInfo];
    user = [User modelObjectWithDictionary:userDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:user.userID forKey:@"id_user"];
    [params setValue:@"app_daletephone" forKey:@"action"];
    [params setValue:rowID forKey:@"id"];
    [CommonMethods showLoader:@"Please wait.."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil];
    [manager POST:BASE_URL parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
     [CommonMethods hideLoader];
     //NSLog(@"delete response is : %@", responseObject);
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [CommonMethods hideLoader];
     }];
}


-(NSString*)getNameFromString:(NSString*)labelString{
    NSArray *listItems = [labelString componentsSeparatedByString:@"|"];
    return listItems.firstObject;
}

-(IBAction)onClickClose:(id)sender{
    if ([_delegate respondsToSelector:@selector(whiteListDidClosed)]) {
        [_delegate whiteListDidClosed];
    }
    [self didMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
-(NSString*)getRowIDFromString:(NSString*)labelString{
    NSArray *listItems = [labelString componentsSeparatedByString:@"|"];
    return listItems.lastObject;
}

@end
