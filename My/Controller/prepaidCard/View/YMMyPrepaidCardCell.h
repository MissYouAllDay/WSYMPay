//
//  YMMyPrepaidCardCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

/*
 * 绑定的有名预付卡
 * changed by pzj
 * 2017-3-20
 */
#import <UIKit/UIKit.h>

@class YMMyPrepaidCardCell,YMPrepaidCardModel;

@protocol YMMyPrepaidCardCellDelegate <NSObject>

@optional
-(void)myPrepaidCardCellManagementButtonDidClick:(YMMyPrepaidCardCell *)cardCell;

@end

@interface YMMyPrepaidCardCell : UITableViewCell

@property (nonatomic, strong) YMPrepaidCardModel *prepaidCardNO;

@property (nonatomic, weak) id <YMMyPrepaidCardCellDelegate> delegate;
@end
