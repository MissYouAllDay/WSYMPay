//
//  YMAllBillListDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillListDataModel.h"
#import "YMAllBillListDataListModel.h"

@implementation YMAllBillListDataModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"YMAllBillListDataListModel"};
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
