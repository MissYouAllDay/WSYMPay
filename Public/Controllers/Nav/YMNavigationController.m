//
//  YMNavigationController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/11/15.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMNavigationController.h"
#import "UploadIDCardViewController.h"
#import "RealNameCertificationSucessViewController.h"
#import "YMTransferSuccessVC.h"
#import "YMTransferMoneyVC.h"
#import "YMTransferToYmWalletVC.h"
#import "YMTransferProcessVC.h"
#import "YMTransferFailVC.h"
#import "YMTransferToBankCardConfirmVC.h"
#import "YMTransferToBankCardVC.h"

@interface YMNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YMNavigationController

+(void)load
{
    [[UINavigationBar appearance] setBarTintColor:NAVIGATIONBARCOLOR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:NAV_FONT,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     [UINavigationBar  appearance].translucent = NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // 设置导航控制器为手势识别器的代理
    self.interactivePopGestureRecognizer.delegate = self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
       if (self.viewControllers.count > 0) {
           viewController.hidesBottomBarWhenPushed         = YES;
            //tag值为500的界面是不需要添加返回按钮的界面
            if (viewController.view.tag != 500 ) {
                UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTouchUp)];
                viewController.navigationItem.leftBarButtonItem = leftItem;
            }
        }
    [super pushViewController:viewController animated:animated];
   
    if ([viewController isKindOfClass:[YMTransferSuccessVC class]]||[viewController isKindOfClass:[YMTransferProcessVC class]]||[viewController isKindOfClass:[YMTransferFailVC class]]) {
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.viewControllers];
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:vcs];
        for (UIViewController *vc in vcArray) {
            if ([vc isKindOfClass:[YMTransferMoneyVC class]]) {
                [vcs removeObject:vc];
            }
            if ([vc isKindOfClass:[YMTransferToYmWalletVC class]]) {
                [vcs removeObject:vc];
            }
            if ([vc isKindOfClass:[YMTransferToBankCardVC class]]) {
                [vcs removeObject:vc];
            }
            if ([vc isKindOfClass:[YMTransferToBankCardConfirmVC class]]) {
                [vcs removeObject:vc];
            }
        }
        [self  setViewControllers:vcs];
    }
    
}

-(void)backBtnTouchUp
{
    [self popViewControllerAnimated:YES];

}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
   // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效 tag值为500时则无效
    
    if ([self.viewControllers lastObject].view.tag == 500) {
        
        return NO;
    }
    
    return self.childViewControllers.count > 1;
}


@end
