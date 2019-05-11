//
//  PromptBoxView.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromptBoxView;

@protocol PromptBoxViewDelegate <NSObject>

@optional
//左边按钮点击
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView;
//右边按钮点击
-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView;

@end

@interface PromptBoxView : UIView

/**
 *  主标题
 */
@property (nonatomic, copy) NSString * firstTitle;
/**
 *  副标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  图片icon
 */
@property (nonatomic, copy) NSString * titleImgName;

@property (nonatomic, copy) NSString *leftButtonTitle;

@property (nonatomic, copy) NSString *rightButtonTitle;

@property (nonatomic, weak)id <PromptBoxViewDelegate> delegate;

@property (nonatomic, assign) BOOL isOneBtn;

-(void)show;

-(void)removeView;
@end
