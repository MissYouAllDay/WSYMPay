//
//  YMRevokeOrConfirmDataModel.m
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMRevokeOrConfirmDataModel.h"

@implementation YMRevokeOrConfirmDataModel

-(NSString *)getStateStr
{
    NSString *str = @"";
    if (_acceptState != nil) {
        if (![_acceptState isEmptyStr]) {
            str = _acceptState;
        }
    }
    return str;
}

@end
