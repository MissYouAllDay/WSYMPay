//
//  SettingAmountVC.h
//  WSYMPay
//
//  Created by junchiNB on 2019/4/21.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingAmountVC : UIViewController
@property (nonatomic,copy)void(^settingAmountBlock)(NSString *);
@end

NS_ASSUME_NONNULL_END
