//
//  NTFNetwork.h
//  notifit-ios-sdk
//
//  Created by Tomas Sykora, jr. on 23/04/15.
//  Copyright (c) 2015 AJTY, s.r.o. http://www.ajty.cz All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNTFDeviceToken @"NTFDeviceToken"

@interface NTFNetwork : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    NSURLRequest *_request;
}

@property (nonatomic, strong) NSString * appToken;
@property (nonatomic, strong) NSString * projectToken;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;

+ (NTFNetwork *)sharedClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void) askForPermissions;

- (void) initWithEmailOrUsername:(NSString *)username
                        password:(NSString *)password
                        appToken:(NSString *)appToken
                     deviceToken:(NSData*) deviceToken
                         success:(void (^)(NSDictionary *data, NSNumber * statusCode))success
                         failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

- (void) createKey:(NSString *)key
        forProject:(NSString *)projectToken
           success:(void (^)(NSDictionary *data, NSNumber * statusCode))success
           failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

- (void) deleteProjectKey:(NSString*)key
                  success:(void (^)(NSArray *data, NSNumber * statusCode))success
                  failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

@end
