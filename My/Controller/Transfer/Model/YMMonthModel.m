//
//  YMMonthModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMMonthModel.h"
#import "YMTransferDetailsModel.h"
@implementation YMMonthModel
+(NSArray *)getHaveMonthTitleArray:(NSArray *)array
{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat       = @"yyyy-MM-dd HH:mm:ss";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit  = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDate *currentDate  = [NSDate date];
    NSDateComponents *currentCmps   = [calendar components:unit fromDate:currentDate];
    YMMonthModel *currentMonth = [[YMMonthModel alloc]init];
    currentMonth.billList      = [NSMutableArray array];
    currentMonth.month         = @"本月";
    NSMutableArray *array1     = [NSMutableArray array];
    for (YMTransferDetailsModel *m in array) {
        NSDate *date           = [fmt dateFromString:m.tratime];
        NSDateComponents *cmps = [calendar components:unit fromDate:date];
        if (currentCmps.year == cmps.year) {
            if (currentCmps.month == cmps.month) {
                [currentMonth.billList addObject:m];
                
            } else {
                
               __block  BOOL isHave = NO;
                [array1 enumerateObjectsUsingBlock:^(YMMonthModel *currentMonthArray, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([currentMonthArray.month integerValue] == cmps.month) {
                        [currentMonthArray.billList addObject:m];
                        *stop = YES;
                        isHave = YES;
                    }
                }];
                
                if (!isHave) {
                    YMMonthModel *otherArray = [[YMMonthModel alloc]init];
                    otherArray.month         = [NSString stringWithFormat:@"%ld月",(long)cmps.month];
                    otherArray.billList      = [NSMutableArray array];
                    [otherArray.billList addObject:m];
                    [array1 addObject:otherArray];
                }
                
            }
        } else {
            
           __block BOOL isHave = NO;
             NSString *month = [NSString stringWithFormat:@"%ld年%ld月",(long)cmps.year,(long)cmps.month];
            [array1 enumerateObjectsUsingBlock:^(YMMonthModel *currentMonthArray, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([currentMonthArray.month isString:month]) {
                    [currentMonthArray.billList addObject:m];
                    *stop = YES;
                    isHave = YES;
                }
            }];
            
            if (!isHave) {
                YMMonthModel *otherArray = [[YMMonthModel alloc]init];
                otherArray.month = month;
                otherArray.billList = [NSMutableArray array];
                [otherArray.billList addObject:m];
                [array1 addObject:otherArray];
            }
            
        }
    }
    

    if (currentMonth.billList.count) {
        [array1 insertObject:currentMonth atIndex:0];
    }
    return array1;
}
@end
