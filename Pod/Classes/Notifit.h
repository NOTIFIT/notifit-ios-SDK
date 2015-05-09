//
//  Notifit.h
//  Pods
//
//  Created by Tomas Sykora, jr. on 07/05/15.
//
//

#import <Foundation/Foundation.h>
#import "NTFNetwork.h"
#import "NTFDefines.h"

@interface Notifit : NSObject

+ (void) askForPermissions;

+ (void) registerToken:(NSData*)token
         toApplication:(NSString*) applicationToken
               forUser:(NSString*) username
          withPassword:(NSString*) password
               success:(void (^)(NSDictionary *data, NSNumber * statusCode))success
               failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

+ (void) createKey:(NSString*) key
        forProject:(NSString*) projectToken
           success:(void (^)(NSArray *data, NSNumber * statusCode))success
           failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

+ (void) getKeysWithSuccess:(void (^)(NSArray *data, NSNumber * statusCode))success
                    failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

+ (void) deleteKey:(NSString *)key
           success:(void (^)(NSArray *data, NSNumber * statusCode))success
           failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

+ (void) getValuesForKey:(NSString*) key
                 success:(void (^)(NSArray *data, NSNumber * statusCode))success
                 failure:(void (^)(NSString * error, NSNumber * statusCode))failure;

@end
