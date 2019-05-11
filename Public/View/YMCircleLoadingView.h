//
//  YMCircleLoadingView.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/6.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCircleLoadingView : UIView
// 线宽
// default is 2.0f
@property (nonatomic, assign) CGFloat lineWidth;

// 线的颜色
// default is [UIColor lightGrayColor]
@property (nonatomic, strong) UIColor *lineColor;

// 是否添加动画
// default is YES
@property (nonatomic, readonly) BOOL isAnimating;

// 开始、结束动画效果
- (void)startAnimation;
// 结束动画的时候会移除掉
- (void)stopAnimation;
@end
