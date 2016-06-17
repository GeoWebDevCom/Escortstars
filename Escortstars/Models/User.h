//
//  User.h
//  Escortstars
//
//  Created by TecOrb on 16/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding, NSCopying>

//@property (nonatomic, strong) NSString *;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userLogin;
@property (nonatomic, strong) NSString *userNickName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userURL;
@property (nonatomic, strong) NSString *userRegistrationDate;
@property (nonatomic, strong) NSString *userActivationKey;
@property (nonatomic, strong) NSString *userStatus;
@property (nonatomic, strong) NSString *userDisplayName;
@property (nonatomic, strong) NSString *userProfileLink;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end
