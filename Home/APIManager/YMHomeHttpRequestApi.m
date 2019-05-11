//
//  YMHomeHttpRequestApi.m
//  WSYMPay
//
//  Created by pzj on 2017/8/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHomeHttpRequestApi.h"
#import "RequestModel.h"
#import "YMCollectionBaseListModel.h"

@implementation YMHomeHttpRequestApi

#pragma mark - 收款记录
+ (void)loadParams:(RequestModel *)params HttpRequestWithCollectionSuccess:(void (^)(NSMutableArray *array))success
{
    [MBProgressHUD show];
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict.allKeys containsObject:@"data"]) {
                NSDictionary *dataDict = dict[@"data"];
                
                if ([dataDict.allKeys containsObject:@"list"]) {
                    NSArray *listArray = dataDict[@"list"];
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    array = [YMCollectionBaseListModel mj_objectArrayWithKeyValuesArray:listArray];
                    YMLog(@"array = %@",array);
                    if (success) {
                        success(array);
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}
@end
