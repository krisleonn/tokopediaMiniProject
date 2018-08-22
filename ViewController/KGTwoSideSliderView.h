//
//  KGTwoSideSliderView.h
//  Moselo
//
//  Created by Kristian on 06/06/18.
//  Copyright © 2018 Moselo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KGTwoSideSliderViewDelegate <NSObject>

- (void)KGTwoSideSliderViewendDragingLeftFilterPriceRange:(CGFloat)startPrice;
- (void)KGTwoSideSliderViewendDragingRightFilterPriceRange:(CGFloat)endPrice;

@end
@interface KGTwoSideSliderView : UIView

@property (weak, nonatomic) id<KGTwoSideSliderViewDelegate> delegate;

@property (strong, nonatomic) UIView *sliderBgView;
@property (strong, nonatomic) UIView *sliderAdditionalView;
@property (strong, nonatomic) UIPanGestureRecognizer *leftPanGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *rightPanGestureRecognizer;

@property (strong, nonatomic) UIView *sliderLeftButtonView;
@property (strong, nonatomic) UIView *sliderRightButtonView;

@property (strong, nonatomic) UIView *greySliderview;
@property (strong, nonatomic) UIView *greyBackgroundSliderview;
@property (strong, nonatomic) UIView *greenSliderview;

@property (nonatomic) CGPoint leftLastTouchPoint;
@property (nonatomic) CGPoint leftFirstTouchPoint;
@property (nonatomic) CGPoint rightLastTouchPoint;
@property (nonatomic) CGPoint rightFirstTouchPoint;

@property (nonatomic) CGFloat startPrice;
@property (nonatomic) CGFloat endPrice;

@property (nonatomic) NSInteger divider;

@property (nonatomic) CGFloat priceIncrement;
@property (nonatomic) CGFloat widthScale;
@property (nonatomic) CGFloat finalEndPrice;
@property (nonatomic) CGFloat finalStartPrice;

- (void)setCountNumberWithStartPrice:(CGFloat)startPrice endPrice:(CGFloat)endPrice priceIncrement:(NSInteger)priceIncrement currentStartPrice:(CGFloat)currentStartPrice currentEndPrice:(CGFloat)currentEndPrice;
@end
