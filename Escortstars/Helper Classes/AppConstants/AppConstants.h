//
//  AppConstants.h
//  Escortstars
//
//  Created by TecOrb on 04/05/16.
//  Copyright © 2016 Nakul Sharma. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h
#define kNavigationColor [UIColor colorWithRed:216.0/255.0 green:27.0/255.0 blue:96.0/255.0 alpha:1.0]
#define kEmergencyEmailID @"EmergencyEmailID"
#define kEmergencyContact @"EmergencyContact"
#define kUserDefault ([NSUserDefaults standardUserDefaults])
#define kUserInfo @"UserInfo"
#define kNewSession @"NewSession"

#define kUserName @"UserName"
#define kPassword @"Password"
#define kLoggedIN @"LoggedIn"
#define kAppToken @"token_app"

#define kUserProfileLink @"UserProfileLink"
#define kContactCreated @"ContactCreated"
#endif /* AppConstants_h */

#define BASE_URL @"http://escortstars.eu/wp-admin/admin-ajax.php"
#define LOGIN_URL @"http://escortstars.eu/wp-admin/admin-ajax.php"
#define PROFILE_URL @"http://escortstars.eu/?token_app="

typedef enum {
    BlackList = 0,
    WhiteList,
    None
}NumberListType;

typedef enum {
    TabStatePauseDropIn = 0,
    TabStateBlackAndWhiteList,
    TabStatePanic,
} TabState;

