//
//  BDZoneEvent.m
//  BDSalesforceIntegrationWrapper
//
//  Created by Ravindra Wuyyuru on 29/6/17.
//  Copyright © 2017 Bluedot Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDZoneEvent.h"

@interface BDZoneEvent() <BDZoneEventBuilder>

@property (nonatomic)  NSString *salesforceSubscriberKey;
@property (nonatomic)  NSString *apiKey;
@property (nonatomic)  NSString *packageName;
@property (nonatomic)  NSString *userName;
@property (nonatomic)  NSString *zoneId;
@property (nonatomic)  NSString *zoneName;
@property (nonatomic)  NSString *fenceId;
@property (nonatomic)  NSString *fenceName;
@property (nonatomic)  NSString *beaconId;
@property (nonatomic)  NSString *beaconName;
@property (nonatomic)  NSString *checkInTime;
@property (nonatomic)  NSString *checkOutTime;
@property (nonatomic)  NSNumber *checkInLatitude;
@property (nonatomic)  NSNumber *checkInLongitude;
@property (nonatomic)  NSNumber *checkInBearing;
@property (nonatomic)  NSNumber *checkInSpeed;
@property (nonatomic)  NSNumber *dwellTime;
@property (nonatomic)  NSDictionary *customData;

@end
@implementation BDZoneEvent

+ (instancetype)build:(void(^)(id<BDZoneEventBuilder>builder))buildBlock {
    BDZoneEvent* zoneEvent = [BDZoneEvent new];
    if (buildBlock) buildBlock(zoneEvent);
    return zoneEvent;
}

static id ObjectOrNull(id object)
{
    return object ? object: [NSNull null];
}


-(NSDictionary *)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.salesforceSubscriberKey,@"subscriberKey",
            self.apiKey,@"apiKey",
            self.packageName ,@"packageName",
            self.userName,@"userName",
            self.zoneId,@"zoneId",
            ObjectOrNull(self.zoneName),@"zoneName",
            ObjectOrNull(self.fenceId),@"fenceId",
            ObjectOrNull(self.fenceName),@"fenceName",
            ObjectOrNull(self.beaconId),@"beaconId",
            ObjectOrNull(self.beaconName),@"beaconName",
            ObjectOrNull(self.checkInTime),@"checkInTime",
            ObjectOrNull(self.checkOutTime),@"checkOutTime",
            ObjectOrNull(self.checkInLatitude),@"checkInLatitude",
            ObjectOrNull(self.checkInLongitude),@"checkInLongitude",
            ObjectOrNull(self.checkInBearing),@"checkInBearing",
            ObjectOrNull(self.checkInSpeed),@"checkInSpeed",
            ObjectOrNull(self.dwellTime),@"dwellTime",
            ObjectOrNull(self.customData),@"customData",
            @NO,@"checkout",
            nil];
}

@end
