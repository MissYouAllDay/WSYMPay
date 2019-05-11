//
//  AgreementButton.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMProtocolButton;

@protocol YMProtocolButtonDelegate <NSObject>

@optional
-(void)protocolButtonImageBtnSelected:(YMProtocolButton *)agBtn;
-(void)protocolButtonTitleBtnDidClick:(YMProtocolButton *)agBtn;
@end

@interface YMProtocolButton : UIView

@property (nonatomic, copy)NSString *title;

@property (nonatomic, assign,getter=isSelected) BOOL selected;

@property (nonatomic, weak) id <YMProtocolButtonDelegate> delegate;
@end
