//
//  BDAuthenticateData.m
//  SalesforceIntegrationDemo
//
//  Created by Jason Xie on 10/08/2016.
//  Copyright © 2016 Bluedot Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDAuthenticateData.h"

static NSString *kBDPointApiKey = @"BDPointApiKey";

@interface BDAuthenticateData()

@property (nonatomic, readwrite) NSString *pointApiKey;

@end

@implementation BDAuthenticateData

+ (instancetype) authenticateData
{
    static BDAuthenticateData  *shareInstance = nil;
    static dispatch_once_t   dispatchOncePredicate  = 0;
    
    dispatch_block_t singletonInit = ^
    {
        dispatch_block_t mainInit = ^
        {
            shareInstance = [ [ BDAuthenticateData alloc ] init ];
            NSBundle *mainBundle = [ NSBundle mainBundle ];

            shareInstance.pointApiKey = [ mainBundle objectForInfoDictionaryKey:kBDPointApiKey ];
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



@end
