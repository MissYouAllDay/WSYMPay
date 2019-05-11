//
//  YMPaymentBalanceCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMPaymentBalanceCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL enabled;
+(instancetype)configCell:(UITableView *)tableview withMoney:(NSString *)money;
@end
