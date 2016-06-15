//
//  MTHttpTool.h
//  美团HD
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTHttpTool : NSObject
- (void)request:(NSString *)url pamras:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
