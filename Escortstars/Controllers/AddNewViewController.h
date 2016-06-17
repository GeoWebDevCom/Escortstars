//
//  AddNewViewController.h
//  Escortstars
//
//  Created by TecOrb on 04/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Contacts;
@protocol AddNewNumberToListProtocol;
@protocol AddNewNumberToListProtocol <NSObject>
- (void)numberDidSavedToList:(NumberListType)listType number:(NSString*)number;
- (void)addingNumberDidCanceled;
@end
@interface AddNewViewController : UITableViewController
@property (nonatomic, assign) id delegate;
@property (nonatomic, weak) IBOutlet UITextField *numberTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@property NumberListType listType;
@end
