//
//  YMBankCardCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/30.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMMyBankCardCell,YMBankCardModel;
@protocol YMMyBankCardCellDelegate <NSObject>

@optional
-(void)myBankCardCellManagementButtonDidClick:(YMMyBankCardCell *)cardCell;

@end

@interface YMMyBankCardCell : UITableViewCell

@property (nonatomic, strong) YMBankCardModel *bankCardInfo;

@property (nonatomic, weak) id <YMMyBankCardCellDelegate> delegate;
@end
