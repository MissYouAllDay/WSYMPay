//
//  YMBillDetailsListModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/16.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBillDetailsListModel.h"
#import "YMBillDetailsModel.h"

@implementation YMBillDetailsListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (NSString *)getDateString
{
    NSString *str = @"";
    if (![_dateString isEmptyStr]) {
        str = _dateString;
    }
    return str;
}

- (NSMutableArray *)getListArray
{
    if (self.listArray && self.listArray.count>0) {
        return self.listArray;
    }
    return nil;
}

- (NSInteger)getListArrayCount
{
    NSInteger count = 0;
    if (self.getListArray != nil && self.getListArray.count>0) {
        count = self.getListArray.count;
    }
    return count;
}

+ (NSMutableArray *)getDataArray:(NSMutableArray *)dataArray
{
    //最终希望的array:
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger arrayCount = dataArray.count;
    if (arrayCount>0) {
        for (int i = 0; i < arrayCount; i++) {
            YMBillDetailsModel *model = dataArray[i];
            NSString *dateStr = model.orderDate;
            NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
            NSString *dateString = dateArr[0];
            model.dateString = dateString;
            
            YMBillDetailsListModel *m = [array lastObject];
            if (m && [m.dateString isEqualToString:model.dateString]) {
                [m.listArray addObject:model];
            }else{//创建
                YMBillDetailsListModel *listArrayModel = [[YMBillDetailsListModel alloc] init];
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
