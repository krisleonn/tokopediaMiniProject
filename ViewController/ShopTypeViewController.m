//
//  ShopTypeViewController.m
//  TokopediaMiniProjectTest
//
//  Created by Kristian on 20/08/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import "ShopTypeViewController.h"
#import "ShopTypeTableViewCell.h"
@interface ShopTypeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *filterArray;
@property (strong, nonatomic) NSMutableArray *selectedFilterArray;
@end

@implementation ShopTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _filterArray = [NSArray arrayWithObjects:@"Gold Merchant", @"OFficial Shop", nil];
    _selectedFilterArray = [NSMutableArray array];
    [self.selectedFilterArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.selectedFilterArray addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source
#pragma mark UITableViewCell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView registerNib:[UINib nibWithNibName:[ShopTypeTableViewCell description] bundle:nil]forCellReuseIdentifier:[ShopTypeTableViewCell description]];
    ShopTypeTableViewCell *cell = (ShopTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ShopTypeTableViewCell description]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return FLT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(IBAction)closeDidTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction)resetDidTapped:(id)sender{
    
}

@end
