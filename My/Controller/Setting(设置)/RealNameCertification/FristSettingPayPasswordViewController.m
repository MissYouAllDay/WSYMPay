//
//  FristSettionPayPasswordViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/23.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "FristSettingPayPasswordViewController.h"
#import "YMPayPasswordBoxView.h"

#define  HEIGHT    SCREENHEIGHT * 0.27
#define  WIDTH    SCREENWIDTH * 0.77
#define  CENTERX  (SCREENWIDTH - WIDTH)/2

@interface FristSettingPayPasswordViewController ()<YMPayPasswordBoxViewDelegate>

@property (nonatomic, weak) YMPayPasswordBoxView *fristSettingPayPasswordBoxView;
 
@property (nonatomic, weak) YMPayPasswordBoxView *secondSettingPayPasswordBoxView;

@property (nonatomic, copy) NSString *currentPwd;

@end

@implementation FristSettingPayPasswordViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{

    self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.7);
    YMPayPasswordBoxView *fristSettingPayPasswordBoxView = [[YMPayPasswordBoxView alloc]init];
    fristSettingPayPasswordBoxView.title = @"设置支付密码";
    fristSettingPayPasswordBoxView.backButtonHiden = YES;
    fristSettingPayPasswordBoxView.delegate = self;
    [self addSubview:fristSettingPayPasswordBoxView];
    self.fristSettingPayPasswordBoxView = fristSettingPayPasswordBoxView;
    
    YMPayPasswordBoxView *secondSettingPayPasswordBoxView = [[YMPayPasswordBoxView alloc]init];
    secondSettingPayPasswordBoxView.title = @"请确认支付密码";
    secondSettingPayPasswordBoxView.quitButtonHiden = YES;
    secondSettingPayPasswordBoxView.delegate = self;
    [self addSubview:secondSettingPayPasswordBoxView];
    self.secondSettingPayPasswordBoxView = secondSettingPayPasswordBoxView;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.fristSettingPayPasswordBoxView.frame  = CGRectMake(CENTERX, HEIGHT, WIDTH, HEIGHT);
    self.secondSettingPayPasswordBoxView.frame = CGRectMake(SCREENWIDTH+CENTERX, HEIGHT, WIDTH, HEIGHT);
    
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc =keyWindow.rootViewController;
    vc.navigationController.navigationBarHidden = YES;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
}

-(void)payPasswordBoxView:(YMPayPasswordBoxView *)settingPayPasswordView inputPasswordComplete:(NSString *)pwd
{
    if (settingPayPasswordView == self.fristSettingPayPasswordBoxView) {
        
        if (![VUtilsTool isValidateRepeatPayPwd:pwd]  || ![VUtilsTool isValidateContinuousPayPwd:pwd]) {
            [self showPromptBoxTitlt:@"支付密码不能为连续或相同的的数字"];
            [self.fristSettingPayPasswordBoxView clearPasswordBox];
            return;
        }
        self.currentPwd = pwd;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.fristSettingPayPasswordBoxView.frame = CGRectMake(CENTERX- SCREENWIDTH, HEIGHT, WIDTH, HEIGHT);
            self.secondSettingPayPasswordBoxView.frame = CGRectMake(CENTERX, HEIGHT, WIDTH, HEIGHT);
            [self.secondSettingPayPasswordBoxView becomeFirstResponder];
            [self.secondSettingPayPasswordBoxView clearPasswordBox];
        }];
        
    }
    
    if (settingPayPasswordView == self.secondSettingPayPasswordBoxView) {
        
        if ([self.currentPwd isEqualToString:pwd]) {
            
            if ([self.delegate respondsToSelector:@selector(fristSettingPayPasswordViewControllerSettingPayPasswordSuccess:password:)]) {
                [self.delegate fristSettingPayPasswordViewControllerSettingPayPasswordSuccess:self password:self.currentPwd];
            }
            
            [self removeFromSuperview];
            
        } else {
            
            [self.secondSettingPayPasswordBoxView clearPasswordBox];
            [self showPromptBoxTitlt:@"两次输入的密码不一样,请从新输入"];
        
        }
        
    }
}

-(void)payPasswordBoxViewQuitButtonDidClick:(YMPayPasswordBoxView *)settingPayPasswordView
{
    if ([self.delegate respondsToSelector:@selector(fristSettingPayPasswordViewControllerSettingPayPasswordFail:)]) {
        
        [self.delegate fristSettingPayPasswordViewControllerSettingPayPasswordFail:self];
    }
    
    [self removeFromSuperview];
  
}


-(void)payPasswordBoxViewBackButtonDidClick:(YMPayPasswordBoxView *)settingPayPasswordView
{
    
    if (settingPayPasswordView == self.secondSettingPayPasswordBoxView) {
        
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.fristSettingPayPasswordBoxView.frame  = CGRectMake(CENTERX, HEIGHT, WIDTH, HEIGHT);
            [self.fristSettingPayPasswordBoxView becomeFirstResponder];
            self.secondSettingPayPasswordBoxView.frame = CGRectMake(SCREENWIDTH + CENTERX, HEIGHT, WIDTH, HEIGHT);
            [self.fristSettingPayPasswordBoxView clearPasswordBox];
        }];
        
    }

}

-(void)showPromptBoxTitlt:(NSString *)title
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UILabel *promptBox = [[UILabel alloc]init];
    promptBox.backgroundColor = [UIColor blackColor];
    promptBox.text = title;
    promptBox.textColor = [UIColor whiteColor];
    promptBox.font      = [UIFont systemFontOfSize:15];
    promptBox.textAlignment = NSTextAlignmentCenter;
    promptBox.frame = CGRectMake(CENTERX + 10, HEIGHT + 20, WIDTH - 20, HEIGHT * 0.25);
    [keyWindow addSubview:promptBox];
    
    [UIView animateWithDuration:1.5 animations:^{
        promptBox.frame = CGRectMake(CENTERX + 10, HEIGHT + 19, WIDTH - 20, HEIGHT * 0.25);
    } completion:^(BOOL finished) {
        
        [promptBox removeFromSuperview];
    }];

}

@end
