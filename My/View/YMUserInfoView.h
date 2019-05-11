//
//  YMUserInfoView.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/29.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMUserInfoView;
@protocol YMUserInfoViewDelegate <NSObject>

@optional
-(void)userInfoViewLoginButtonDidClick:(YMUserInfoView *)infoView;

-(void)userInfoViewMoneyDidClick:(YMUserInfoView *)infoView;
@end

@interface YMUserInfoView : UIView

@property (nonatomic, assign) BOOL userLoginStatus;
@property (nonatomic, weak) id <YMUserInfoViewDelegate> delegate;
@end
