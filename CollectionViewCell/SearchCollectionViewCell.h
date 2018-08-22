//
//  SearchCollectionViewCell.h
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 20/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface SearchCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
    - (void)setDataWithProductModel:(ProductModel*)productModel;
@end
