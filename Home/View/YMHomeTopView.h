//
//  YMHomeTopView.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMHomeTopView;
@protocol YMHomeTopViewDelegate <NSObject>
-(void)topView:(YMHomeTopView *)view itemDidClick:(NSInteger)index;
@end
@interface YMHomeTopView : UIView
@property (nonatomic, copy) void (^clickItemBlock)(NSInteger currentIndex);

@property (nonatomic, weak) id <YMHomeTopViewDelegate> delegate;
@end
