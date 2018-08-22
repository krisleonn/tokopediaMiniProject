//
//  FilterCollectionViewCell.m
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 22/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import "FilterCollectionViewCell.h"

@implementation FilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 25.0f;
    self.closeView.layer.cornerRadius = 25.0f;
}

-(void)setLabelWithString:(NSString*)filterString{
    self.filterLabel.text = filterString;
    
}

@end
