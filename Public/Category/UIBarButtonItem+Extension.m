//
//  UIBarButtonItem+Extension.m
//  WSYMMerchantPay
//
//  Created by pzj on 2017/6/19.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import <objc/runtime.h>
#import "UIBarButtonItem+Extension.h"

NSString const *badgeKey = @"badgeKey";
NSString const *badgeBGColorKey = @"badgeBGColorKey";
NSString const *badgeTextColorKey = @"badgeTextColorKey";
NSString const *badgeFontKey = @"badgeFontKey";
NSString const *badgePaddingKey = @"badgePaddingKey";
NSString const *badgeMinSizeKey = @"badgeMinSizeKey";
NSString const *badgeOriginXKey = @"badgeOriginXKey";
NSString const *badgeOriginYKey = @"badgeOriginYKey";
NSString const *shouldHideBadgeAtZeroKey = @"shouldHideBadgeAtZeroKey";
NSString const *shouldAnimateBadgeKey = @"shouldAnimateBadgeKey";
NSString const *badgeValueKey = @"badgeValueKey";

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if (highImage) {
        [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    }
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)buttonTitle titleColor:(UIColor *)titleColor buttonFont:(UIFont *)buttonFont target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:buttonTitle forState:UIControlStateNormal];
    btn.titleLabel.font = buttonFont;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.size = CGSizeMake(44, 44);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@dynamic badgeValue, badgeBGColor, badgeTextColor, badgeFont;
@dynamic badgePadding, badgeMinSize, badgeOriginX, badgeOriginY;
@dynamic shouldHideBadgeAtZero, shouldAnimateBadge;

- (void)badgeInit
{
    // Default design initialization
    self.badgeBGColor   = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeFont      = [UIFont systemFontOfSize:12.0];
    self.badgePadding   = 6;
    self.badgeMinSize   = 6;
    self.badgeOriginX   = self.customView.frame.size.width - self.badge.frame.size.width/2;
    self.badgeOriginY   = -7;
    self.shouldHideBadgeAtZero = YES;
    self.shouldAnimateBadge = YES;
    // Avoids badge to be clipped when animating its scale
    self.customView.clipsToBounds = NO;
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)refreshBadge
{
    // Change new attributes
    self.badge.textColor        = self.badgeTextColor;
    self.badge.backgroundColor  = self.badgeBGColor;
    self.badge.font             = self.badgeFont;
}

- (CGSize) badgeExpectedSize
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don‘t call sizeToFit on the true label to avoid bad display
    UILabel *frameLabel = [self duplicateLabel:self.badge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

- (void)updateBadgeFrame
{
    
    CGSize expectedLabelSize = [self badgeExpectedSize];
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.badgePadding;
    
    // Using const we make sure the badge doesn‘t get too smal
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    self.badge.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, minWidth + padding - 5, minHeight + padding - 5);
    self.badge.layer.cornerRadius = (minHeight + padding - 5) / 2;
    self.badge.layer.masksToBounds = YES;
}

// Handle the badge changing value
- (void)updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.shouldAnimateBadge && ![self.badge.text isEqualToString:self.badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    // Set the new value
    self.badge.text = self.badgeValue;
    
    // Animate the size modification if needed
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateBadgeFrame];
    }];
}

- (UILabel *)duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)removeBadge
{
    // Animate badge removal
    [UIView animateWithDuration:0.2 animations:^{
        self.badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }];
}

#pragma mark - getters/setters
-(UILabel*) badge {
    return objc_getAssociatedObject(self, &badgeKey);
}
-(void)setBadge:(UILabel *)badgeLabel
{
    objc_setAssociatedObject(self, &badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge value to be display
-(NSString *)badgeValue {
    return objc_getAssociatedObject(self, &badgeValueKey);
}
-(void) setBadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.shouldHideBadgeAtZero)) {
        [self removeBadge];
    } else if (!self.badge) {
        // Create a new badge because not existing
        if (![badgeValue isEqualToString:@"0"]) {
            self.badge                      = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 20, 20)];
            self.badge.textColor            = self.badgeTextColor;
            self.badge.backgroundColor      = self.badgeBGColor;
            self.badge.font                 = self.badgeFont;
            self.badge.textAlignment        = NSTextAlignmentCenter;
            [self badgeInit];
            [self.customView addSubview:self.badge];
            [self updateBadgeValueAnimated:NO];        
        }
    } else {
        [self updateBadgeValueAnimated:YES];
    }
}

// Badge background color
-(UIColor *)badgeBGColor {
    return objc_getAssociatedObject(self, &badgeBGColorKey);
}
-(void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Badge text color
-(UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &badgeTextColorKey);
}
-(void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Badge font
-(UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &badgeFontKey);
}
-(void)setBadgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

// Padding value for the badge
-(CGFloat) badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &badgePaddingKey);
    return number.floatValue;
}
-(void) setBadgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// Minimum size badge to small
-(CGFloat) badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &badgeMinSizeKey);
    return number.floatValue;
}
-(void) setBadgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// Values for offseting the badge over the BarButtonItem you picked
-(CGFloat) badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &badgeOriginXKey);
    return number.floatValue;
}
-(void) setBadgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

-(CGFloat) badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &badgeOriginYKey);
    return number.floatValue;
}
-(void) setBadgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self updateBadgeFrame];
    }
}

// In case of numbers, remove the badge when reaching zero
-(BOOL) shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setShouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge has a bounce animation when value changes
-(BOOL) shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setShouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
