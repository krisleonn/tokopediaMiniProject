//
//  DataManager.m
//

#import "DataManager.h"
#import "APIManager.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "Base64.h"


@interface DataManager ()



@end

@implementation DataManager

#pragma mark - Lifecycle


#pragma mark - Custom Method
+ (void)logErrorStringFromError:(NSError *)error {
    NSString *dataString = [[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
#if DEBUG
    NSLog(@"Error Response: %@", dataString);
#endif
}



+ (BOOL)isResponseSuccess:(NSDictionary *)responseDictionary {
    NSDictionary *errorDictionary = [responseDictionary objectForKey:@"error"];
    
    if(errorDictionary == nil || [errorDictionary allKeys].count == 0) {
        return YES;
    }
    
    NSInteger errorCode = [[responseDictionary valueForKeyPath:@"error.code"] integerValue];
    
    if(errorCode == 299 || errorCode == 499) {
        
        return YES;
    }

    if([[NSString stringWithFormat:@"%li", (long)errorCode] hasPrefix:@"2"]) {
        return YES;
    }
 
    return NO;
}

+ (BOOL)isDataEmpty:(NSDictionary *)responseDictionary {
    NSDictionary *dataDictionary = [responseDictionary objectForKey:@"data"];
    
    if(dataDictionary == nil || [dataDictionary allKeys].count == 0) {
        return YES;
    }
    
    NSInteger errorCode = [[responseDictionary valueForKeyPath:@"error.code"] integerValue];
    
    if(errorCode == 204 || errorCode == 499) {
        //499 need to refresh token
        return YES;
    }
    
    return NO;
}



#pragma mark - API CalL

+ (void)callAPIGetSearchResultWithQuery:(QueryModel*)queryModel
                                success:(void (^)(NSArray *productArray))success
                                failure:(void (^)(NSError *error))failure{
    
    NSString *requestURL = [APIManager urlForType:APIManagerTypeSearch];
    
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:queryModel.queryString forKey:@"q"];
    [parameterDictionary setObject:queryModel.priceMin forKey:@"pmin"];
    [parameterDictionary setObject:queryModel.priceMax forKey:@"pmax"];
    [parameterDictionary setObject:queryModel.wholeSale forKey:@"wholesale"];
    [parameterDictionary setObject:queryModel.official forKey:@"official"];
    [parameterDictionary setObject:queryModel.fshop forKey:@"fshop"];
    [parameterDictionary setObject:queryModel.start forKey:@"start"];
    [parameterDictionary setObject:queryModel.rows forKey:@"rows"];
    
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"q=%@&",queryModel.queryString]];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"pmin=%@&",queryModel.priceMin]];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"pmax=%@&",queryModel.priceMax]];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"wholesale=%@&",queryModel.wholeSale]];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"official=%@&",queryModel.official]];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"fshop=%@&",queryModel.fshop]];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"start=%@&",queryModel.start]];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"rows=%@",queryModel.rows]];
    
    [[NetworkManager sharedManager]get:requestURL parameters:parameterDictionary progress:^(NSProgress *uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask *dataTask, NSDictionary *responseObject) {


        NSArray *productModelArray = [responseObject objectForKey:@"data"];
        NSMutableArray *productModelResultArray = [NSMutableArray array];
        
        for(NSDictionary *productModelDictionary in productModelArray) {
            ProductModel *productModel = [ProductModel new];
            productModel.nameString = [productModelDictionary objectForKey:@"name"];
            productModel.priceString = [productModelDictionary objectForKey:@"price"];
            productModel.imageURLString = [productModelDictionary objectForKey:@"image_uri"];
        
            [productModelResultArray addObject:productModel];
        }

        success(productModelResultArray);
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {

        NSError *localizedError = [NSError errorWithDomain:NSLocalizedString(@"We are experiencing problem to connect to our server, please try again later...", @"") code:999 userInfo:@{@"message": NSLocalizedString(@"Failed to connect to our server, please try again later...", @"")}];
        
        failure(localizedError);
    }];
    
}


    
-(NSDictionary *)nullToEmptyDictionary:(id)value {
        NSDictionary *emptyDictionary = [NSDictionary dictionary];
        
        if ([value isKindOfClass:[NSNull class]] || value == nil) return emptyDictionary;
        
        if ((NSNull *)value == [NSNull null]) {
            return emptyDictionary;
        }
        
        return (NSDictionary *)value;
}
-(NSString *)nullToEmptyString:(id)value {
    NSString *emptyString = @"";
    
    if ([value isKindOfClass:[NSNull class]] || value == nil) return emptyString;
    
    if ((NSNull *)value == [NSNull null]) {
        return emptyString;
    }
    
    return (NSString *)value;
}
@end
