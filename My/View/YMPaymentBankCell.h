//
//  YMPaymentBankCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMBankCardModel;
@interface YMPaymentBankCell : UITableViewCell
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL isSelected;
+(instancetype)configCell:(UITableView *)tableView withBankModel:(YMBankCardModel*)bankInfo;
@end
