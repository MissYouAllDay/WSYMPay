//
//  YMBillBaseModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/15.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 收支明细列表 --- baseModel
 * 新修改（继承自JSONModel）
 */

#import <Foundation/Foundation.h>

@class YMBillDataModel;

@interface YMBillBaseModel : NSObject

//返回状态码
@property (nonatomic, assign) NSInteger resCode;
//返回信息
@property (nonatomic, copy) NSString *resMsg;
//返回总条数
@property (nonatomic, assign) NSInteger countNum;//收支明细中接口需要
//数据
@property (nonatomic, strong) YMBillDataModel *data;

//得到总条数
- (NSInteger)getAllCountNum;

@end
