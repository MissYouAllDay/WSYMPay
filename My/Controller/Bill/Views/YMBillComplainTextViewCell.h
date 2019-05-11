//
//  YMBillComplainTextViewCell.h
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 订单详情 中 订单投诉界面 投诉原因输入框cell
 */
#import <UIKit/UIKit.h>

@protocol YMBillComplainTextViewCellDelegate <NSObject>

- (void)selectInputReasonStr:(NSString *)str;

@end

@interface YMBillComplainTextViewCell : UITableViewCell<YMBillComplainTextViewCellDelegate>

@property (nonatomic, weak) id <YMBillComplainTextViewCellDelegate>delegate;


@end
