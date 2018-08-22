//
//  DataManager.h


#import <Foundation/Foundation.h>
#import "ProductModel.h"
#import "QueryModel.h"
@interface DataManager : NSObject

+ (void)callAPIGetSearchResultWithQuery:(QueryModel*)queryModel
                                success:(void (^)(NSArray *productArray))success
                                failure:(void (^)(NSError *error))failure;

+ (void)callAPIOrderCardDone:(NSString *)orderID
                  proofPhoto:(NSString *)proofPhoto
                    success:(void (^)(NSString *successCode, NSString *message))success
                    failure:(void (^)(NSError *error))failure;


@end
