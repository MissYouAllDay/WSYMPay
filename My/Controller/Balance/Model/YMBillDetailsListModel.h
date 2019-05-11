//
//  YMBillDetailsListModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/16.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 收支明细列表 ---- 最终想要的 model
 * 新修改的model
 */
#import <Foundation/Foundation.h>

@interface YMBillDetailsListModel : NSObject
//header
@property (nonatomic,copy) NSString *dateString;
@property (nonatomic,strong) NSMutableArray *listArray;


/**
 收支明细列表每个分区 header --- date
 */
- (NSString *)getDateString;

/**
 收支明细列表每个时间段分区 array
 */
- (NSMutableArray *)getListArray;

/**
 收支明细列表每个时间段分区 array.count
 */
- (NSInteger)getListArrayCount;
/**
 * 收支明细表 总的array(便利成自己想要的array数据源)
 */
+ (NSMutableArray *)getDataArray:(NSMutableArray *)dataArray;


@end
