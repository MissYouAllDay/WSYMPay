//
//  YMPayCashierTopView.h
//  WSYMPay
//
//  Created by pzj on 2017/5/23.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMPayCashierTopViewDelegate <NSObject>
- (void)selectQuitBtnMethod;
@end

@interface YMPayCashierTopView : UIView<YMPayCashierTopViewDelegate>

@property (nonatomic, weak) id <YMPayCashierTopViewDelegate>delegate;
@property (nonatomic, copy) NSString *titleStr;

@end
