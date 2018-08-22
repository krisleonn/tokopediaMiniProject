//
//  SearchCollectionViewCell.m
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 20/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.text = @"";
    self.priceLabel.text = @"";
    
}

- (void)setDataWithProductModel:(ProductModel*)productModel{
    self.nameLabel.text = productModel.nameString;
    self.priceLabel.text = productModel.priceString;
    
}
@end
