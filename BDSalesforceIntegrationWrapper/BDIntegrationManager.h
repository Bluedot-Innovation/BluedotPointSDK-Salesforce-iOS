//
//  BDIntegrationManager.h
//  SalesforceIntegrationDemo
//
//  Created by Jason Xie on 9/08/2016.
//  Copyright © 2016 Bluedot Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDPIntegrationManagerDelegate.h"
@import BDPointSDK;

typedef enum : NSUInteger {
    AuthenticationStatusNotAuthenticated,
    AuthenticationStatusAuthenticated,
    AuthenticationStatusFailed,
} AuthenticationStatus;

@interface BDIntegrationManager : NSObject

@property (nonatomic) id<BDPIntegrationManagerDelegate>  delegate;
@property AuthenticationStatus salesforceAuthenticationStatus;
@property AuthenticationStatus pointSDKAuthenticationStatus;

+ (instancetype)instance;

- (void)authenticateMarketingCloudSDK;

- (void)authenticateBDPointWithAuthorization:(BDAuthorizationLevel)authorization;

@end
