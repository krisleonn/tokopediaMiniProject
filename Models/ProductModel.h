//
//  ProductModel.h
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 22/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject
    @property (strong, nonatomic) NSString *productIDString;
    @property (strong, nonatomic) NSString *imageURLString;
    @property (strong, nonatomic) NSString *nameString;
    @property (strong, nonatomic) NSString *priceString;
@end
