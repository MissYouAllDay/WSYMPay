//
//  YMTransferRecentRecodeDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferRecentRecodeDataModel.h"
#import "YMTransferRecentRecodeDataListModel.h"

@implementation YMTransferRecentRecodeDataModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"YMTransferRecentRecodeDataListModel"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
/**
 * 转账记录列表
 */
- (NSMutableArray *)getListArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([self getListArrayCount]>0) {
        array = _list;
    }
    return array;
}

- (NSInteger)getListArrayCount
{
    return _list.count;
}
@end
