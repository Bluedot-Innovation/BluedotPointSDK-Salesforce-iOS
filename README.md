## Salesforce JB4A SDK Integration Guide
------
### Overview

This documentation will represent how to implement `PointSDK` and `JB4ASDK` together with `BDSalesforceIntegrationWrapper` framework in your iOS App.

- [Getting started](#getting-started)
 - [Importing your project with JB4ASDK](#import-jb4a-ios)
 - [Importing your project with Bluedot PointSDK](#import-bluedot-point-ios)
 - [Importing your project with BDSalesforceIntegrationWrapper framework](#import-salesforce-integration-wrapper)
- [Integration Journey Builder for Apps SDK, Bluedot Point SDK and BDSalesforceIntegrationWrapper framework](#integration-jb4a-bluedot-salesforce-wrapper)
	- [Configure Journey Builder for Apps SDK](#configure-jb4a-sdk)
	- [Setup Bluedot Location Services](#setup-bluedot-location-services)
	- [Use case](#use-case)

### Getting started<a name="getting-started"/>
Use one of these two ways to import the JB4ASDK and PointSDK for iOS into your project:
1. CocoaPods
2. Static Library
> Notes: Only use one of these two ways to import both SDKs

#### Configuring the SDK with CocoaPods
Follow the [CocoaPods installation instructions](https://guides.cocoapods.org/using/using-cocoapods.html) using JB4ASDK and PointSDK as dependencies in the podfile. Open up the *.xcworkspace created by the install process with Xcode and start using the SDK.
> Notes: Do <b>NOT</b> use *.xcodeproj. If you open up a project file instead of a workspace, you will receive an error.

#### Configuring the SDK with header files and static library
##### Importing your project with JB4ASDK (from: [Implement JB4A SDK in your iOS App](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/sdk-implementation/implement-sdk.html))<a name="import-jb4a-ios">

Follow these steps to configure the SDK for your app.

1. In your app development environment, copy the libJB4ASDK-*.a and the header files into your project.
![alt text](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/assets/iossdk-artifacts.png)

2. Add libJB4ASDK-*.a to `Linked Frameworks and Libraries` in the Build Phases configuration section within Xcode.

3. Include the WebKit.framework in `Link Binary With Libraries` section of the Build Phases configuration in Xcode.

4. In `App Settings` from `Capabilities` section, set the `Push Notifications` switch to `ON`.
![alt text](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/assets/pushNotifications.png)

  Note that calling didReceiveLocalNotifcation on an app in the foreground of a mobile device will display a notification in the Apple Notification Center, but the mobile device will not provide a visibile or audible notification. Use an AlertController to display a message regarding the new notification. If you choose to display an alert, ensure that you clear the Apple Notification Center upon display of the alert.

  You can also call didReceiveRemoveNotification for an active app in the foreground of a mobile device. In this case, the app will not display an alert in the Apple Notification Center or provide a visible or audible notification. Decide whether to display an alert to the user upon receipt of the notification in this case.
5. Determine whether you need to implement any of the following keys to your applications plist file:
  - App downloads content from the network” is required to perform a Background App Refresh periodically for [regions and messages](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/location/geolocation.html#plist).
  - App registers for location updates” is required if you have Proximity Services turned on in configureSDKWithAppID and you want to [range for beacons](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/features/features-logging.html#plist) in the background (only for Beacon beta testers)
  - App downloads content in response to push notifications” is required if you plan on using [silent push](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/features/background-push.html) notifications.

  ![alt text](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/assets/background_modes_plist_entry.png)

##### Importing your project with Bluedot PointSDK<a name="import-bluedot-point-ios"/>
1. Download PointSDK from the `Download` section of your `Point Access Dashboard`. The SDK includes a set of header files which are in the `include` folder and a pair of static libraries: `libBDPointSDK-iphoneos.a` and `libBDPointSDK-iphonesimulator.a`.
 - A set of header files in the include folder. These header files declare the Application Programming Interface (API) between your app and Point SDK.For simplicity, you need only include BDPointSDK.h in your own source code files to include all other Point SDK headers.
 - A pair of static library files:
    - libBDPointSDK-iphoneos.a - This static library contains arm7 and arm64 architecture slices for Point SDK. The application will be automatically linked against this library when compiling for a device, which includes when archiving for distribution through the App Store.
    - libBDPointSDK-iphonesimulator.a - This static library contains i386 and x86_64 architecture slices for the Point SDK.  The application will be automatically linked against this library when compiling for the iOS simulator; during development.

2. Drag all the content from PointSDK into your project and update `Header Search Path` and `Library Search Path` from your project settings. For example,
`Header Search Path` - `${PROJECT_DIR}/PointSDK/include` and
`Library Search Path` - `${PROJECT_DIR}/PointSDK`.
![alt text](http://docs.bluedotinnovation.com/download/attachments/3244077/004-HeaderSearchPath.jpg?version=1&modificationDate=1461945922000&api=v2)
3. Set `Other Linker Flags` to `-lBDPointSDK-${PLATFORM_NAME} -ObjC` in your project settings.
4. Add following Framework Dependencies into your project
  * AudioToolbox
  * AVFoundation
  * CoreGraphics
  * CoreLocation
  * CoreMotion
  * MapKit
  * SystemConfiguration
  * UIKit
5. Disable `Bitcode` which was introduced in iOS9 because the SDK is compatible with iOS versions prior to this and can therefore not be built with Bitcode enabled. (Required for Cocoapods importing)
6. Add following values into `Required Device Capabilities` from your `Info.plist`. (Required for Cocoapods importing)
  * gps
  * location-services
  * accelerometer
7. Add key `NSLocationAlwaysUsageDescription` with a usage description to your `Info.plist`. (Required for Cocoapods importing)
8. Add following modes in the existing entry `Required background modes` from your `Info.plist`. (Required for Cocoapods importing)
  * App plays audio or streams audio/video using AirPlay
  * App registers for location updates

##### Importing your project with BDSalesforceIntegrationWrapper framework<a name="import-salesforce-integration-wrapper"/>
1. Download `BDSalesforceIntegrationWrapper.framework` from the `Download` section of your `Point Access Dashboard`.
2. Add `BDSalesforceIntegrationWrapper.framework` to the project and add the framework to `Embedded Binaries` from `General` section in project setting

### Integration Journey Builder for Apps SDK, Bluedot Point SDK and BDSalesforceIntegrationWrapper framework<a name="integration-jb4a-bluedot-salesforce-wrapper"/>
#### Configure Journey Builder for Apps SDK (from: [Implement JB4A SDK in your iOS App](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/sdk-implementation/implement-sdk.html))<a name="configure-jb4a-sdk"/>
Add the following code in the AppDelegate implementation class to configure the Journey Builder for Apps SDK. Note that you must call configureSDKWithAppId and andAccessToken and provide values from the Marketing Cloud app you created in [App Center](https://https//appcenter-auth.s1.marketingcloudapps.com/)

```
// configure the JB4A SDK in your AppDelegate.m

#import "AppDelegate.h"
#import "ETPush.h"

// AppCenter AppIDs and Access Tokens for the debug and production versions of your app
// These values should be stored securely by your application or retrieved from a remote server
static NSString *kETAppID_Debug       = @"change_this_to_your_debug_appId";            // uses Sandbox APNS for debug builds
static NSString *kETAccessToken_Debug = @"change_this_to_your_debug_accessToken";
static NSString *kETAppID_Prod        = @"change_this_to_your_production_appId";       // uses Production APNS
static NSString *kETAccessToken_Prod  = @"change_this_to_your_production_accessToken";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL successful = NO;
    NSError *error = nil;
#ifdef DEBUG
    // Set to YES to enable logging while debugging
    [ETPush setETLoggerToRequiredState:YES];

    // configure and set initial settings of the JB4ASDK
    successful = [[ETPush pushManager] configureSDKWithAppID:kETAppID_Debug
                                              andAccessToken:kETAccessToken_Debug
                                               withAnalytics:YES
                                         andLocationServices:NO       // ONLY SET TO YES IF PURCHASED AND USING GEOFENCE CAPABILITIES
                                        andProximityServices:NO       // ONLY SET TO YES IF YOU ARE PART OF THE BEACON BETA PROGRAM
                                               andCloudPages:NO       // ONLY SET TO YES IF PURCHASED AND USING CLOUDPAGES
                                             withPIAnalytics:YES
                                                       error:&error];
#else
    // configure and set initial settings of the JB4ASDK
    successful = [[ETPush pushManager] configureSDKWithAppID:kETAppID_Prod
                                              andAccessToken:kETAccessToken_Prod
                                               withAnalytics:YES
                                         andLocationServices:NO       // ONLY SET TO YES IF PURCHASED AND USING GEOFENCE CAPABILITIES
                                        andProximityServices:NO       // ONLY SET TO YES IF YOU ARE PART OF THE BEACON BETA PROGRAM
                                               andCloudPages:NO       // ONLY SET TO YES IF PURCHASED AND USING CLOUDPAGES
                                             withPIAnalytics:YES
                                                       error:&error];

#endif
    //
    // if configureSDKWithAppID returns NO, check the error object for detailed failure info. See PushConstants.h for codes.
    // the features of the JB4ASDK will NOT be useable unless configureSDKWithAppID returns YES.
    //
    if (!successful) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // something failed in the configureSDKWithAppID call - show what the error is
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed configureSDKWithAppID!", @"Failed configureSDKWithAppID!")
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                              otherButtonTitles:nil] show];
        });
    }
    else {
        // register for push notifications - enable all notification types, no categories
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound |
                                                UIUserNotificationTypeAlert
                                                categories:nil];

        [[ETPush pushManager] registerUserNotificationSettings:settings];
        [[ETPush pushManager] registerForRemoteNotifications];

        // inform the JB4ASDK of the launch options
        // possibly UIApplicationLaunchOptionsRemoteNotificationKey or UIApplicationLaunchOptionsLocalNotificationKey
        [[ETPush pushManager] applicationLaunchedWithOptions:launchOptions];

        // This method is required in order for location messaging to work and the user's location to be processed
        // Only call this method if you have LocationServices set to YES in configureSDK()
        // [[ETLocationManager sharedInstance] startWatchingLocation];
    }

    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // inform the JB4ASDK of the notification settings requested
    [[ETPush pushManager] didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // inform the JB4ASDK of the device token
    [[ETPush pushManager] registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // inform the JB4ASDK that the device failed to register and did not receive a device token
    [[ETPush pushManager] applicationDidFailToRegisterForRemoteNotificationsWithError:error];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // inform the JB4ASDK that the device received a local notification
    [[ETPush pushManager] handleLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {

    // inform the JB4ASDK that the device received a remote notification
    [[ETPush pushManager] handleNotification:userInfo forApplicationState:application.applicationState];

    // is it a silent push?
    if (userInfo[@"aps"][@"content-available"]) {
        // received a silent remote notification...

        // indicate a silent push
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
    else {
        // received a remote notification...

        // clear the badge
        [[ETPush pushManager] resetBadgeCount];
    }

    handler(UIBackgroundFetchResultNoData);
}

@end
```
  After resetBadgeCount, you should call updateET. Note that updateET may not be fully processed by the server at the time that you call, so the server’s badge value may be out of sync with the app for several minutes.

#### Setup Bluedot Location Services<a name="setup-bluedot-location-services"/>
1. Import required header files
```objc
#import <BDPointSDK.h>
```
2. Introducing `BDLocationManager` which is the entry-point for an app to start using Point SDK
```objc
  [BDLocationManager instance];
```
To enable rules which are defined via `Bluedot Point Access` web interface, it is necessary to call the authentication method from `BDLocationManager` with your username, API key and package name.
```objc
/**
    * <p>Authenticate, and start a session with <b>Point Access</b>.
    * This behavior is asynchronous and this method will return immediately. Progress of the authentication process can be
    * monitored by callbacks provided via the <b>sessionDelegate</b> property, or the KVO-enabled <b>authenticationState</b> property.</p>
    *
    * Location Services are required immediately after a successful authentication.  If your App has not already called
    * [CLLocationManager auth]
    *
    * <p>It is the responsibility of the Application to respect the authentication life-cycle and ensure that @ref BDLocationManager
    * is not already Authenticated, or in the process of Authenticating, while calling this method.</p>
    *
    * @exception BDPointSessionException Calling this method while in an invalid state will result in a @ref BDPointSessionException being thrown.
*/
[[BDLocationManager instance] authenticateWithApiKey: apiKey
                                            packageName: packageName
                                               username: username];
```
3. `BDLocationManager` expose properties for two delegates with additional features
  - `sessionDelegate` implements `BDPSessionDelegate` protocol
    - `BDPSessionDelegate` protocol provides callbacks informing the application when authentication state changes. The rules defined will only be observed while authenticated.
  - `locationDelegate` implements `BDPLocationDelegate` protocol and provide callbacks to notify your application when:
    - Zone information is received. This typically occurs immediately after the authentication process completes.
    ```objc
    didUpdateZoneInfo:
    ```
    - Any `Custom Action` defined is triggered. Either of the following callbacks will be invoked, depending on whether the trigger is a geofence or beacon.
    ```objc
    didCheckIntoFence:inZone:atCoordinate:onDate:willCheckOut:withCustomData:
    didCheckIntoBeacon:inZone:withProximity:onDate:willCheckOut:withCustomData:
    ```
    - Leave the checked-in area. If `willCheckOut` flag was set, either of the following corresponding callbacks will be made:
    ```objc
    didCheckOutFromFence:inZone:onDate:withDuration:withCustomData:
    didCheckOutFromBeacon:inZone:withProximity:onDate:withDuration:withCustomData:
    ```
    >Note: `Checkout` doesn't apply to geolines.

#### Integration BDSalesforceIntegrationWrapper.framework
The `BDSalesforceIntegrationWrapper` has two public headers:
1. BDZoneEventReporter: The singleton class used to send zone event to integration web services.

```objc
/**
  *  The delegate of BDZoneEventReporter with callback methods to indicate
  *  whether the zone event was reported successfully or not.
  */
@property (nonatomic, assign) id<BDPZoneEventReporterDelegate> delegate;

/**
  *  Gets the shared instance of the `BDZoneEventReporter`.
  *  @return The shared instance of the class.
  */
+ (instancetype)sharedInstance;

/**
  *  Report check-in event for given zone.
  *  @param salesforceSubscriberKey Salesforce subscriber key.
  *  @param zoneId ID of the triggered zone.
  *  @param apiKey API key for the app from HubExchange.
  *  @param packageName Package name for the app from HubExchange.
  *  @param username Email address for the app from HubExchange.
  */
- (void)reportCheckInWithSalesforceSubscriberKey:(NSString *) salesforceSubscriberKey
                                          zoneId:(NSString *) zoneId
                                          apiKey:(NSString *) apiKey
                                     packageName:(NSString *) packageName
                                        username:(NSString *) username;
```

2. BDZoneEventReporterDelegate: The delegate with callback methods which will be invoked when zone event is reported successfully or not

```objc
/**
 *  This method indicates that a zone event has been reported successfully.
 */
- (void)reportSuccessful;

/**
 *  Indicates a communication error with the server when sending zone event.
 *  @param error Error returned by backend with error code and description.
 */
- (void)reportFailedWithError:(NSError *) error;
```

#### Use case<a name="use-case"/>
**Objective**: Trigger a push notification to end user when the device checks in a `geofence` or `geoline`.

**Automated message**: Setup a `Send Push` activity with the content of the notification in an interaction from `Salesforce Market Cloud` - `Journey Builder`.

**Geofence or geoline**: Geographical boundaries defined in `Bluedot Point Access` with `Custom Action` setup from `Salesforce Market Cloud` - `HubExchange`.

**Assumption**: All the required components, including [JB4A SDK](#configure-jb4a-sdk), [Point SDK](#setup-bluedot-location-services) and [`BDSalesforceIntegrationWrapper.framework`](#import-salesforce-integration-wrapper) have been setup properly.

To trigger a zone event to be reported, you have to implement `didCheckIntoFence:inZone:atCoordinate:onDate:willCheckOut:withCustomData:` or `didCheckIntoBeacon:inZone:withProximity:onDate:willCheckOut:withCustomData:` in your class which inherited from `BDPLocationDelegate`.

Within the above callback methods, call `reportCheckInWithSalesforceSubscriberKey:zoneId:apiKey:packageName:username:` to send zone event and eventually trigger the push notification.

You can also implement the delegate of `BDPZoneEventReporterDelegate` to monitor whether the communication to zone event web service is successful or failed.

```objc
#import <BDSalesforceIntegrationWrapper/BDZoneEventReporter.h>
#import <BDPointSDK.h>
#import "ETPush.h"

@interface BDIntegrationManager : NSObject <BDPLocationDelegate, BDPZoneEventReporterDelegate>
@end

- (instancetype)init
{
    self = [super init];
    if (self) {
        BDLocationManager.instance.locationDelegate = self;

        NSString *subscriberKey = [[ETPush pushManager] getSubscriberKey];
        if ( subscriberKey == nil )
        {
            subscriberKey = NSUUID UUID].UUIDString;
            [[ETPush pushManager] setSubscriberKey:subscriberKey];
            [[ETPush pushManager] updateET];
        }
    }
    return self;
}

#pragma mark BDPLocationDelegate

- (void)didCheckIntoFence:(BDFenceInfo *)fence
                   inZone:(BDZoneInfo *)zoneInfo
             atCoordinate:(BDLocationCoordinate2D)coordinate
                   onDate:(NSDate *)date
             willCheckOut:(BOOL)willCheckOut
           withCustomData:(NSDictionary *)customData
{
  // getting pointApiKey, pointPackageName, pointUsername from your `HubExchange` application
  [[BDZoneEventReporter sharedInstance] reportCheckInWithSalesforceSubscriberKey:[[ETPush pushManager] getSubscriberKey] // set or generate after successful configuration of ETPush
                                                                          zoneId:zoneInfo.ID
                                                                          apiKey:pointApiKey
                                                                     packageName:pointPackageName
                                                                        username:pointUsername];
}

- (void)didCheckIntoBeacon:(BDBeaconInfo *)beacon
                    inZone:(BDZoneInfo *)zoneInfo
             withProximity:(CLProximity)proximity
                    onDate:(NSDate *)date
              willCheckOut:(BOOL)willCheckOut
            withCustomData:(NSDictionary *)customData
{
  // getting pointApiKey, pointPackageName, pointUsername from your `HubExchange` application
  [[BDZoneEventReporter sharedInstance] reportCheckInWithSalesforceSubscriberKey:[[ETPush pushManager] getSubscriberKey] // set or generate after successful configuration of ETPush
                                                                          zoneId:zoneInfo.ID
                                                                          apiKey:pointApiKey
                                                                     packageName:pointPackageName
                                                                        username:pointUsername];
}

#pragma mark BDPZoneEventReporterDelegate

- (void)reportSuccessful
{
    ...
}

- (void)reportFailedWithError:(NSError *)error
{
    ...
}

```
