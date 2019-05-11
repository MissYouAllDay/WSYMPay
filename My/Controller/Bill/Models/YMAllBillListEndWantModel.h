//
//  YMAllBillListEndWantModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 账单列表最终想要的model
 * 自己组成想要的结构
 */
#import <Foundation/Foundation.h>

@interface YMAllBillListEndWantModel : NSObject
//header
@property (nonatomic,copy) NSString *dateString;
@property (nonatomic,strong) NSMutableArray *listArray;

/**
 * 账单列表每个分区 header --- date
 */
- (NSString *)getDateString;

/**
 * 账单列表每个时间段分区 array
 */
- (NSMutableArray *)getListArray;
/**
 * 账单列表每个时间段分区 array.count
 */
- (NSInteger)getListArrayCount;
/**
 * 账单细表 总的array(便利成自己想要的array数据源)
 */
+ (NSMutableArray *)getDataArray:(NSMutableArray *)dataArray;

@end
