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


@protocol WhiteListProtocol;
@protocol WhiteListProtocol <NSObject>
- (void)whiteListDidClosed;
@end

@interface WhiteListViewController : UIViewController <SlideNavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id <WhiteListProtocol>delegate;
-(void)contactsDetailsFromAddressBook;

@end
