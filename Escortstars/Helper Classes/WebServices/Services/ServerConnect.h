//
//  ServerConnect.h
//  InvisionApp
//
//  Created by Mayank on 19/05/15.
//  Copyright (c) 2015 Reetika. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFHTTPSessionManager.h>


typedef NS_ENUM( NSUInteger, HTTP_REQUEST_TYPE) {
    GET_REQUEST,
    POST_REQUEST
};

typedef NS_ENUM( NSUInteger, REQUEST_PRIORITY) {
    LOW_PRIORITY,
    MODERATE_PRIORITY,
    HIGH_PRIORITY
};


@interface ServerConnect : NSObject

#pragma mark - Common Opeations
+(NSMutableDictionary *)setCommonRequestParameters:(NSDictionary *)parameters;

-(NSDictionary *)sanitizeRequestParameters:(NSDictionary *)parameters;
-(id)commonResponseHandling:(id)response;

#pragma mark - Request Attributes
@property (nonatomic, assign) HTTP_REQUEST_TYPE httpRequestType;
@property (nonatomic, retain) NSString *eRequestType;
@property (nonatomic, assign) REQUEST_PRIORITY priority;


@property (nonatomic, strong) void (^ completionBlockWithSuccess)(int statusCode, NSString *requestType, id response, NSString *errorMessage);
@property (nonatomic, strong) void (^ completionBlockWithFailure)(NSString *requestType, NSError *error);

#pragma mark - Class Methods
+(AFHTTPSessionManager*)requestSessionManager;
//+(AFHTTPRequestOperationManager *)requestOperationManager;

@end