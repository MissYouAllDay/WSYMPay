//
//  YMHomeHttpRequestApi.h
//  WSYMPay
//
//  Created by pzj on 2017/8/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHTTPRequestTool.h"

@interface YMHomeHttpRequestApi : YMHTTPRequestTool

#pragma mark - 我要收款-两条数据
+ (void)loadParams:(RequestModel *)params HttpRequestWithCollectionSuccess:(void (^)(NSMutableArray *array))success;

@end
