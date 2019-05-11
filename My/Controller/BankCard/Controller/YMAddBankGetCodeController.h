//
//  YMAddBankGetCodeController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/1.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAddGetVCodeController.h"
@class RequestModel,YMBankCardModel;
@interface YMAddBankGetCodeController : YMAddGetVCodeController
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) RequestModel *paramers;
@property (nonatomic, strong) YMBankCardModel *bankCardModel;

@end
