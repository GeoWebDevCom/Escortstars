//
//  WhiteListViewController.h
//  Escortstars
//
//  Created by TecOrb on 04/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "ContactTableViewCell.h"

@interface WhiteListViewController : UIViewController <SlideNavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
