//
//  BDPIntegrationManagerDelegate.h

//  SalesforceIntegrationDemo
//
//  Created by Jason Xie on 9/08/2016.
//  Copyright © 2016 Bluedot Innovation. All rights reserved.
//

@protocol BDPIntegrationManagerDelegate <NSObject>

- (void)configureMarketingCloudSDKSuccessful;

- (void)authenticatePointSDKSuccessful;

@optional

- (void)configureMarketingCloudSDKFailedWithError: (NSError *)error;

- (void)authenticatePointSDKFailedWithError: (NSError *)error;

@end
