//
//  LoginService.h
//  Opportuniti
//
//  Created by Mayank Gupta on 24/01/16.
//  Copyright © 2016 Mayank Gupta. All rights reserved.
//

#import "ServerConnect.h"

@interface LoginService : ServerConnect

//-(void)signUpWithParameters:(NSDictionary *)parameters;

-(void)loginWithParameters:(NSDictionary *)parameters;
//-(void)socialLoginWithParameters:(NSDictionary *)parameters;

-(void)logoutWithParameters:(NSDictionary *)parameters;

@end
