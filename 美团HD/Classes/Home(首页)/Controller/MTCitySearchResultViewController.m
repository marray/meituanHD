//
//  MTCitySearchResultViewController.m
//  美团HD
//
//  Created by apple on 14/11/24.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTCitySearchResultViewController.h"
#import "MTConst.h"
#import "MTCity.h"
#import "MJExtension.h"

@interface MTCitySearchResultViewController ()
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation MTCitySearchResultViewController

- (NSArray *)cities
{
    if (!_cities) {
        self.cities = [MTCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    searchText = searchText.lowercaseString;
    
//    self.resultCities = [NSMutableArray array];
//    // 根据关键字搜索想要的城市数据
//    for (MTCity *city in self.cities) {
//        // 城市的name中包含了searchText
//        // 城市的pinYin中包含了searchText beijing
//        // 城市的pinYinHead中包含了searchText
//        if ([city.name containsString:searchText] || [city.pinYin containsString:searchText] || [city.pinYinHead containsString:searchText]) {
//            [self.resultCities addObject:city];
//        }
//    }
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
    self.resultCities = [self.cities filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    MTCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%d个搜索结果", self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTCity *city = self.resultCities[indexPath.row];
    // 发出通知
    [MTNotificationCenter postNotificationName:MTCityDidChangeNotification object:nil userInfo:@{MTSelectCityName : city.name}];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
