//
//  VerificationCodeButton.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "VerificationCodeButton.h"

@implementation VerificationCodeButton


-(instancetype)initVController:(UIViewController *)vc withTouchBlock:(ActionBlock)action
{
    self = [super init];
    if (self) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:LoginButtonBackgroundColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code_selected"] forState:UIControlStateNormal];
        [self setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code"] forState:UIControlStateDisabled];
        [self setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"code"] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12]];
        self.block = action;
        self->viewController = vc;
        
        [self addTarget:self action:@selector(loadCerCodes:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)loadCerCodes:(UIButton *)sender
{
    [viewController.view endEditing:YES];
   
    
    if (self.block) {
        self.block();
    }
    
}
-(void)createTimer
{
    self.enabled = NO;
    countDown = 60;
    NSString * str = [NSString stringWithFormat:@"%ds后重发",countDown];
    [self setTitle:str forState:UIControlStateDisabled];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCountDowns:) userInfo:nil repeats:YES];
    
}
-(void)timeCountDowns:(NSTimer *)time
{
    if (countDown < 0) {
        [_timer invalidate];
        _timer = nil;
        self.enabled = YES;
        return;
    }
    
    NSString * str = [NSString stringWithFormat:@"%ds后重发",countDown];
    [self setTitle:str forState:UIControlStateDisabled];
    countDown = countDown - 1;
    
}



@end
