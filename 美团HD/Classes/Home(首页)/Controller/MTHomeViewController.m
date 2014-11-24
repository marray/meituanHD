//
//  MTHomeViewController.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTConst.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "MTHomeTopItem.h"
#import "MTCategoryViewController.h"
#import "MTDistrictViewController.h"

@interface MTHomeViewController ()
/** 分类item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** 地区item */
@property (nonatomic, weak) UIBarButtonItem *districtItem;
/** 排序item */
@property (nonatomic, weak) UIBarButtonItem *sortItem;
@end

@implementation MTHomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.view == self.tableView
    // self.view == self.collectionView.superview
    // 设置背景色
    self.collectionView.backgroundColor = MTGlobalBg;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 监听城市改变
    [MTNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:MTCityDidChangeNotification object:nil];
    
    // 设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
}

- (void)dealloc
{
    [MTNotificationCenter removeObserver:self];
}

#pragma mark - 监听通知
- (void)cityDidChange:(NSNotification *)notification
{
    NSString *cityName = notification.userInfo[MTSelectCityName];
    
    // 1.更换顶部区域item的文字
    MTHomeTopItem *topItem = (MTHomeTopItem *)self.districtItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部", cityName]];
    [topItem setSubtitle:nil];
    
    // 2.刷新表格数据
#warning TODO
    
}

#pragma mark - 设置导航栏内容
- (void)setupLeftNav
{
    // 1.LOGO
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    // 2.类别
    MTHomeTopItem *categoryTopItem = [MTHomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    
    // 3.地区
    MTHomeTopItem *districtTopItem = [MTHomeTopItem item];
    [districtTopItem addTarget:self action:@selector(districtClick)];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    self.districtItem = districtItem;
    
    // 4.排序
    MTHomeTopItem *sortTopItem = [MTHomeTopItem item];
    [sortTopItem addTarget:self action:@selector(sortClick)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
}

- (void)setupRightNav
{
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - 顶部item点击方法
- (void)categoryClick
{
    // 显示分类菜单
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[MTCategoryViewController alloc] init]];
    [popover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)districtClick
{
    // 显示区域菜单
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[MTDistrictViewController alloc] init]];
    [popover presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)sortClick
{
    MTLog(@"sortClick");
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
