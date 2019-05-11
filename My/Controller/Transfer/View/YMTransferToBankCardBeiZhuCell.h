//
//  YMTransferToBankCardBeiZhuCell.h
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMTransferToBankCardBeiZhuCellDelegate <NSObject>

- (void)textFieldWithBeiZhu:(NSString *)beiZhu;

@end
@interface YMTransferToBankCardBeiZhuCell : UITableViewCell<YMTransferToBankCardBeiZhuCellDelegate>

@property (nonatomic, weak) id<YMTransferToBankCardBeiZhuCellDelegate>delegate;

@end
