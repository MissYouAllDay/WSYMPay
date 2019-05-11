//
//  YMBankCardCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/29.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMSquaresButtonCell;

@protocol YMSquaresButtonCellDelegate <NSObject>

@optional
-(void)bankCardCellPrepaidCardButtonDidClick:(YMSquaresButtonCell *)cell;

-(void)bankCardCellBankCardButtonDidClick:(YMSquaresButtonCell *)cell;

-(void)bankCardCellScanButtonDidClick:(YMSquaresButtonCell *)cell;

@end

@interface YMSquaresButtonCell : UITableViewCell

@property (nonatomic, weak) id <YMSquaresButtonCellDelegate> delegate;
@end
