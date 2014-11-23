//
//  MTHomeTopItem.m
//  美团HD
//
//  Created by apple on 14/11/23.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTHomeTopItem.h"

@implementation MTHomeTopItem

+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MTHomeTopItem" owner:nil options:nil] firstObject];
}
@end
