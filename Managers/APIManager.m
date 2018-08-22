//
//  APIManager.m
//  
//
//  Created by Ritchie Nathaniel on 8/13/15.
//  Copyright (c) 2015 Ritchie Nathaniel. All rights reserved.
//

#import "APIManager.h"

#import <Firebase/Firebase.h>
//https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=10000&pmax=100000&wholesale=true&official=true&fshop=2&start=0&rows=10

static NSString * const kAPIBaseURL = @"ace.tokopedia.com/search";
static NSString * const kAPIVersionString = @"v2.5";


@implementation APIManager

#pragma mark - Lifecycle
+ (APIManager *)sharedManager {
    static APIManager *sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[APIManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - Custom Method
+ (NSString *)urlForType:(APIManagerType)type {
    
    FIRRemoteConfig *remoteConfig = [FIRRemoteConfig remoteConfig];
    NSString *iOSUseHTTPS = [[remoteConfig configValueForKey:@"iOSUseHTTPS"] stringValue];
    BOOL useHTTPS = [iOSUseHTTPS boolValue];
    NSString *httpString = @"https://";
    if(!useHTTPS) {
       httpString = @"http://";
    }
    
    if(type == APIManagerTypeSearch) {
        NSString *apiPath = @"product?";
        return [NSString stringWithFormat:@"%@%@/%@/%@", httpString, kAPIBaseURL, kAPIVersionString, apiPath];
    }
   
    return [NSString stringWithFormat:@"%@%@", httpString, kAPIBaseURL];
}

@end
