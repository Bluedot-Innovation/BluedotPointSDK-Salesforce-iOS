//
//  BDIntegrationWebService.m
//  SalesforceIntegrationDemo
//
//  Created by Jason Xie on 10/08/2016.
//  Copyright © 2016 Bluedot Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDZoneEventReporter.h"
#import "BDZoneEvent.h"

#ifdef DEBUG
static NSString *urlString = @"https://publicapi.dev-bluedot.com/1/salesforce/event";
#else
static NSString *urlString = @"https://api.bluedotinnovation.com/1/salesforce/event";
#endif

@interface BDZoneEventReporter()

@property (nonatomic) NSURLSession *urlSession;

@end

@implementation BDZoneEventReporter

+ (instancetype)sharedInstance
{
    static BDZoneEventReporter  *shareInstance = nil;
    static dispatch_once_t   dispatchOncePredicate  = 0;

    dispatch_block_t singletonInit = ^
    {
        dispatch_block_t mainInit = ^
        {
            shareInstance = [ [ BDZoneEventReporter alloc ] init ];
            shareInstance.urlSession = [ self urlSession ];
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

+ (NSURLSession *)urlSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *webServiceQueue = [ [ NSOperationQueue alloc ] init ];
    webServiceQueue.name = @"Salesforce Integration Queue";

    return [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:webServiceQueue];
}

- (void)reportCheckInWithBDZoneEvent:(BDZoneEvent *) zoneEvent
{
    NSURLRequest *request = [self urlRequestFromSalesforceSubscriberKey:(BDZoneEvent *)zoneEvent];

    [self postToIntegrationServerWithRequest:request];
}

- (void)reportCheckOutWithBDZoneEvent:(BDZoneEvent *) zoneEvent
{
    NSURLRequest *request = [self urlRequestFromSalesforceSubscriberKey:(BDZoneEvent *)zoneEvent
                                                        checkOutEnabled:YES];

    [self postToIntegrationServerWithRequest:request];
}

- (void)postToIntegrationServerWithRequest: (NSURLRequest *)request
{
    NSURLSessionTask *task = [_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = httpResponse.statusCode;

        BOOL isOK = statusCode >= 200 && statusCode < 300;

        if ( isOK )
        {
            if ( [ _delegate respondsToSelector:@selector(reportSuccessful) ] )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate reportSuccessful];
                });
            }
        }
        else
        {
            NSDictionary *jsonResponse = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingMutableLeaves
                                          error:nil];

            NSString *errorMessage = jsonResponse[@"error"] ?: [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            NSError *responseError = error ?: [NSError errorWithDomain:NSNetServicesErrorDomain
                                                                  code:statusCode
                                                              userInfo:@{NSLocalizedDescriptionKey:errorMessage}];

            if ( responseError && [ _delegate respondsToSelector:@selector(reportFailedWithError:) ] )
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ _delegate reportFailedWithError:responseError ];
                });
            }
        }
    }];

    [task resume];
}

- (NSURLRequest *)urlRequestFromSalesforceSubscriberKey:(BDZoneEvent *) zoneEvent
{
    return [self urlRequestFromSalesforceSubscriberKey:(BDZoneEvent *) zoneEvent
                                       checkOutEnabled:NO];
}

- (NSURLRequest *)urlRequestFromSalesforceSubscriberKey:(BDZoneEvent *) zoneEvent
                                               checkOutEnabled:(BOOL) checkOutEnabled
{
    if ( zoneEvent.salesforceSubscriberKey == nil )   [NSException raise:NSInvalidArgumentException format:@"Salesforce subscriber key cannot be empty."];
    if ( zoneEvent.zoneId == nil )                    [NSException raise:NSInvalidArgumentException format:@"Zone ID cannot be empty."];
    if ( zoneEvent.apiKey == nil )                    [NSException raise:NSInvalidArgumentException format:@"API key cannot be empty"];


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.allowsCellularAccess = YES;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *data = [[zoneEvent dictionary] mutableCopy];

    if ( checkOutEnabled )
    {
        [data setValue:@YES forKey:@"checkout"];
    }

#ifdef DEBUG
    NSLog(@"Sending to %@ with data: %@", urlString, data);
#endif

    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];

    return request;
}

@end
