//
//  YMHomeBottomView.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMHomeBottomView;
@protocol YMHomeBottomViewDelegate <NSObject>
-(void)bottomView:(YMHomeBottomView *)view itemDidClick:(NSInteger)index;
@end

@interface YMHomeBottomView : UIView
@property (nonatomic, copy) void (^clickItemBlock)(NSInteger currentIndex);
@property (nonatomic, weak) id <YMHomeBottomViewDelegate> delegate;
@end
