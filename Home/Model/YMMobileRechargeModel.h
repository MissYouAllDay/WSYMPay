//
//  YMMobileRechargeModel.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMMobileRechargeModel : NSObject

@property (nonatomic, strong) NSString *prodId;//话费充值产品id
@property (nonatomic, strong) NSString *prodContent;//面值
@property (nonatomic, strong) NSString *prodPrice;//商品价格
@property (nonatomic) BOOL canRech;//是否可用

@end
