//
//  YMPayPrepaidCardListView.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/16.
//  Copyright © 2016年 赢联. All rights reserved.
//


#import <UIKit/UIKit.h>

@class YMPayPrepaidCardListView;

@protocol YMPayPrepaidCardListViewDelegate <NSObject>

@optional
-(void)payPrepaidCardListView:(YMPayPrepaidCardListView *)list didSelectedPrepaidCard:(NSString *)card;

@end

@interface YMPayPrepaidCardListView : UIView

-(void)show;

@property (nonatomic, strong) NSMutableArray *prepaidCardArray;

@property (nonatomic, weak) id <YMPayPrepaidCardListViewDelegate> delegate;
@end
