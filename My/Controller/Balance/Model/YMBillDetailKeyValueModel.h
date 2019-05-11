//
//  YMBillDetailKeyValueModel.h
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//


/*
 * 收支明细--最终想要的model里的key - value
 * 新修改的model
 */
#import <Foundation/Foundation.h>

@interface YMBillDetailKeyValueModel : NSObject

@property (nonatomic, copy) NSString *keyStr;
@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic, assign) NSInteger sortNum;//排序用

- (NSString *)getKeyString;
- (NSString *)getValueString;

@end
