//
//  QueryModel.h
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 22/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryModel : NSObject
    @property (strong, nonatomic) NSString *queryString;
    @property (strong, nonatomic) NSString *priceMin;
    @property (strong, nonatomic) NSString *priceMax;
    @property (strong, nonatomic) NSString *wholeSale;

    @property (strong, nonatomic) NSString *official;
    @property (strong, nonatomic) NSString *fshop;
    @property (strong, nonatomic) NSString *start;
    @property (strong, nonatomic) NSString *rows;

@end
