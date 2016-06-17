//
//  User.m
//  Escortstars
//
//  Created by TecOrb on 16/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#import "User.h"

NSString *const kUserID = @"ID";
NSString *const kUserLogin = @"user_login";
NSString *const kUserNickName = @"user_nicename";
NSString *const kUserEmail = @"user_email";
NSString *const kUserURL = @"user_url";
NSString *const kUserRegistrationDate = @"user_registered";
NSString *const kUserActivationKey = @"user_activation_key";
NSString *const kUserStatus = @"user_status";
NSString *const kUserDisplayName = @"display_name";
NSString *const kUserProfile = @"link";


@interface User ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation User

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.userID = [self objectOrNilForKey:kUserID fromDictionary:dict];
        self.userLogin = [self objectOrNilForKey:kUserLogin fromDictionary:dict];
        self.userNickName = [self objectOrNilForKey:kUserNickName fromDictionary:dict];
        self.userEmail = [self objectOrNilForKey:kUserEmail fromDictionary:dict];
        self.userURL = [self objectOrNilForKey:kUserURL fromDictionary:dict];
        self.userRegistrationDate = [self objectOrNilForKey:kUserRegistrationDate fromDictionary:dict];
        self.userActivationKey = [self objectOrNilForKey:kUserActivationKey fromDictionary:dict];
        self.userStatus = [self objectOrNilForKey:kUserStatus fromDictionary:dict];
        self.userDisplayName = [self objectOrNilForKey:kUserDisplayName fromDictionary:dict];
        self.userProfileLink = [self objectOrNilForKey:kUserProfile fromDictionary:dict];



//
//        NSString *notificationPrivacyFlag = [self objectOrNilForKey:kNotificationPrivacy fromDictionary:dict];
//        if (notificationPrivacyFlag != nil && [notificationPrivacyFlag isEqualToString:@"1"]){
//            self.notificationPrivacy = YES;
//        }else{
//            self.notificationPrivacy = NO;
//        }
//
    }

    return self;

}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userID forKey:kUserID];
    [mutableDict setValue:self.userLogin forKey:kUserLogin];
    [mutableDict setValue:self.userNickName forKey:kUserNickName];
    [mutableDict setValue:self.userEmail forKey:kUserEmail];
    [mutableDict setValue:self.userURL forKey:kUserURL];
    [mutableDict setValue:self.userRegistrationDate forKey:kUserRegistrationDate];
    [mutableDict setValue:self.userActivationKey forKey:kUserActivationKey];
    [mutableDict setValue:self.userStatus forKey:kUserStatus];
    [mutableDict setValue:self.userDisplayName forKey:kUserDisplayName];
    [mutableDict setValue:self.userProfileLink forKey:kUserProfile];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.userID = [aDecoder decodeObjectForKey:kUserID];
    self.userLogin = [aDecoder decodeObjectForKey:kUserLogin];
    self.userNickName = [aDecoder decodeObjectForKey:kUserNickName];
    self.userEmail = [aDecoder decodeObjectForKey:kUserEmail];
    self.userURL = [aDecoder decodeObjectForKey:kUserURL];
    self.userRegistrationDate = [aDecoder decodeObjectForKey:kUserRegistrationDate];
    self.userActivationKey = [aDecoder decodeObjectForKey:kUserActivationKey];
    self.userStatus = [aDecoder decodeObjectForKey:kUserStatus];
    self.userDisplayName = [aDecoder decodeObjectForKey:kUserDisplayName];
    self.userProfileLink = [aDecoder decodeObjectForKey:kUserProfile];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userID forKey:kUserID];
    [aCoder encodeObject:_userLogin forKey:kUserLogin];
    [aCoder encodeObject:_userNickName forKey:kUserNickName];
    [aCoder encodeObject:_userEmail forKey:kUserEmail];
    [aCoder encodeObject:_userURL forKey:kUserURL];
    [aCoder encodeObject:_userRegistrationDate forKey:kUserRegistrationDate];
    [aCoder encodeObject:_userActivationKey forKey:kUserActivationKey];
    [aCoder encodeObject:_userStatus forKey:kUserStatus];
    [aCoder encodeObject:_userDisplayName forKey:kUserDisplayName];
    [aCoder encodeObject:kUserProfileLink forKey:kUserProfile];
}

- (id)copyWithZone:(NSZone *)zone
{
    User *copy = [[User alloc] init];

    if (copy) {

        copy.userID = [self.userID copyWithZone:zone];
        copy.userLogin = [self.userLogin copyWithZone:zone];
        copy.userNickName = [self.userNickName copyWithZone:zone];
        copy.userEmail = [self.userEmail copyWithZone:zone];
        copy.userURL = [self.userURL copyWithZone:zone];
        copy.userRegistrationDate = [self.userRegistrationDate copyWithZone:zone];
        copy.userActivationKey = [self.userActivationKey copyWithZone:zone];
        copy.userStatus = [self.userStatus copyWithZone:zone];
        copy.userDisplayName = [self.userDisplayName copyWithZone:zone];
        copy.userProfileLink = [self.userProfileLink copyWithZone:zone];
    }

    return copy;
}

@end

