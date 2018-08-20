## Salesforce Marketing Cloud SDK Integration Guide
------
### Overview

This documentation will represent how to implement `PointSDK` and `MarketingCloudSDK` together with `BluedotPointSDK-Salesforce` framework in your iOS App.

### Getting started

Add pod 'BluedotPointSDK-Salesforce', '~> 1.0' similar to the following to your Podfile:

    target 'MyApp' do
        pod 'BluedotPointSDK-Salesforce', '~> 1.0'
    end

Then run a `pod install` inside your terminal, or from CocoaPods.app.

Add `MarketingCloudSDKConfiguration.json` to your project and configure as per following:

    [{
    "name": "production",
    "appid": "<Marketing Cloud appid>",
    "accesstoken": "<Marketing Cloud accesstoken>",
    "etanalytics": false,
    "pianalytics": false,
    "location": false,
    "inbox": false
    }]

Add MarketingCloudSDKConfiguration.json to Copy Bundle Resources in your target’s Build Phases settings.

Add following key to you Info.plist

    <key>BDPointApiKey</key> 
    <string>your PointSDK API key</string>

Add `UNUserNotificationCenterDelegate` to the AppDelegate. Implement as shown below.

    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        [[MarketingCloudSDK sharedInstance] sfmc_setDeviceToken:deviceToken];
    }

    - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
        os_log_debug(OS_LOG_DEFAULT, "didFailToRegisterForRemoteNotificationsWithError = %@", error);
    }

    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    - (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {

        // tell the MarketingCloudSDK about the notification
        [[MarketingCloudSDK sharedInstance] sfmc_setNotificationRequest:response.notification.request];

        if (completionHandler != nil) {
            completionHandler();
        }
    }

    // This method is REQUIRED for correct functionality of the SDK.
    // This method will be called on the delegate when the application receives a silent push

    -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
    {
        UNMutableNotificationContent *theSilentPushContent = [[UNMutableNotificationContent alloc] init];
        theSilentPushContent.userInfo = userInfo;
        UNNotificationRequest *theSilentPushRequest = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:theSilentPushContent trigger:nil];

        [[MarketingCloudSDK sharedInstance] sfmc_setNotificationRequest:theSilentPushRequest];

        completionHandler(UIBackgroundFetchResultNewData);
    }

Implement `BDPZoneEventReporterDelegate` and `BDPIntegrationManagerDelegate` in your application. Then authenticate with Bluedot point access and Marketing Cloud platform:

    [BDIntegrationManager.instance authenticateMarketingCloudSDK];
    [BDIntegrationManager.instance authenticateBDPoint];

For more details please visit [Bluedot documentation](https://docs.bluedot.io) and [MarketingCloudSDK iOS](https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/get-started/apple.html) and check out our [integration example](https://github.com/Bluedot-Innovation/Salesforce-Simple-Integration-Demo-iOS)

## Copyright and license

Created by Bluedot Innovation in 2018.
Copyright © 2018 Bluedot Innovation. All rights reserved.

By dowloading or using the Bluedot Point SDK for iOS, You agree to the Bluedot [Terms and Conditions](http://www.bluedotinnovation.com/html/downloads/pdfs/terms-and-conditions-bluedot-070814.pdf)
and [Privacy Policy](http://www.bluedotinnovation.com/html/downloads/pdfs/privacy-policy-bluedot-170815.pdf)
and [Billing Policy](http://www.bluedotinnovation.com/html/downloads/pdfs/privacy-policy-bluedot-170815.pdf)
and acknowledge that such terms govern Your use of and access to the iOS SDK.