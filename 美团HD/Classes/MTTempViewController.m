//
//  MTTempViewController.m
//  美团HD
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTTempViewController.h"
//#import "DPAPI.h"
#import "MTHttpTool.h"

@interface MTTempViewController ()
//<DPRequestDelegate>
//@property (nonatomic, strong) DPRequest *request1;
//@property (nonatomic, strong) DPRequest *request2;
//@property (nonatomic, strong) DPRequest *request3;
//@property (nonatomic, strong) DPRequest *request4;
//@property (nonatomic, strong) DPRequest *request5;
@end

@implementation MTTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DPAPI *api = [[DPAPI alloc] init];
//    
//    self.request1 = [api requestWithURL:@"/v1/home.json" params:@{} delegate:self];
//    self.request2 = [api requestWithURL:@"/v1/message.json" params:@{} delegate:self];
//    self.request3 = [api requestWithURL:@"/v1/mime.json" params:@{} delegate:self];
//    self.request4 = [api requestWithURL:@"/v1/test.json" params:@{} delegate:self];
//    self.request5 = [api requestWithURL:@"/v1/test.json" params:@{} delegate:self];
    
    MTHttpTool *tool = [[MTHttpTool alloc] init];
    [tool request:@"/v1/home.json" pamras:nil success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    [tool request:@"/v1/mime.json" pamras:nil success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
    [tool request:@"/v1/message.json" pamras:nil success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
