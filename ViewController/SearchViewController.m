//
//  SearchViewController.m
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 20/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"
#import "FilterViewController.h"
#import "DataManager.h"
#import "QueryModel.h"
@interface SearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) QueryModel *queryModel;
@property (strong, nonatomic) NSMutableArray *productArray;
@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) NSInteger paging;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _queryModel = [QueryModel new];
    self.queryModel.queryString = @"samsung";
    self.queryModel.priceMin = @"10000";
    self.queryModel.priceMax = @"100000";
    self.queryModel.wholeSale = @"true";
    self.queryModel.official = @"true";
    self.queryModel.fshop = @"2";
    self.queryModel.start = @"0";
    self.queryModel.rows = @"10";
    _isFirstTime = YES;
    _paging = 0;
    _productArray = [NSMutableArray array];
    [self populateArrayWithLastPage];
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
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2 , 220.0f);
    
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
    return [self.productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SearchCollectionViewCell";
    //Register identifier for class (must use for avoid assertion failure)
    [collectionView registerClass:[SearchCollectionViewCell class]
       forCellWithReuseIdentifier:cellIdentifier];
    UINib *cellNib = [UINib nibWithNibName:[SearchCollectionViewCell description] bundle:nil];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    SearchCollectionViewCell *cell = (SearchCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setDataWithProductModel:[self.productArray objectAtIndex:indexPath.row]];
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
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.productArray count] - 8 && [self.productArray count] - 8 > 0){
        [self populateArrayWithLastPage];
        
    }
    
}

-(IBAction)filterButtonDidTapped:(id)sender{
    
    FilterViewController *filterViewController = [[FilterViewController alloc]init];
    [self presentViewController:filterViewController animated:YES completion:nil];
}

-(void)populateArrayWithLastPage{
    if(self.isFirstTime){
        [DataManager callAPIGetSearchResultWithQuery:self.queryModel success:^(NSArray *productArray) {
            self.productArray = [productArray mutableCopy];
            [self.collectionView reloadData];
            self.paging += 1;
            self.queryModel.start = [NSString stringWithFormat:@"%ld", self.paging];
            self.isFirstTime = NO;
        } failure:^(NSError *error) {
            
        }];
    }
    else {
        [DataManager callAPIGetSearchResultWithQuery:self.queryModel success:^(NSArray *productArray) {
            [self.productArray addObject:productArray];
            [self.collectionView reloadData];
            self.paging += 1;
            self.queryModel.start = [NSString stringWithFormat:@"%ld", self.paging];
        } failure:^(NSError *error) {
            
        }];
        
    }


}
@end
