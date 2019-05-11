//
//  YMAllBillListModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 账单列表model
 * 最原始的model
 */
#import <Foundation/Foundation.h>

@class YMAllBillListDataModel;

@interface YMAllBillListModel : NSObject

//返回状态码
@property (nonatomic, copy) NSString *resCode;


//返回信息
@property (nonatomic, copy) NSString *resMsg;
//数据
@property (nonatomic, strong) YMAllBillListDataModel *data;

- (NSString *)getResCodeStr;
- (NSString *)getResMsgStr;
- (YMAllBillListDataModel *)getDataModel;

@end
