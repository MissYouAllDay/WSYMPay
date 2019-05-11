//
//  YMRecordHeaderView.h
//  WSYMPay
//
//  Created by PengCheng on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMRecordHeaderView : UIView
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *totalCountLabel;
@property (nonatomic, strong) UILabel *totalMoneyLabel;
@end

NS_ASSUME_NONNULL_END
