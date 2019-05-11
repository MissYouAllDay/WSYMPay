//
//  AppDelegate.h
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MyTabBarController *_rootViewController;
}
@property (strong, nonatomic) UIWindow *window;



@end

