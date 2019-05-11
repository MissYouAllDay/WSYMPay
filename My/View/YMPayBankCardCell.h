//
//  YMPayBankCardCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMBankCardModel,YMBankCardDataModel;

@interface YMPayBankCardCell : UITableViewCell

@property (nonatomic, strong) YMBankCardModel *bankCardModel;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) NSInteger type;//1充值；2提现;

- (void)sendSelectYuEWithBankCardDataModel:(YMBankCardDataModel*)dataModel yuEIsSelected:(BOOL)yuEIsSelected;

@end
