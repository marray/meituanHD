//
//  MTHttpTool.m
//  美团HD
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "MTHttpTool.h"
#import "DPAPI.h"

@interface MTHttpTool() <DPRequestDelegate>

@end

@implementation MTHttpTool
static DPAPI *_api;
+ (void)initialize
{
    _api = [[DPAPI alloc] init];
}

- (void)request:(NSString *)url pamras:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    DPRequest *request = [_api requestWithURL:url params:params delegate:self];
    request.success = success;
    request.failure = failure;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.success) {
        request.success(result);
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request.failure) {
        request.failure(error);
    }
}
@end
