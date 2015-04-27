//
//  NTFNetwork.h
//  notifit-ios-sdk
//
//  Created by Tomas Sykora, jr. on 23/04/15.
//  Copyright (c) 2015 AJTY, s.r.o. http://www.ajty.cz All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNTFDeviceToken @"NTFDeviceToken"

@interface NTFNetwork : NSObject <NSURLConnectionDelegate,UIApplicationDelegate>
{
    NSMutableData *_responseData;
    NSURLRequest *_request;
}



+ (NTFNetwork *)sharedClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)initWithEmailOrUsername:(NSString *)username password:(NSString *)password appToken:(NSString *)appToken deviceToken:(NSData*) deviceToken;
- (void)postPushNotificationToken:(NSData *)newDeviceToken;
- (void) askForPermissions;


@property (nonatomic, strong) NSString * appToken;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;


@end
