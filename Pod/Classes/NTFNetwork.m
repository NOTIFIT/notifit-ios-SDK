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

- (void)initWithEmailOrUsername:(NSString *)username
                       password:(NSString *)password
                       appToken:(NSString *)appToken
                    deviceToken:(NSData *) deviceTokenData
                        success:(void (^)(NSDictionary  *data, NSNumber * statusCode))success
                        failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

{

    _appToken = appToken;
    _username = username;
    _password = password;



    NSString  *deviceToken = [[[[deviceTokenData description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                               stringByReplacingOccurrencesOfString:@">" withString:@""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];


    UIDevice * device = [UIDevice currentDevice];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];

    float differenceToGMT = [[NSTimeZone systemTimeZone] secondsFromGMT] / 3600;

    NSDictionary *dataToSend = @{
                                 @"DeviceToken" : deviceToken,
                                 @"AppToken"    : _appToken,
                                 @"DeviceName"  : device.name,
                                 @"DeviceSystemName" : device.systemName,
                                 @"DeviceSystemVersion" : device.systemVersion,
                                 @"DeviceModel" : device.model,
                                 @"DeviceLocalizedModel" : device.localizedModel,
                                 @"DeviceIdentifierForVendor" : [device.identifierForVendor UUIDString],
                                 @"DeviceTimeZone" : timeZone.name,
                                 @"DevicePreferedLanguage" : [[NSLocale preferredLanguages] objectAtIndex:0],
                                 @"DeviceCFBundleDisplayName" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                                 @"DeviceCFBundleShortVersionString" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                 @"DeviceCFBundleVersion" : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                                 @"DeviceBundleIdentifier" : [[NSBundle mainBundle] bundleIdentifier],
                                 @"DeviceDifferenceToGMT": [NSNumber numberWithFloat:differenceToGMT]

                                 };

    [self postDataToNotifit:dataToSend toURLString:@"DeviceToken"  withSuccessMessage:@"Device informations" success:^(NSDictionary *details, NSNumber * statusCode) {
        success(details, statusCode);
    } failure:^(NSString *error, NSNumber * statusCode) {
        failure(error, statusCode);
    }];

}


- (void)createKey:(NSString *)key
       forProject:(NSString *)projectToken
          success:(void (^)(NSDictionary *, NSNumber *))success
          failure:(void (^)(NSString *, NSNumber *))failure
{


    NSDictionary *dataToSend = @{
                                 @"ProjectToken" : projectToken,
                                 @"KeyName": key
                                 };


    [self postDataToNotifit:dataToSend
                toURLString:@"Project/CreateKey"
         withSuccessMessage:[NSString stringWithFormat:@"Project key %@", key]
                    success:^(NSDictionary *details, NSNumber * statusCode) {
                success(details, statusCode);
    } failure:^(NSString *error, NSNumber * statusCode) {
                failure(error, statusCode);
    }];
}



-(void)deleteProjectKey:(NSString *)key
                success:(void (^)(NSArray *, NSNumber *))success
                failure:(void (^)(NSString *, NSNumber *))failure
{
    [self deleteDataFromNotifitURL:[NSString stringWithFormat:@"Project/DeleteKey?ProjectToken=%@&AdditionalKeyId=%@", _projectToken, key]
                withSuccessMessage:@"All Values For Project Key"
                           success:^(NSDictionary *details, NSNumber *statusCode) {
        ;
    } failure:^(NSString *error, NSNumber *statusCode) {
        ;
    }];

}

-(void) deleteDataFromNotifitURL:(NSString*)urlString
       withSuccessMessage:(NSString*)message
                  success:(void (^)(NSDictionary *details, NSNumber * statusCode))success
                  failure:(void (^)(NSString * error, NSNumber * statusCode))failure

{

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
                               if (statusCode == 200) {
                                   TRC_LOG(@"[NOTIFIT]: POST %ld", statusCode)
                               }

                               _responseData = [[NSMutableData alloc] init];



                               NSError *error;
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                               [[UIDevice currentDevice] name];


                               NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://notifit.io/api/%@", urlString]]];
                               request.HTTPMethod = @"DELETE";

                               [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                               [request addValue:[NSString stringWithFormat:@"Bearer %@", responseDictionary[@"accessToken"]] forHTTPHeaderField:@"Authorization"];

//                               NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:dataToPost
//                                                                                         options:0
//                                                                                           error:&error];
                               request.HTTPBody = requestBodyData;



                               NSOperationQueue *queue = [[NSOperationQueue alloc] init];

                               [NSURLConnection sendAsynchronousRequest:request
                                                                  queue:queue
                                                      completionHandler: ^ (NSURLResponse *response, NSData *data, NSError *connectionError) {

                                                          NSHTTPURLResponse * deviceInfoResponse = (NSHTTPURLResponse *)response;
                                                          long statusCode = [deviceInfoResponse statusCode];
                                                          if (statusCode == 200) {
                                                              TRC_LOG(@"[NOTIFIT]: %@ Successfully POSTed to server %ld",message, statusCode)
//                                                              NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                              TRC_OBJ(responseDictionary)

                                                          }else {
                                                              TRC_LOG(@"[NOTIFIT]: Fekal Error %ld", statusCode)
//                                                              NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                              TRC_OBJ(responseDictionary)

                                                              
                                                          }
                                                          
                                                      }];
                           }];

}

-(void) postDataToNotifit:(NSDictionary*)dataToPost
              toURLString:(NSString*)urlString
       withSuccessMessage:(NSString*)message
                  success:(void (^)(NSDictionary *details, NSNumber * statusCode))success
                  failure:(void (^)(NSString * error, NSNumber * statusCode))failure
{
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
                               if (statusCode == 200) {
                                   TRC_LOG(@"[NOTIFIT]: POST %ld", statusCode)
                               }

                               _responseData = [[NSMutableData alloc] init];



                               NSError *error;
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                               [[UIDevice currentDevice] name];


                               NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://notifit.io/api/%@", urlString]]];
                               request.HTTPMethod = @"POST";

                               [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                               [request addValue:[NSString stringWithFormat:@"Bearer %@", responseDictionary[@"accessToken"]] forHTTPHeaderField:@"Authorization"];

                               NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:dataToPost
                                                                                         options:0
                                                                                           error:&error];
                               request.HTTPBody = requestBodyData;

                               NSOperationQueue *queue = [[NSOperationQueue alloc] init];

                               [NSURLConnection sendAsynchronousRequest:request
                                                                  queue:queue
                                                      completionHandler: ^ (NSURLResponse *response, NSData *data, NSError *connectionError) {

                                                          NSHTTPURLResponse * deviceInfoResponse = (NSHTTPURLResponse *)response;
                                                          long statusCode = [deviceInfoResponse statusCode];
                                                          if (statusCode == 200) {
                                                              TRC_LOG(@"[NOTIFIT]: %@ Successfully POSTed to server %ld",message, statusCode)
//                                                              NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                              TRC_OBJ(responseDictionary)
                                                          }else {
                                                              TRC_LOG(@"[NOTIFIT]: Fekal Error %ld", statusCode)
//                                                              NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                              TRC_OBJ(responseDictionary)

                                                          }
                                                          
                                                      }];
                           }];
}












-(void) getDataFromNotifit:(NSDictionary*)dataToPost
              toURLString:(NSString*)urlString
       withSuccessMessage:(NSString*)message
                  success:(void (^)(NSArray *data))success
                  failure:(void (^)(NSString * error))failure
{
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
                               if (statusCode == 200) {
                                   TRC_LOG(@"[NOTIFIT]: POST %ld", statusCode)
                               }

                               _responseData = [[NSMutableData alloc] init];



                               NSError *error;
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                               [[UIDevice currentDevice] name];


                               NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://notifit.io/api/%@", urlString]]];
                               request.HTTPMethod = @"GET";

                               [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                               [request addValue:[NSString stringWithFormat:@"Bearer %@", responseDictionary[@"accessToken"]] forHTTPHeaderField:@"Authorization"];

                               NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:dataToPost
                                                                                         options:0
                                                                                           error:&error];
                               request.HTTPBody = requestBodyData;

                               NSOperationQueue *queue = [[NSOperationQueue alloc] init];

                               [NSURLConnection sendAsynchronousRequest:request
                                                                  queue:queue
                                                      completionHandler: ^ (NSURLResponse *response, NSData *data, NSError *connectionError) {

                                                          NSHTTPURLResponse * deviceInfoResponse = (NSHTTPURLResponse *)response;
                                                          long statusCode = [deviceInfoResponse statusCode];
                                                          if (statusCode == 200) {
                                                              TRC_LOG(@"[NOTIFIT]: %@ Successfully POSTed to server %ld",message, statusCode)
//                                                              NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                              TRC_OBJ(responseDictionary)
                                                          }else {
                                                              TRC_LOG(@"[NOTIFIT]: Fekal Error %ld", statusCode)
//                                                              NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                                                              TRC_OBJ(responseDictionary)

                                                          }
                                                          
                                                      }];
                           }];
}



@end
