//
//  YMTransferFailVC.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMResultVC.h"

@class YMTransferCheckPayPwdDataModel;

@interface YMTransferFailVC : YMResultVC

@property (nonatomic, copy) NSString *errorCode;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) YMTransferCheckPayPwdDataModel *dataModel;

@end
