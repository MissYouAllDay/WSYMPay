//
//  VerificationCodeButton.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//
typedef void (^ActionBlock)();

#import <UIKit/UIKit.h>

@interface VerificationCodeButton : UIButton
{
    UIViewController * viewController;
//    NSTimer * timer;
    int countDown;
}
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) NSTimer * timer;
-(instancetype)initVController:(UIViewController *)vc withTouchBlock:(ActionBlock)action;
-(void)createTimer;

@end
