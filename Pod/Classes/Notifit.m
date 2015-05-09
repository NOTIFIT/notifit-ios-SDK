//
//  Notifit.m
//  Pods
//
//  Created by Tomas Sykora, jr. on 07/05/15.
//
//

#import "Notifit.h"

@implementation Notifit

+(void)askForPermissions
{
    [[NTFNetwork sharedClient]askForPermissions];
}

+(void)registerToken:(NSData *)token
       toApplication:(NSString *)applicationToken
             forUser:(NSString *)username
        withPassword:(NSString *)password
             success:(void (^)(NSDictionary *, NSNumber * statusCode))success
             failure:(void (^)(NSString *, NSNumber * statusCode))failure
{
    [[NTFNetwork sharedClient]initWithEmailOrUsername:username password:password appToken:applicationToken deviceToken:token success:^(NSDictionary *data, NSNumber * statusCode) {
        TRC_ENTRY
        success(data, statusCode);
    } failure:^(NSString *error, NSNumber * statusCode) {
        failure(error, statusCode);
        ;
    }];
}

+(void)createKey:(NSString *)key
      forProject:(NSString *)projectToken
         success:(void (^)(NSArray *, NSNumber *))success
         failure:(void (^)(NSString *, NSNumber *))failure
{
    
}

+(void)getKeysWithSuccess:(void (^)(NSArray *, NSNumber * statusCode))success
                  failure:(void (^)(NSString *, NSNumber * statusCode))failure
{

}

+(void)getValuesForKey:(NSString *)key
               success:(void (^)(NSArray *, NSNumber * statusCode))success
               failure:(void (^)(NSString *, NSNumber * statusCode))failure
{

}

+(void)deleteKey:(NSString *)key
         success:(void (^)(NSArray *, NSNumber * statusCode))success
         failure:(void (^)(NSString *, NSNumber * statusCode))failure {

    [[NTFNetwork sharedClient]deleteProjectKey:key
                                       success:^(NSArray *data, NSNumber *statusCode) {
                                           ;
                                       } failure:^(NSString *error, NSNumber *statusCode) {
                                           ;
                                       }];
    
}
@end
