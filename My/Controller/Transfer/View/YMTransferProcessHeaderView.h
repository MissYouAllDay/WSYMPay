//
//  YMTransferProcessHeaderView.h
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转账结果----处理中header
 */
#import <UIKit/UIKit.h>

@class YMTransferCheckPayPwdDataModel;

@interface YMTransferProcessHeaderView : UIView


//转账结果处理中headder传值
@property (nonatomic, strong)YMTransferCheckPayPwdDataModel *model;


@end
