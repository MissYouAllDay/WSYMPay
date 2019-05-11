//
//  UIBarButtonItem+Extension.h
//  WSYMMerchantPay
//
//  Created by pzj on 2017/6/19.
//  Copyright © 2017年 pzj. All rights reserved.
//

/*
 * 导航条上 item
 */
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

@property (strong, nonatomic) UILabel *badge;

// Badge value to be display
@property (nonatomic) NSString *badgeValue;
// Badge background color
@property (nonatomic) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;
// Badge font
@property (nonatomic) UIFont *badgeFont;
// Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithTitle:(NSString *)buttonTitle titleColor:(UIColor *)titleColor buttonFont:(UIFont *)buttonFont target:(id)target action:(SEL)action;

//+ (UIBarButtonItem *)createRightItemWithImage:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title target:(id)target action:(SEL)action;

@end
