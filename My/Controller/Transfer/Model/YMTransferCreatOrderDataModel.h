//
//  YMTransferCreatOrderDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 转账到余额(创建转账订单)model
 */
#import <Foundation/Foundation.h>

@interface YMTransferCreatOrderDataModel : NSObject

@property (nonatomic, copy) NSString *randomCode;
@property (nonatomic, copy) NSString *traordNo;
@property (nonatomic, copy) NSString *prdOrdNo;


- (NSString *) getPrdOrdNoStr;
/**
 转账订单
 */
- (NSString *) getTraordNoStr;

/**
 随机码
 */
- (NSString *) getRandomCodeStr;

@end
