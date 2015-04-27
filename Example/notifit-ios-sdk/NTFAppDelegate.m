//
//  NTFAppDelegate.m
//  notifit-ios-sdk
//
//  Created by CocoaPods on 03/26/2015.
//  Copyright (c) 2014 Lukáš Hromadník. All rights reserved.
//

#import "NTFAppDelegate.h"
#import "NTFNetwork.h"

@implementation NTFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NTFNetwork sharedClient] askForPermissions];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NTFNetwork sharedClient]initWithEmailOrUsername:@"Notifit2015" password:@"Notifit2015" appToken:@"1a048be3-35e9-e411-80b5-00155d3e0301" deviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

}

@end
