//
//  YMBaseResponseModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/15.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBaseResponseModel : NSObject

@property (nonatomic, assign) NSInteger resCode;
@property (nonatomic, copy)   NSString *resMsg;
@end
