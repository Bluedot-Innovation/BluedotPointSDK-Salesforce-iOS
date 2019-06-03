//
//  BDIntegrationManager.m
//  SalesforceIntegrationDemo
//
//  Created by Jason Xie on 9/08/2016.
//  Copyright © 2016 Bluedot Innovation. All rights reserved.
//

@import BDPointSDK;
#import <Foundation/Foundation.h>
#import "BDZoneEventReporter.h"
#import "BDIntegrationManager.h"
#import "BDAuthenticateData.h"
#import "BDLocationManager+BDPointSDK+Protected.h"
#import <MarketingCloudSDK/MarketingCloudSDK.h>


static NSString *contactKeyUserDefaultsKey = @"SubcriberKeyUserDefaultsKey";
static NSString *pointAPILoginEndPointURL = @"https://globalconfig.dev-bluedot.com/";

@interface BDIntegrationManager () <BDPointDelegate>

@property (nonatomic) BDAuthenticateData *authenticateData;

@end

@implementation BDIntegrationManager

+ (instancetype)instance
{
    static BDIntegrationManager  *shareInstance = nil;
    static dispatch_once_t   dispatchOncePredicate  = 0;
    
    dispatch_block_t singletonInit = ^
    {
        dispatch_block_t mainInit = ^
        {
            shareInstance = [ [ BDIntegrationManager alloc ] init ];
            [ shareInstance setup ];
        };
        
        if( NSThread.currentThread.isMainThread )
        {
            mainInit();
        }
        else
        {
            dispatch_sync( dispatch_get_main_queue(), mainInit );
        }
    };
    
    dispatch_once( &dispatchOncePredicate, singletonInit );
    
    return( shareInstance );
}

- (void)setup
{
    BDLocationManager.instance.sessionDelegate = self;
    BDLocationManager.instance.locationDelegate = self;
    _authenticateData = BDAuthenticateData.authenticateData;
    
    _salesforceAuthenticationStatus = AuthenticationStatusNotAuthenticated;
    _pointSDKAuthenticationStatus = AuthenticationStatusNotAuthenticated;
}

- (void)authenticateMarketingCloudSDK
{
    BOOL successful = NO;
    NSError *error = nil;
    
    successful = [[MarketingCloudSDK sharedInstance] sfmc_configure:&error];
    
    if ( successful == NO )
    {
        _salesforceAuthenticationStatus = AuthenticationStatusFailed;
        if ( [ _delegate respondsToSelector:@selector(configureMarketingCloudSDKFailedWithError:) ] )
            [ _delegate configureMarketingCloudSDKFailedWithError:error ];
    }
    else
    {
        _salesforceAuthenticationStatus = AuthenticationStatusAuthenticated;
        if ( [ _delegate respondsToSelector:@selector(configureMarketingCloudSDKSuccessful) ] )
            [ _delegate configureMarketingCloudSDKSuccessful ];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * sfmcContactKey = [[MarketingCloudSDK sharedInstance] sfmc_contactKey];
        NSString * userDefaultContactKey =  [userDefaults stringForKey:contactKeyUserDefaultsKey];
        NSString * contactKey = sfmcContactKey ?: userDefaultContactKey;
        
        if ( contactKey == nil )
        {
            contactKey = [NSUUID UUID].UUIDString;
            [[MarketingCloudSDK sharedInstance] sfmc_setContactKey:contactKey];
            [userDefaults setValue:contactKey forKey:contactKeyUserDefaultsKey];
        }
        
        if (sfmcContactKey == nil && userDefaultContactKey != nil) {
            BOOL ret = [[MarketingCloudSDK sharedInstance] sfmc_setContactKey:contactKey];
            if (ret == false) [NSException raise:NSInvalidArgumentException format:@"Salesforce subscriber key cannot be empty."];
        }
        
        NSLog(@"SubscriberKey: %@", [userDefaults stringForKey:contactKeyUserDefaultsKey]);
    }
}

- (void)authenticateBDPoint
{
    [ BDLocationManager.instance authenticateWithApiKey: _authenticateData.pointApiKey
                                 endpointURL: [NSURL URLWithString:pointAPILoginEndPointURL]];
}

#pragma mark BDPLocationDelegate
- (NSString *)get8601formattedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSDate *now = [NSDate date];
    NSString *iso8601String = [dateFormatter stringFromDate:now];
    
    return iso8601String;
}

- (void)didCheckIntoFence:(BDFenceInfo *)fence
                   inZone:(BDZoneInfo *)zoneInfo
               atLocation: (BDLocationInfo *)location
             willCheckOut:(BOOL)willCheckOut
           withCustomData:(NSDictionary *)customData
{
    BDAuthenticateData *authenticateData = BDAuthenticateData.authenticateData;
    
    BDZoneEvent *zoneEvent = [BDZoneEvent build:^(id<BDZoneEventBuilder> builder) {
        [builder setSalesforceSubscriberKey:[[MarketingCloudSDK sharedInstance] sfmc_contactKey]];
        [builder setApiKey:authenticateData.pointApiKey];
        [builder setZoneId:zoneInfo.ID];
        [builder setZoneName:zoneInfo.name];
        [builder setFenceId:fence.ID];
        [builder setFenceName:fence.name];
        [builder setCheckInTime:[self get8601formattedDate]];
        [builder setCheckInLatitude:[NSNumber numberWithDouble:location.latitude]];
        [builder setCheckInLongitude:[NSNumber numberWithDouble:location.longitude]];
        [builder setCheckInBearing:[NSNumber numberWithDouble:location.bearing]];
        [builder setCheckInSpeed:[NSNumber numberWithDouble:location.speed]];
        [builder setCustomData:customData];
    }];
    
    [[BDZoneEventReporter sharedInstance] reportCheckInWithBDZoneEvent: zoneEvent];
}

- (void)didCheckIntoBeacon:(BDBeaconInfo *)beacon
                    inZone:(BDZoneInfo *)zoneInfo
                atLocation: (BDLocationInfo *)locationInfo
             withProximity: (CLProximity)proximity
              willCheckOut: (BOOL)willCheckOut
            withCustomData: (NSDictionary *)customData
{
    BDAuthenticateData *authenticateData = BDAuthenticateData.authenticateData;
    
    BDZoneEvent *zoneEvent = [BDZoneEvent build:^(id<BDZoneEventBuilder> builder) {
        [builder setSalesforceSubscriberKey:[[MarketingCloudSDK sharedInstance] sfmc_contactKey]];
        [builder setApiKey:authenticateData.pointApiKey];
        [builder setZoneId:zoneInfo.ID];
        [builder setZoneName:zoneInfo.name];
        [builder setBeaconId:beacon.ID];
        [builder setBeaconName:beacon.name];
        [builder setCheckInTime:[self get8601formattedDate]];
        [builder setCheckInLatitude:[NSNumber numberWithDouble:locationInfo.latitude]];
        [builder setCheckInLongitude:[NSNumber numberWithDouble:locationInfo.longitude]];
        [builder setCheckInBearing:[NSNumber numberWithDouble:locationInfo.bearing]];
        [builder setCheckInSpeed:[NSNumber numberWithDouble:locationInfo.speed]];
        [builder setCustomData:customData];
    }];
    
    [[BDZoneEventReporter sharedInstance] reportCheckInWithBDZoneEvent: zoneEvent];
}

- (void)didCheckOutFromFence:(BDFenceInfo *)fence
                      inZone:(BDZoneInfo *)zoneInfo
                      onDate:(NSDate *)date
                withDuration:(NSUInteger)checkedInDuration
              withCustomData:(NSDictionary *)customData
{
    BDAuthenticateData *authenticateData = BDAuthenticateData.authenticateData;
    
    BDZoneEvent *zoneEvent = [BDZoneEvent build:^(id<BDZoneEventBuilder> builder) {
        [builder setSalesforceSubscriberKey:[[MarketingCloudSDK sharedInstance] sfmc_contactKey]];
        [builder setApiKey:authenticateData.pointApiKey];
        [builder setZoneId:zoneInfo.ID];
        [builder setZoneName:zoneInfo.name];
        [builder setFenceId:fence.ID];
        [builder setFenceName:fence.name];
        [builder setCheckOutTime:[self get8601formattedDate]];
        [builder setDwellTime:[NSNumber numberWithInt:checkedInDuration]];
        [builder setCustomData:customData];
    }];
    
    [[BDZoneEventReporter sharedInstance] reportCheckOutWithBDZoneEvent: zoneEvent];
}

- (void)didCheckOutFromBeacon:(BDBeaconInfo *)beacon
                       inZone:(BDZoneInfo *)zoneInfo
                withProximity:(CLProximity)proximity
                       onDate:(NSDate *)date
                 withDuration:(NSUInteger)checkedInDuration
               withCustomData:(NSDictionary *)customData
{
    BDAuthenticateData *authenticateData = BDAuthenticateData.authenticateData;
    
    BDZoneEvent *zoneEvent = [BDZoneEvent build:^(id<BDZoneEventBuilder> builder) {
        [builder setSalesforceSubscriberKey:[[MarketingCloudSDK sharedInstance] sfmc_contactKey]];
        [builder setApiKey:authenticateData.pointApiKey];
        [builder setZoneId:zoneInfo.ID];
        [builder setZoneName:zoneInfo.name];
        [builder setBeaconId:beacon.ID];
        [builder setBeaconName:beacon.name];
        [builder setCheckOutTime:[self get8601formattedDate]];
        [builder setDwellTime:[NSNumber numberWithInt:checkedInDuration]];
        [builder setCustomData:customData];
    }];
    [[BDZoneEventReporter sharedInstance] reportCheckOutWithBDZoneEvent: zoneEvent];
}

#pragma mark BDPSessionDelegate

- (void)authenticationWasSuccessful
{
    _pointSDKAuthenticationStatus = AuthenticationStatusAuthenticated;
    if ( _delegate && [ _delegate respondsToSelector:@selector(authenticatePointSDKSuccessful) ] )
        [ _delegate authenticatePointSDKSuccessful ];
}

- (void)authenticationWasDeniedWithReason: (NSString *)reason
{
    _pointSDKAuthenticationStatus = AuthenticationStatusFailed;
    if ( _delegate && [ _delegate respondsToSelector:@selector(authenticatePointSDKFailedWithError:) ] ) {
        NSError *error = [ NSError errorWithDomain:NSStringFromClass(self.class)
                                              code:kCFSOCKS4ErrorRequestFailed
                                          userInfo:@{ NSLocalizedDescriptionKey: reason } ];
        [ _delegate authenticatePointSDKFailedWithError:error ];
    }
}

- (void)authenticationFailedWithError: (NSError *)error
{
    _pointSDKAuthenticationStatus = AuthenticationStatusFailed;
    if ( _delegate && [ _delegate respondsToSelector:@selector(authenticatePointSDKFailedWithError:) ] )
        [ _delegate authenticatePointSDKFailedWithError:error ];
}

- (void)didEndSession
{
    _pointSDKAuthenticationStatus = AuthenticationStatusNotAuthenticated;
}

- (void)didEndSessionWithError: (NSError *)error
{
    _pointSDKAuthenticationStatus = AuthenticationStatusNotAuthenticated;
}

- (void)willAuthenticateWithApiKey:(NSString *)apiKey {
    
}

@end
