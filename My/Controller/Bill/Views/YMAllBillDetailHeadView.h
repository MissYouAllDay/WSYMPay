//
//  YMAllBillDetailHeadView.h
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 账单详情界面 header
 * 说明： 名称
         金额
         交易状态
 */
#import <UIKit/UIKit.h>
#import "YMAllBillDetailVC.h"

@class YMAllBillDetailDataModel;

@interface YMAllBillDetailHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *txAmtLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *specLineView;

+ (YMAllBillDetailHeadView *)instanceView;

- (void)sendBillDetailType:(BillDetailType)billDetailType model:(YMAllBillDetailDataModel *)model;

@end
