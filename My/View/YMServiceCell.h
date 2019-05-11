//
//  YMServiceCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM (NSInteger, YMServiceButtonState) {
  YMServiceReplenishing,
  YMServiceTransferAccounts,
};

typedef void(^ButtonDidClick)(YMServiceButtonState state);
@interface YMServiceCell : UITableViewCell
@property (nonatomic, copy) ButtonDidClick buttonDidClick;
@end
