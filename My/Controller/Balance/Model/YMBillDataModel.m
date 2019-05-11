//
//  YMBillDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBillDataModel.h"
#import "YMBillDetailsModel.h"

@implementation YMBillDataModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"YMBillDetailsModel"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (NSMutableArray *)getListArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (_list && _list.count>0) {
        array = _list;
    }
    return array;
}

@end
