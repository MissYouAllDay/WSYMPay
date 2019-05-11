//
//  UIViewController+Extension.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "IQKeyboardManager.h"
@implementation UIViewController (Extension)

-(UIImageView *)getNavigationImageView
{
   return [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

-(void)setNavigationBarTitntColor:(UIColor *)tintColor titleColor:(UIColor *)titleColor
{
    if (tintColor) {
        [self.navigationController.navigationBar setBarTintColor:tintColor];
    }
    
    if (titleColor) {
        NSDictionary * dict = @{NSFontAttributeName:NAV_FONT,NSForegroundColorAttributeName:titleColor};
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
}

-(void)setShouldResignOnTouchOutside:(BOOL)outside
{
    IQKeyboardManager* manager                  = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside          = outside;
}

-(void)dissmissCurrentViewController:(NSInteger)count
{
    NSMutableArray *VCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (int i = 0; i<count; i++) {
        [VCs removeObjectAtIndex:[VCs count] - 2];
    }
    
    [self.navigationController  setViewControllers:VCs];
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end
