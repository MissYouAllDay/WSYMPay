//
//  YMTXSelectBankCardCell.h
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMSelectModel;
@class YMBankCardModel;

@interface YMTXSelectBankCardCell : UITableViewCell

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) YMBankCardModel *bankCardModel;
@property (nonatomic, assign) BOOL isSelected;

@end
