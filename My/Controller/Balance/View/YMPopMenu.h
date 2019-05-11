//
//  YMPopMenu.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMPopMenu;

@protocol YMPopMenuDelegate <NSObject>

-(void)popMenu:(YMPopMenu *)popMenu clickedButtonAtIndex:(NSUInteger)tag;

@end

@interface YMPopMenu : UIView

@property (nonatomic, weak) id <YMPopMenuDelegate> delegate;

-(void)showInRect:(CGRect)rect;


@end
