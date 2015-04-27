//
//  NTFNetwork.m
//  notifit-ios-sdk
//
//  Created by Tomas Sykora, jr. on 23/04/15.
//  Copyright (c) 2015 AJTY, s.r.o. http://www.ajty.cz All rights reserved.
//

#import "NTFDefines.h"
#import "NTFNetwork.h"

@implementation NTFNetwork

+ (NTFNetwork *)sharedClient
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK( ^ {
        NSURL *url = [NSURL URLWithString:kNTFBaseURLString];
        return [[self alloc] initWithBaseURL:url];
    });
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (!self) {
        self = [super init];
        _request = [[NSURLRequest alloc]initWithURL:url];
    }
    return self;
}

- (void)askForPermissions
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)initWithEmailOrUsername:(NSString *)username password:(NSString *)password appToken:(NSString *)appToken deviceToken:(NSData *) deviceToken
{

    _appToken = appToken;
    _username = username;
    _password = password;

    [self postPushNotificationToken:deviceToken];

}

- (void)postPushNotificationToken:(NSData *)newDeviceToken
{

    NSString  *deviceToken = [[[[newDeviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://notifit.io/api/Account/Login"]]];

    request.HTTPMethod = @"POST";

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSDictionary *parameters = @{
        @"Username" : _username,
        @"Password" : _password
    };


    NSError *error;
    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:parameters
                                                              options:0
                                                                error:&error];
    request.HTTPBody = requestBodyData;



    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler: ^ (NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        long statusCode = [httpResponse statusCode];
        TRC_LOG(@"[NOTIFIT]: POST %ld", statusCode)
        _responseData = [[NSMutableData alloc] init];


        NSError *error;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://notifit.io/api/DeviceApple"]]];
        request.HTTPMethod = @"POST";

        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:[NSString stringWithFormat:@"Bearer %@", responseDictionary[@"accessToken"]] forHTTPHeaderField:@"Authorization"];

        NSDictionary *parameters = @{
            @"DeviceToken" : deviceToken,
            @"AppToken"    : _appToken
        };


        NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:parameters
                                                                  options:0
                                                                    error:&error];
        request.HTTPBody = requestBodyData;

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];

        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler: ^ (NSURLResponse *response, NSData *data, NSError *connectionError) {
            long statusCode = [httpResponse statusCode];
            TRC_LOG(@"[NOTIFIT]: Device Token Successfully POSTed to server %ld", statusCode)
            NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            TRC_OBJ(responseDictionary)

        }];
    }];
}

@end
