//
//  YMAccountGradesView.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/7.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMAccountGradesView;

@protocol YMAccountGradesViewDelegate <NSObject>

@optional
-(void)accountGradesViewUpgradeAccountButtonDidClick:(YMAccountGradesView *)aView;

-(void)accountGradesViewKnowMoreButtonDidClick:(YMAccountGradesView *)aView;
@end

@interface YMAccountGradesView : UIView

@property (nonatomic, copy) NSString *accountType;//账户类型
@property (nonatomic, copy) NSString *amountLimit;//总额度
@property (nonatomic, copy) NSString *surplusAMT;//剩余额度
@property (nonatomic, weak) id <YMAccountGradesViewDelegate> delegate;

@end
