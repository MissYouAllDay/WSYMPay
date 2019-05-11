//
//  YMCancelReasonCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCancelReasonCell : UITableViewCell

@property (nonatomic, assign,getter=isSelectedButton) BOOL selectedButton;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *inputText;
@end
