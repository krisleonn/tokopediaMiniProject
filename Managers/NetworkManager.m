//
//  NetworkManager.m
//  Moselo
//
//  Created by Ritchie Nathaniel on 3/9/17.
//  Copyright © 2017 Moselo. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPSessionManager.h"
#import "Base64.h"

#define API_SECRET @"moselo"
static const NSInteger kAPITimeOut = 300;

@interface NetworkManager ()

- (AFHTTPSessionManager *)defaultManager;
- (NSString *)urlEncodeForString:(NSString *)stringToEncode;

@end

@implementation NetworkManager

#pragma mark - Lifecycle
+ (NetworkManager *)sharedManager {
    static NetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if(self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"Connected via mobile network");
                    break;
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"Connected via Wifi");
                    break;
                    case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"Disconnected");
                    break;
                default:
                    break;
            }
        }];
    }
    
    return self;
}

#pragma mark - Custom Method
- (AFHTTPSessionManager *)defaultManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] identifierForVendor].UUIDString forHTTPHeaderField:@"device-identifier"];
    [manager.requestSerializer setValue:[[NSTimeZone localTimeZone] name] forHTTPHeaderField:@"timezone"];
    [manager.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"app-version"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"device-type"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"device-os-version"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] model] forHTTPHeaderField:@"device-model"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] name] forHTTPHeaderField:@"device-name"];
    [manager.requestSerializer setValue:API_SECRET forHTTPHeaderField:@"API_SECRET"];
    [manager.requestSerializer setTimeoutInterval:kAPITimeOut];
    
    return manager;
}

- (void)get:(NSString *)urlString
 parameters:(NSDictionary *)parameters
   progress:(void (^)(NSProgress *))progress
    success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
        
        NSString *errorMessage = NSLocalizedString(@"It appears you don't have internet connection, please try again later...", @"");
        NSError *error = [NSError errorWithDomain:errorMessage code:199 userInfo:@{@"message": errorMessage}];
        
        failure (nil, error);
    }
    
    [[self defaultManager] GET:urlString
                    parameters:parameters
                      progress:^(NSProgress * _Nonnull downloadProgress) {
                          progress(downloadProgress);
                      }
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(task, (NSDictionary *)responseObject);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           failure(task, error);
                       }];
}

- (void)post:(NSString *)urlString
  parameters:(NSDictionary *)parameters
    progress:(void (^)(NSProgress *))progress
     success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
        
        NSString *errorMessage = NSLocalizedString(@"It appears you don't have internet connection, please try again later...", @"");
        NSError *error = [NSError errorWithDomain:errorMessage code:199 userInfo:@{@"message": errorMessage}];
        
        failure (nil, error);
    }
    
    [[self defaultManager] POST:urlString
                     parameters:parameters
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                           progress(uploadProgress);
                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            //CS TEMP - Temporary Fix refresh token issue - force all error 299 to 499 if error code is 299 and response data Empty as the server still return empty data on certain API CAll
                            NSInteger errorCode = [[responseObject valueForKeyPath:@"error.code"] integerValue];
                            NSDictionary *dataDictionary = [responseObject objectForKey:@"data"];
                            if(errorCode == 299 && (dataDictionary == nil || [dataDictionary allKeys].count == 0)) {
                                NSMutableDictionary *mutableDict = [responseObject mutableCopy];
                                NSMutableDictionary *errorDict = [[responseObject objectForKey:@"error"] mutableCopy];
                                [errorDict setObject:@"499" forKey:@"code"];
                                [mutableDict setObject:errorDict forKey:@"error"];
                                responseObject = mutableDict;
                            }
                            
                            success(task, (NSDictionary *)responseObject);
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            failure(task, error);
                        }];
}

- (void)put:(NSString *)urlString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
    }
    
    [[self defaultManager] PUT:urlString
                    parameters:parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           success(task, (NSDictionary *)responseObject);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           failure(task, error);
                       }];
}

- (void)delete:(NSString *)urlString
    parameters:(NSDictionary *)parameters
       success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success
       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if(urlString == nil) {
        urlString = @"";
    }
    
    if(parameters == nil) {
        parameters = [NSDictionary dictionary];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {
        //No internet connection notification
        [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_MANAGER_NO_CONNECTION_NOTIFICATION_KEY object:nil];
    }
    
    [[self defaultManager] DELETE:urlString
                       parameters:parameters
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              success(task, (NSDictionary *)responseObject);
    }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              failure(task, error);
    }];
}

- (NSString *)urlEncodedStringFromDictionary:(NSDictionary *)parameterDictionary {
    NSMutableString *parameterString = [NSMutableString stringWithString:@""];
    
    NSArray *parameterKeyArray = [parameterDictionary allKeys];
    
    for(NSInteger count = 0; count < [parameterKeyArray count]; count++) {
        NSString *parameterKey = [parameterKeyArray objectAtIndex:count];
        
        if(count > 0) {
            [parameterString appendString:@"&"];
        }
        
        NSString *parameterValue = [parameterDictionary objectForKey:parameterKey];
        NSString *encodedParameterValue = [self urlEncodeForString:parameterValue];
        
        [parameterString appendFormat:@"%@=%@", parameterKey, encodedParameterValue];
    }
    
    return parameterString;
}

- (NSString *)urlEncodeForString:(NSString *)stringToEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[stringToEncode UTF8String];
    
    NSInteger sourceLen = strlen((const char *)source);
    
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    return output;
}



@end
