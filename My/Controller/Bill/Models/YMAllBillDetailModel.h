//
//  YMAllBillDetailModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 订单详情model 总model
 */
#import <Foundation/Foundation.h>

@class YMAllBillDetailDataModel;

@interface YMAllBillDetailModel : NSObject

//返回状态码
@property (nonatomic, copy) NSString *resCode;
//返回信息
@property (nonatomic, copy) NSString *resMsg;
//数据
@property (nonatomic, strong) YMAllBillDetailDataModel *data;

- (NSString *)getResCodeStr;
- (NSString *)getResMsgStr;
- (YMAllBillDetailDataModel *)getDataModel;

@end

