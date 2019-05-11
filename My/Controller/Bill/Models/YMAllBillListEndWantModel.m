//
//  YMAllBillListEndWantModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillListEndWantModel.h"
#import "YMAllBillListDataListModel.h"

@implementation YMAllBillListEndWantModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

/**
 * 账单列表每个分区 header --- date
 */
- (NSString *)getDateString
{
    NSString *str = @"";
    if (_dateString != nil) {
        if (![_dateString isEmptyStr]) {
            str = _dateString;
        }
    }
    return str;
}

/**
 * 账单列表每个时间段分区 array
 */
- (NSMutableArray *)getListArray
{
    if (self.listArray && self.listArray.count>0) {
        return self.listArray;
    }
    return nil;
}
/**
 * 账单列表每个时间段分区 array.count
 */
- (NSInteger)getListArrayCount
{
    NSInteger count = 0;
    if (self.getListArray != nil && self.getListArray.count>0) {
        count = self.getListArray.count;
    }
    return count;
}
/**
 * 账单细表 总的array(便利成自己想要的array数据源)
 */
+ (NSMutableArray *)getDataArray:(NSMutableArray *)dataArray
{
    //最终希望的array:
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger arrayCount = dataArray.count;

    if (arrayCount>0) {
        for (int i = 0; i<arrayCount; i++) {
            YMAllBillListDataListModel *model = dataArray[i];
            model.dateString = [model getDateString];
            
            YMAllBillListEndWantModel *m = [array lastObject];
            if (m && [m.dateString isEqualToString:model.dateString]) {
                [m.listArray addObject:model];
            }else{//创建
                YMAllBillListEndWantModel *listArrayModel = [[YMAllBillListEndWantModel alloc] init];
                listArrayModel.dateString = model.dateString;
                listArrayModel.listArray = [[NSMutableArray alloc] init];
                [listArrayModel.listArray addObject:model];
                [array addObject:listArrayModel];
            }
        }
    }
    return array;
}
@end
