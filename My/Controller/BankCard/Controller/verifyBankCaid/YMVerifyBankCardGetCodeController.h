//
//  YMVerifyBankCardGetCodeControllerViewController.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/11.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAddGetVCodeController.h"
@class YMBankCardModel;
@interface YMVerifyBankCardGetCodeController : YMAddGetVCodeController
@property (nonatomic, strong) YMBankCardModel *bankCardModel;
@end
