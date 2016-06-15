//
//  MTMetaTool.m
//  美团HD
//
//  Created by apple on 14/11/24.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTMetaTool.h"
#import "MTCity.h"
#import "MTCategory.h"
#import "MTSort.h"
#import "MJExtension.h"
#import "MTDeal.h"

@implementation MTMetaTool

static NSArray *_cities;
+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [MTCity objectArrayWithFilename:@"cities.plist"];;
    }
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [MTCategory objectArrayWithFilename:@"categories.plist"];;
    }
    return _categories;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [MTSort objectArrayWithFilename:@"sorts.plist"];;
    }
    return _sorts;
}


+ (MTCategory *)categoryWithDeal:(MTDeal *)deal
{
    NSArray *cs = [self categories];
    NSString *cname = [deal.categories firstObject];
    for (MTCategory *c in cs) {
        if ([cname isEqualToString:c.name]) return c;
        if ([c.subcategories containsObject:cname]) return c;
    }
    return nil;
}
@end
