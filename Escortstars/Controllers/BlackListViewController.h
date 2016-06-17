//
//  BlackListViewController.h
//  Escortstars
//
//  Created by TecOrb on 05/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface BlackListViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *blockedContactsArray;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) User *user;
@end
