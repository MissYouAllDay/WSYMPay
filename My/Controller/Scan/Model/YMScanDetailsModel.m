//
//  YMScanDetailsModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/10.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanDetailsModel.h"
#import "NSString+AES.h"
@implementation YMScanDetailsModel

-(void)setTxAmt:(NSString *)txAmt
{
    _txAmt = [txAmt copy];
    _txAmt = _txAmt.decryptAES;
}


@end
