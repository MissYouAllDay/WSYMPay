//
//  YMBillBaseModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/15.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBillBaseModel.h"

@implementation YMBillBaseModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"data":@"YMBillDataModel"};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

//得到总条数
- (NSInteger)getAllCountNum
{
    NSInteger count;
    count = _countNum;
    return count;
}

@end
