//
//  LoginService.m
//  Opportuniti
//
//  Created by Mayank Gupta on 24/01/16.
//  Copyright © 2016 Mayank Gupta. All rights reserved.
//

#import "LoginService.h"

//#import "CommonResponseParser.h"
//#import "ProfileParser.h"

@implementation LoginService

-(void)loginWithParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *requestParameters = [ServerConnect setCommonRequestParameters:parameters];
    [requestParameters setObject:@"login" forKey:@"action"];
    ////NSLog(@"%@",requestParameters);
}

//
//    [[ServerConnect requestOperationManager] POST:@"mobile/app/signup.php" parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        id serverResponse = [self commonResponseHandling:responseObject];
//        
//        if (serverResponse) {
////            ProfileParser *userDataResponse = [ProfileParser modelObjectWithDictionary:serverResponse];
//            [kUserDefault setObject:[[serverResponse objectForKey:@"data"] removeNullValuesFromDictionary] forKey:kUserInfo];
//            
//            if (self.completionBlockWithSuccess) {
//                self.completionBlockWithSuccess(0, self.eRequestType, serverResponse, nil);
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (self.completionBlockWithFailure) {
//            self.completionBlockWithFailure(self.eRequestType, error);
//        }
//    }];
//}

//-(void)socialLoginWithParameters:(NSDictionary *)parameters
//{
//    NSMutableDictionary *requestParameters = [ServerConnect setCommonRequestParameters:parameters];
//    [requestParameters setObject:@"social-login" forKey:@"action"];
//    
//    [[ServerConnect requestOperationManager] POST:@"mobile/app/signup.php" parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        id serverResponse = [self commonResponseHandling:responseObject];
//        
//        if (serverResponse) {
//            [kUserDefault setObject:[[serverResponse objectForKey:@"data"] removeNullValuesFromDictionary] forKey:kUserInfo];
//            if (self.completionBlockWithSuccess) {
//                self.completionBlockWithSuccess(0, self.eRequestType, serverResponse, nil);
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        if (self.completionBlockWithFailure) {
//            self.completionBlockWithFailure(self.eRequestType, error);
//        }
//    }];
//}

-(void)logoutWithParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *requestParameters = [ServerConnect setCommonRequestParameters:parameters];
    [requestParameters setObject:@"logout" forKey:@"action"];
    
}
@end

