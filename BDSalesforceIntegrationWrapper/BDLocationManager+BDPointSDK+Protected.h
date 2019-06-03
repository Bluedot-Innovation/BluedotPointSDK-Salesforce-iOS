//
//  BDLocationManager+BDPointSDK+Protected.h
//  BDSalesforceIntegrationWrapper
//
//  Created by Pavel Oborin on 3/6/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

@class BDLocationManager;

@interface BDLocationManager (BDPointSDK_Protected)

/**
 * <p>Like authenticateWithApiKey: but allows the URL of <b>Point Access</b> to be overridden to a non-default value.
 * This should not normally be used; but may become necessary in certain support scenarios.</p>
 */
- (void)authenticateWithApiKey: (NSString *)apiKey
                   endpointURL: (NSURL *)endpointURL;

@end
