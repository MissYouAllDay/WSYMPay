//
//  YMAllBillListDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 账单列表 model 中的data 的model
 */
#import <Foundation/Foundation.h>

@class YMAllBillListDataListModel;

@interface YMAllBillListDataModel : NSObject

@property (nonatomic, assign) NSInteger countNum;//(app4期账单中---订单条数)

@property (nonatomic, assign) BOOL hasOrderList;//(app4期账单中---是否有交易记录 1有0无)
@property (nonatomic, strong) NSMutableArray *list;


@property (nonatomic, copy) NSString *AllTxamt;



- (NSMutableArray *)getListArray;

- (NSString *)getAllTxamt;

@end
