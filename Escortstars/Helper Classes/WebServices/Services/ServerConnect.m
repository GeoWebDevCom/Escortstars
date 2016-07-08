//
//  ServerConnect.m
//  InvisionApp
//
//  Created by Mayank on 19/05/15.
//  Copyright (c) 2015 Reetika. All rights reserved.
//

#import "ServerConnect.h"

@implementation ServerConnect

//static AFHTTPRequestOperationManager *manager;

static AFHTTPSessionManager *manager;

#pragma mark - Class Methods
//+(AFHTTPRequestOperationManager *)requestOperationManager
//{
//    if (!manager) {
//        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:BASE_URL];
//        // [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
//        
//        //Adding additional text/html content type for Facebook login response from server
//        NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
//        [contentTypes addObject:@"text/html"];
//        [contentTypes addObject:@"form-data"];
//        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingAllowFragments];
//
//        [manager.responseSerializer setAcceptableContentTypes:contentTypes];
//        
//        contentTypes = nil;
//    }
////    [self setCommonRequestHeaders];
//
//    return manager;
//}

+(AFHTTPSessionManager *)requestSessionManager{
    if (!manager) {
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:
                  [NSURL URLWithString:BASE_URL]];
    }

    return manager;
}

#pragma mark - Common Headers
+(void)setCommonRequestHeaders
{
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"platform"];
    
    
//    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:AUTH_TOKEN];
//    if (userToken) {
//        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",userToken] forHTTPHeaderField:@"Authorization"];
//    }
//    
//    userToken = nil;
}


#pragma mark - Common Opeations
-(NSDictionary *)sanitizeRequestParameters:(NSDictionary *)parameters
{
    if (!parameters) {
        return nil;
    }
    
    NSMutableDictionary *sanitizeRequestParameters = [NSMutableDictionary new];
    
    for (NSString *requestKey in parameters.allKeys) {
        if ([parameters valueForKey:requestKey]) {
            [sanitizeRequestParameters setObject:[parameters valueForKey:requestKey] forKey:requestKey];
        }
    }
    
    return sanitizeRequestParameters;
}

-(id)commonResponseHandling:(id)response
{
    //Handling Error Condition
    ////NSLog(@"%@", response);
    if (![[response objectForKey:@"result"] isEqualToString:@"SUCCESS"])
    {
        if (self.completionBlockWithSuccess) {
            self.completionBlockWithSuccess(0, self.eRequestType, response, [response objectForKey:@"message"]);
        }
        
        return nil;
    }
    
    return response;
}

#pragma mark - Common Request Parameters
+(NSMutableDictionary *)setCommonRequestParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *parametersDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    NSString *UDID = [[UIDevice currentDevice] identifierForVendor].UUIDString;
//    NSString *devicetype = @"iOS";
//    [parametersDictionary setObject:UDID forKey:@"deviceid"];
//    [parametersDictionary setObject:devicetype forKey:@"device_code"];
//    [parametersDictionary setObject:devicetype forKey:@"device_type"];

    return parametersDictionary;
}


@end
