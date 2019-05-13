//
//  CXFunctionTool.h
//  WSYMPay
//
//  Created by mac on 2019/5/10.
//  Copyright © 2019 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXFunctionDelegate <NSObject>

// 是别结果
- (void)functionWithFinger:(NSInteger)error;

@end
@interface CXFunctionTool : NSObject


/** <#mark#> */
@property (nonatomic, weak) id<CXFunctionDelegate> delegate;

+ (instancetype)shareFunctionTool;

// 指纹 识别
- (void)fingerReg;


/**
 获取某个月的第一天和最后一天

 @param dateStr 日期
 @return @[第一天,最后一天]
 */
+ (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr;

//判空 空 返回NO   非空 返回YES
+(BOOL)haveValue:(id)value;

// 判断是否是否金额
+ (BOOL)isMoney:(NSString *)money;
@end

NS_ASSUME_NONNULL_END
