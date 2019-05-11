//
//  YMPushModel.m
//  WSYMMerchantPay
//
//  Created by W-Duxin on 2017/6/28.
//  Copyright © 2017年 WSYM. All rights reserved.
//

#import "YMPushModel.h"
#import "YMUserInfoTool.h"
#import "YMNavigationController.h"
@implementation YMPushModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"alert":@"aps.alert",
             };
}

-(BOOL)isShowBills
{
    return self.pushTranType.length && self.pushPrdOrdNo.length;
}

-(void)showBillDetailsVC
{
//    if ([self isShowBills] && [YMUserInfoTool shareInstance].isLogin) {
//        YMPushBillDetails *pushVC = [[YMPushBillDetails alloc]init];
//        pushVC.pushTranType = self.pushTranType;
//        pushVC.prdOrdNo     = self.pushPrdOrdNo;
//        YMNavigationController *nav = [[YMNavigationController alloc]initWithRootViewController:pushVC];
//        [KEYWINDOW.rootViewController presentViewController:nav animated:YES completion:nil];
//    }
}

-(void)showBillDetailsVCWithCUP
{
    if ([self.pushTranType isEqualToString:@"2"]) {
        [self showBillDetailsVC];
    }
}

@end
