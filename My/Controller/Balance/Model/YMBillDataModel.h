//
//  YMBillDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 收支明细列表 --- data Model
 * 新改
 */

#import <Foundation/Foundation.h>

@class YMBillDetailsModel;

@interface YMBillDataModel : NSObject

//返回总条数
@property (nonatomic, assign) NSInteger countNum;//(app4期账单中---订单条数)
@property (nonatomic, assign) BOOL hasOrderList;//(app4期账单中---是否有交易记录 1有0无)
@property (nonatomic, strong) NSMutableArray *list;

- (NSMutableArray *)getListArray;

@end
