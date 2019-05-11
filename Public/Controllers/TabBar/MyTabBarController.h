//
//  MyTabBarController.h
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "FinancialViewController.h"
#import "FindViewController.h"
#import "MyViewController.h"
#import "YMMyBankCardController.h"
@interface MyTabBarController : UITabBarController
{
    HomeViewController      *_homeViewController;
    FinancialViewController *_financialViewController;
    FindViewController      *_findViewController;
    MyViewController        *_myViewController;
    YMMyBankCardController *_mybankcardController;
}
@end
