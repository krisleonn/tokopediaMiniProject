//
//  APIManager.h
//
//
//  Created by Ritchie Nathaniel on 8/13/15.
//  Copyright (c) 2015 Ritchie Nathaniel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, APIManagerType) {
    APIManagerTypeSearch,
  
};

@interface APIManager : NSObject

+ (APIManager *)sharedManager;
+ (NSString *)urlForType:(APIManagerType)type;

@end
