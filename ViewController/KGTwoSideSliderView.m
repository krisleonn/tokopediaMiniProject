//
//  KGTwoSideSliderView.m
//  Moselo
//
//  Created by Kristian on 06/06/18.
//  Copyright © 2018 Moselo. All rights reserved.
//

#import "KGTwoSideSliderView.h"

@implementation KGTwoSideSliderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        
        _sliderBgView = [[UIView alloc]initWithFrame:frame];
        
        _leftLastTouchPoint = CGPointMake(0.0f, 0.0f);
        _leftFirstTouchPoint = CGPointMake(0.0f, 0.0f);
        _rightLastTouchPoint = CGPointMake(0.0f, 0.0f);
        _rightFirstTouchPoint = CGPointMake(0.0f, 0.0f);
        
        _leftPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleLeftButtonPanGesture:)];
        _rightPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleRightButtonPanGesture:)];
        
        _sliderLeftButtonView = [[UIView alloc] initWithFrame:CGRectMake(18.0f, 11.0f, 22.0f, 22.0f)];
        self.sliderLeftButtonView.backgroundColor = [UIColor greenColor];
        self.sliderLeftButtonView.layer.borderColor = [UIColor blackColor].CGColor;
        self.sliderLeftButtonView.layer.borderWidth = 1.0f;
        self.sliderLeftButtonView.layer.cornerRadius = 11.0f;
        
        _sliderRightButtonView = [[UIView alloc] initWithFrame:CGRectMake( CGRectGetWidth([UIScreen mainScreen].bounds)-40.0f, 11.0f, 22.0f, 22.0f)];
        self.sliderRightButtonView.backgroundColor = [UIColor greenColor];
        self.sliderRightButtonView.layer.borderColor = [UIColor blackColor].CGColor;
        self.sliderRightButtonView.layer.borderWidth = 1.0f;
        self.sliderRightButtonView.layer.cornerRadius = 11.0f;
        
        //40.0f = width bola (22.0f)+ jarak kiri kanan (18.0f)
        _greySliderview = [[UIView alloc] initWithFrame: CGRectMake(40.0f, 18.0f, CGRectGetWidth([UIScreen mainScreen].bounds)-80.0f, 5.0f)];
        self.greySliderview.backgroundColor = [UIColor grayColor];
        
        _sliderAdditionalView = [[UIView alloc] initWithFrame:CGRectMake(26.0f, 18.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 52.0f, 5.0f)];
        self.sliderAdditionalView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.sliderAdditionalView];
        
        _greyBackgroundSliderview = [[UIView alloc] initWithFrame: CGRectMake(18.0f, 18.0f, CGRectGetWidth([UIScreen mainScreen].bounds)-36.0f, 5.0f)];
        self.greySliderview.backgroundColor = [UIColor grayColor];
        
        
        _greenSliderview = [[UIView alloc] initWithFrame: CGRectMake(40.0f, 18.0f, CGRectGetWidth([UIScreen mainScreen].bounds)-80.0f, 5.0f)];
        self.greenSliderview.backgroundColor = [UIColor greenColor];
        
        [self.sliderRightButtonView addGestureRecognizer:self.rightPanGestureRecognizer];
        [self.sliderLeftButtonView addGestureRecognizer:self.leftPanGestureRecognizer];
        
        [self addSubview:self.greySliderview];
        [self addSubview:self.greyBackgroundSliderview];
        [self addSubview:self.greenSliderview];
        [self addSubview:self.sliderLeftButtonView];
        [self addSubview:self.sliderRightButtonView];

        
    }
    return self;
}

-(void)handleLeftButtonPanGesture:(UIPanGestureRecognizer *)panGestureHandler{
    CGPoint touchPoint = [panGestureHandler locationInView:self];
    NSInteger gapX = 0;
    
    
    if(panGestureHandler.state == UIGestureRecognizerStateBegan){
        self.leftFirstTouchPoint = touchPoint;
    }
    else if (panGestureHandler.state == UIGestureRecognizerStateChanged){
        
        gapX = touchPoint.x - self.leftLastTouchPoint.x;
        [UIView animateWithDuration:0.2f animations:^{
            CGFloat newX = CGRectGetMinX(self.sliderLeftButtonView.frame) + gapX;
            if(newX < 18.0f){
                newX = 18.0f;
            }
            if(newX + 22.0f > CGRectGetMinX(self.sliderRightButtonView.frame)){
                newX = CGRectGetMinX(self.sliderRightButtonView.frame) - 22.0f;
                
            }
            NSLog(@"%lf",newX);
            self.sliderLeftButtonView.frame = CGRectMake( newX,11.0f, 22.0f, 22.0f);
            self.greenSliderview.frame = CGRectMake(CGRectGetMaxX(self.sliderLeftButtonView.frame), 18.0f,CGRectGetMinX(self.sliderRightButtonView.frame)-CGRectGetMaxX(self.sliderLeftButtonView.frame), 5.0f);
        }];
        
        CGFloat newStartPrice = ( CGRectGetMinX(self.greenSliderview.frame) - CGRectGetMinX(self.greySliderview.frame));
        newStartPrice = newStartPrice/(CGRectGetWidth(self.greySliderview.frame)/self.divider);
        newStartPrice = newStartPrice*self.priceIncrement;
        NSInteger roundedStartPrice = newStartPrice / self.priceIncrement;
        roundedStartPrice = roundedStartPrice * self.priceIncrement;
        
        if(newStartPrice == 0.0f){
            self.finalStartPrice = self.startPrice;
        }
        else {
            self.finalStartPrice = (CGFloat)newStartPrice;
        }
        
        
        if([self.delegate respondsToSelector:@selector(KGTwoSideSliderViewendDragingLeftFilterPriceRange:)]){
            [self.delegate KGTwoSideSliderViewendDragingLeftFilterPriceRange:self.finalStartPrice];
        }

    }
    else if (panGestureHandler.state == UIGestureRecognizerStateEnded){
        
        
        [UIView animateWithDuration:0.2f animations:^{

            if(CGRectGetMaxX(self.sliderLeftButtonView.frame) > CGRectGetMinX(self.sliderRightButtonView.frame) ){
                NSLog(@"LEWAT");
                self.sliderLeftButtonView.frame = CGRectMake(CGRectGetMinX(self.sliderRightButtonView.frame)- 22.0f ,11.0f, 22.0f, 22.0f);
                self.greenSliderview.frame = CGRectMake(CGRectGetMaxX(self.sliderLeftButtonView.frame), 18.0f,CGRectGetMinX(self.sliderRightButtonView.frame)-CGRectGetMaxX(self.sliderLeftButtonView.frame), 5.0f);
                
                CGFloat newStartPrice = ( CGRectGetMinX(self.greenSliderview.frame) - CGRectGetMinX(self.greySliderview.frame));
                newStartPrice = newStartPrice/(CGRectGetWidth(self.greySliderview.frame)/self.divider);
                newStartPrice = newStartPrice*self.priceIncrement;
                NSInteger roundedStartPrice = newStartPrice / self.priceIncrement;
                roundedStartPrice = roundedStartPrice * self.priceIncrement;
                self.finalStartPrice = (CGFloat)newStartPrice;
                if([self.delegate respondsToSelector:@selector(KGTwoSideSliderViewendDragingLeftFilterPriceRange:)]){
                    [self.delegate KGTwoSideSliderViewendDragingLeftFilterPriceRange:self.finalStartPrice];
                }
            }
        } completion:^(BOOL finished) {
         
            
        }];
        
    }
    self.leftLastTouchPoint = touchPoint;
}
-(void)handleRightButtonPanGesture:(UIPanGestureRecognizer *)panGestureHandler{
    CGPoint touchPoint = [panGestureHandler locationInView:self];
    NSInteger gapX = 0;
    
    
    if(panGestureHandler.state == UIGestureRecognizerStateBegan){
        self.rightFirstTouchPoint = touchPoint;
        
    }
    else if (panGestureHandler.state == UIGestureRecognizerStateChanged){
        
        gapX = touchPoint.x - self.rightLastTouchPoint.x;
        [UIView animateWithDuration:0.2f animations:^{
            CGFloat newX = CGRectGetMinX(self.sliderRightButtonView.frame) + gapX;
            if(newX >  CGRectGetWidth([UIScreen mainScreen].bounds)-40.0f){
                newX = CGRectGetWidth([UIScreen mainScreen].bounds)-40.0f;
            }
            if(CGRectGetMaxX(self.sliderLeftButtonView.frame) > newX ){
                newX = CGRectGetMaxX(self.sliderLeftButtonView.frame) ;
                
            }
            
            NSLog(@"%lf",newX);
            self.sliderRightButtonView.frame = CGRectMake( newX,11.0f, 22.0f, 22.0f);
            self.greenSliderview.frame = CGRectMake(CGRectGetMaxX(self.sliderLeftButtonView.frame), 18.0f,CGRectGetMinX(self.sliderRightButtonView.frame)-CGRectGetMaxX(self.sliderLeftButtonView.frame), 5.0f);
        }];
        
        CGFloat newEndPrice = ( CGRectGetMaxX(self.greySliderview.frame) - CGRectGetMaxX(self.greenSliderview.frame));
        newEndPrice = newEndPrice/(CGRectGetWidth(self.greySliderview.frame)/self.divider);
        newEndPrice = self.endPrice - (newEndPrice*self.priceIncrement);
        
        NSInteger roundedEndPrice = newEndPrice / self.priceIncrement;
        roundedEndPrice = roundedEndPrice * self.priceIncrement;
        
        self.finalEndPrice = (CGFloat)newEndPrice;
        if([self.delegate respondsToSelector:@selector(KGTwoSideSliderViewendDragingRightFilterPriceRange:)]){
            [self.delegate KGTwoSideSliderViewendDragingRightFilterPriceRange:self.finalEndPrice];
        }
        
    }
    else if (panGestureHandler.state == UIGestureRecognizerStateEnded){

        
        [UIView animateWithDuration:0.2f animations:^{

            if(CGRectGetMaxX(self.sliderLeftButtonView.frame) > CGRectGetMinX(self.sliderRightButtonView.frame) ){
                NSLog(@"LEWAT");
                self.sliderRightButtonView.frame = CGRectMake( CGRectGetMaxX(self.sliderLeftButtonView.frame) + 1.0f,11.0f, 22.0f, 22.0f);
                self.greenSliderview.frame = CGRectMake(CGRectGetMaxX(self.sliderLeftButtonView.frame), 18.0f,CGRectGetMinX(self.sliderRightButtonView.frame)-CGRectGetMaxX(self.sliderLeftButtonView.frame), 5.0f);
                CGFloat newEndPrice = ( CGRectGetMaxX(self.greySliderview.frame) - CGRectGetMaxX(self.greenSliderview.frame));
                newEndPrice = newEndPrice/(CGRectGetWidth(self.greySliderview.frame)/self.divider);
                newEndPrice = self.endPrice - (newEndPrice*self.priceIncrement);
                
                NSInteger roundedEndPrice = newEndPrice / self.priceIncrement;
                roundedEndPrice = roundedEndPrice * self.priceIncrement;
                
                self.finalEndPrice = (CGFloat)newEndPrice;
                if([self.delegate respondsToSelector:@selector(KGTwoSideSliderViewendDragingRightFilterPriceRange:)]){
                    [self.delegate KGTwoSideSliderViewendDragingRightFilterPriceRange:self.finalEndPrice];
                }
            }
        } completion:^(BOOL finished) {

        }];
        
    }
    self.rightLastTouchPoint = touchPoint;
    
}

- (void)setCountNumberWithStartPrice:(CGFloat)startPrice endPrice:(CGFloat)endPrice priceIncrement:(NSInteger)priceIncrement currentStartPrice:(CGFloat)currentStartPrice currentEndPrice:(CGFloat)currentEndPrice {
    self.startPrice = startPrice;
    self.endPrice = endPrice;
    self.divider = (endPrice - startPrice)/priceIncrement;
    _finalStartPrice = currentStartPrice;
    _finalEndPrice = currentEndPrice;
    
    self.priceIncrement = priceIncrement;
    
    CGFloat rightGap =(CGRectGetWidth(self.greySliderview.frame)/self.priceIncrement) * ((endPrice - currentEndPrice)/self.divider);
    CGFloat leftGap =(CGRectGetWidth(self.greySliderview.frame)/self.priceIncrement) * ((currentStartPrice - startPrice)/self.divider);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.sliderRightButtonView.frame = CGRectMake( CGRectGetWidth([UIScreen mainScreen].bounds) - 40.0f - rightGap,11.0f, 22.0f, 22.0f);
        self.sliderLeftButtonView.frame = CGRectMake( 18.0f + leftGap,11.0f, 22.0f, 22.0f);
        self.greenSliderview.frame = CGRectMake(CGRectGetMaxX(self.sliderLeftButtonView.frame), 18.0f,CGRectGetMinX(self.sliderRightButtonView.frame)-CGRectGetMaxX(self.sliderLeftButtonView.frame), 5.0f);
    }];
}

@end
