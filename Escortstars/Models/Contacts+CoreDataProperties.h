//
//  Contacts+CoreDataProperties.h
//  
//
//  Created by TecOrb on 18/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contacts.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contacts (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *rowid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *number;
@property (nullable, nonatomic, retain) NSString *statusPhonebook;
@property (nullable, nonatomic, retain) NSString *statusServer;

@end

NS_ASSUME_NONNULL_END
