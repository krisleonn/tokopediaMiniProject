//
//  FilterViewController.m
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 20/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import "FilterViewController.h"
#import "ShopTypeViewController.h"
#import "KGTwoSideSliderView.h"
#import "FilterCollectionViewCell.h"
#import "ShopTypeViewController.h"
@interface FilterViewController () <KGTwoSideSliderViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) KGTwoSideSliderView *kgSliderView;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) NSMutableArray *filterArray;
@property (nonatomic) CGFloat currentStartPrice;
@property (nonatomic) CGFloat currentEndPrice;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _kgSliderView = [[KGTwoSideSliderView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 54.0f)];
    [self.kgSliderView setCountNumberWithStartPrice:100.0f endPrice:8000000.0f priceIncrement:1 currentStartPrice:100.0f currentEndPrice:8000000.0f];
    self.kgSliderView.delegate = self;
    [self.sliderView addSubview:self.kgSliderView];
    _filterArray = [NSMutableArray array];
    
    [self.filterArray addObject:@"Gold Merchant"];
    [self.filterArray addObject:@"Official Store"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView
#pragma mark Data Source
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont fontWithName:@"Arial Italic" size:13];
    CGSize stringSize = [[self.filterArray objectAtIndex:indexPath.row] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];

    CGFloat width = stringSize.width;
    
    return CGSizeMake(width + 66.0f , 50.0f);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.filterArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FilterCollectionViewCell";
    //Register identifier for class (must use for avoid assertion failure)
    [collectionView registerClass:[FilterCollectionViewCell class]
       forCellWithReuseIdentifier:cellIdentifier];
    UINib *cellNib = [UINib nibWithNibName:[FilterCollectionViewCell description] bundle:nil];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    FilterCollectionViewCell *cell = (FilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell setLabelWithString:[self.filterArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self.filterArray removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}
#pragma mark - KG Slider Delegate
-(void)KGTwoSideSliderViewendDragingLeftFilterPriceRange:(CGFloat)startPrice{
    self.startLabel.text = [NSString stringWithFormat:@"Rp %.0lf",startPrice];
    self.currentStartPrice = startPrice;
}

-(void)KGTwoSideSliderViewendDragingRightFilterPriceRange:(CGFloat)endPrice{
    self.endLabel.text = [NSString stringWithFormat:@"Rp %.0lf",endPrice];
    self.currentEndPrice = endPrice;
}
#pragma mark - Custom Method
-(IBAction)closeDidTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction)filterDidTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction)resetDidTapped:(id)sender{
    
    [self.kgSliderView setCountNumberWithStartPrice:100.0f endPrice:8000000.0f priceIncrement:1 currentStartPrice:100.0f currentEndPrice:8000000.0f];
    [self.filterArray removeAllObjects];
    [self.filterArray addObject:@"Gold Merchant"];
    [self.filterArray addObject:@"Official Store"];
    [self.collectionView reloadData];
    self.currentStartPrice = 100.0f;
    self.currentEndPrice = 8000000.0f;
    self.startLabel.text = @"Rp 100";
    self.endLabel.text = @"Rp 8000000";
    
}

-(IBAction)filterTypeDidTapped:(id)sender{
    
    ShopTypeViewController *shopTypeViewController = [[ShopTypeViewController alloc]init];
    [self presentViewController:shopTypeViewController animated:YES completion:nil];
}



@end
