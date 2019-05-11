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

@end

NS_ASSUME_NONNULL_END
