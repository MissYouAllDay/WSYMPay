//
//  UIViewController+Extension.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIViewController (Extension)
-(UIImageView *)getNavigationImageView;
-(void)setNavigationBarTitntColor:(UIColor *)tintColor titleColor:(UIColor *)titleColor;
-(void)setShouldResignOnTouchOutside:(BOOL)outside;
-(void)dissmissCurrentViewController:(NSInteger)count;
@end
