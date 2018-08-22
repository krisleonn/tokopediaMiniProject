//
//  NetworkManager.h
//  Moselo
//
//  Created by Ritchie Nathaniel on 3/9/17.
//  Copyright © 2017 Moselo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY @"Prefs.NetworkManagerNoConnectionNotificationKey"

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedManager;

- (void)get:(NSString *)urlString
 parameters:(NSMutableDictionary *)parameters
   progress:(void (^)(NSProgress *downloadProgress))progress
    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;
- (void)post:(NSString *)urlString
  parameters:(NSMutableDictionary *)parameters
    progress:(void (^)(NSProgress *uploadProgress))progress
     success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
     failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;
- (void)put:(NSString *)urlString
 parameters:(NSMutableDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
    failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;
- (void)delete:(NSString *)urlString
parameters:(NSMutableDictionary *)parameters
success:(void (^)(NSURLSessionDataTask *dataTask, NSDictionary *responseObject))success
failure:(void (^)(NSURLSessionDataTask *dataTask, NSError *error))failure;

- (NSString *)urlEncodedStringFromDictionary:(NSDictionary *)parameterDictionary;



@end
