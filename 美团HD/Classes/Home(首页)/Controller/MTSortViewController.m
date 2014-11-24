//
//  MTSortViewController.m
//  美团HD
//
//  Created by apple on 14/11/24.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTSortViewController.h"
#import "MTMetaTool.h"
#import "MTSort.h"
#import "UIView+Extension.h"
#import "MTConst.h"

@interface MTSortViewController ()

@end

@implementation MTSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [MTMetaTool sorts];
    NSUInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0; i<count; i++) {
        MTSort *sort = sorts[i];
        
        UIButton *button = [[UIButton alloc] init];
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY + i * (btnH + btnMargin);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitle:sort.label forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    
    // 设置控制器在popover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}

- (void)buttonClick:(UIButton *)button
{
    [MTNotificationCenter postNotificationName:MTSortDidChangeNotification object:nil userInfo:@{MTSelectSort : [MTMetaTool sorts][button.tag]}];
}

@end
