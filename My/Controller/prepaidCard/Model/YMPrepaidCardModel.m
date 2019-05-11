//
//  YMPrepaidCardModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPrepaidCardModel.h"
#import "NSString+AES.h"
@implementation YMPrepaidCardModel
MJCodingImplementation

-(YMPrepaidCardModel *)getDecryptAESModel
{
    self.prepaidNo = self.prepaidNo.decryptAES;
    return self;
}

-(YMPrepaidCardModel *)getEnCryptAESModel
{
    self.prepaidNo = self.prepaidNo.encryptAES;
    return self;
}
@end
