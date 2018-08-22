//
//  FilterCollectionViewCell.h
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 22/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *closeView;
@property (strong, nonatomic) IBOutlet UILabel *filterLabel;
-(void)setLabelWithString:(NSString*)filterString;
@end
