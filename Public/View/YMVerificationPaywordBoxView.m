//
//  YMVerificationPaywordBoxView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMVerificationPaywordBoxView.h"
#import "DXInputPasswordView.h"
#import "UIView+Extension.h"
#import "YMCircleLoadingView.h"

@interface YMVerificationPaywordBoxView ()<DXInputPasswordViewDelegate>

@property (nonatomic, weak) DXInputPasswordView *inputpwdView;

@property (nonatomic, weak) UIButton            *quitButton;

@property (nonatomic, weak) UIButton            *forgetPassWordButton;

@property (nonatomic, weak) UILabel             *mainTitleLabel;

@property (nonatomic, weak) UIView              *lineView;

@property (nonatomic, weak) UIView              *boxView;

@property (nonatomic, weak) YMCircleLoadingView *loadingView;

@property (nonatomic, weak) UILabel             *vStatusLabel;

@end

@implementation YMVerificationPaywordBoxView

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

    self.backgroundColor     = RGBAlphaColor(13, 13, 13, 0.5);
    self.layer.masksToBounds = YES;
    
    
    UIView *boxView         = [[UIView alloc]init];
    boxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:boxView];
    self.boxView = boxView;
    
    
    UILabel *mainTitleLabel  = [[UILabel alloc]init];
    mainTitleLabel.textColor = FONTDARKCOLOR;
    mainTitleLabel.font      = [UIFont systemFontOfSize:[VUtilsTool fontWithString:16] weight:0.015];
    mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    mainTitleLabel.text      = @"输入密码";
    [boxView addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.15);
    [boxView addSubview:lineView];
    self.lineView = lineView;
    
    //密码输入框
    DXInputPasswordView *inputpwdView = [[DXInputPasswordView alloc]init];
    inputpwdView.intervalLineColor    = LAYERCOLOR;
    inputpwdView.borderColor           = LAYERCOLOR;
    inputpwdView.backgroundColor      = RGBAlphaColor(250, 250, 250, 0.6);
    inputpwdView.layer.cornerRadius   = CORNERRADIUS;
    inputpwdView.delegate             = self;
    [boxView addSubview:inputpwdView];
    self.inputpwdView = inputpwdView;
    
    UIButton *forgetPassWordButton = [[UIButton alloc]init];
    [forgetPassWordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPassWordButton setTitleColor:RGBColor(55, 145, 226) forState:UIControlStateNormal];
    forgetPassWordButton.titleLabel.font = COMMON_FONT;
    [forgetPassWordButton addTarget:self action:@selector(forgetPassWordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:forgetPassWordButton];
    self.forgetPassWordButton = forgetPassWordButton;
    
    //退出按钮
    UIButton *quitButton = [[UIButton alloc]init];
    quitButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [quitButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [boxView addSubview:quitButton];
    self.quitButton = quitButton;
    
    
    YMCircleLoadingView *loadingView = [[YMCircleLoadingView alloc]init];
    loadingView.hidden = YES;
    [boxView addSubview:loadingView];
    self.loadingView = loadingView;
    
    UILabel *vStatusLabel  = [[UILabel alloc]init];
    vStatusLabel .text      = @"正在验证";
    vStatusLabel .textColor = FONTDARKCOLOR;
    vStatusLabel .font      = [UIFont systemFontOfMutableSize:13];
    vStatusLabel .hidden    = YES;
    [vStatusLabel sizeToFit];
    [boxView addSubview:vStatusLabel];
    self.vStatusLabel = vStatusLabel;
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat height   = SCREENHEIGHT * 0.06;
    CGFloat interval = height * 0.1;
    
    
    self.boxView.x      = 0;
    self.boxView.width  = SCREENWIDTH;
    self.boxView.height = SCREENHEIGHT * 0.3 + 216;
    self.boxView.y      = SCREENHEIGHT - self.boxView.height;
    
    self.mainTitleLabel.width   = self.width * 0.4;
    self.mainTitleLabel.height  = height;
    self.mainTitleLabel.y       = interval;
    self.mainTitleLabel.centerX = self.width * 0.5;
    
    self.quitButton.x     = interval;
    self.quitButton.y     = interval;
    self.quitButton.width = self.quitButton.height = height;
    
    self.lineView.y      = self.mainTitleLabel.bottom + interval;
    self.lineView.x      = 0;
    self.lineView.width  = self.width;
    self.lineView.height = 1;
    
    self.loadingView.y       = self.lineView.bottom + height;
    self.loadingView.width   = height * 1.5;
    self.loadingView.height  = self.loadingView.width;
    self.loadingView.centerX = self.width * 0.5;
    
    self.vStatusLabel.y       = self.loadingView.bottom + height;
    self.vStatusLabel.centerX = self.width * 0.5;
    
    self.inputpwdView.y       = self.lineView.bottom + height * 0.5;
    self.inputpwdView.width   = self.width * 0.85;
    self.inputpwdView.centerX = self.width * 0.5;
    self.inputpwdView.height  = self.width * 0.13;
    
    self.forgetPassWordButton.height = height;
    self.forgetPassWordButton.width  = self.width * 0.3;
    self.forgetPassWordButton.x      = self.width - self.forgetPassWordButton.width - height * 0.5;
    self.forgetPassWordButton.y      = self.inputpwdView.bottom + interval;
    
}

-(void)show
{
  if (![NSThread isMainThread]) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [self show];
        
    });
  }
    
    [self.inputpwdView becomeFirstResponder];
    self.loading = NO;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.frame = keyWindow.bounds;
    
    [keyWindow addSubview:self];
    
}

-(void)remove
{
    [self removeFromSuperview];
}

-(void)quitButtonClick
{
    [self.inputpwdView clearUpPassword];
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(verificationPaywordBoxViewQuitButtonDidClick:)]) {
        
        [self.delegate verificationPaywordBoxViewQuitButtonDidClick:self];
    }
    if (self.quitBlock) {
        self.quitBlock();
    }
}

-(void)forgetPassWordButtonClick
{
    if ([self.delegate respondsToSelector:@selector(verificationPaywordBoxViewForgetButtonDidClick:)]) {
        
        [self.delegate verificationPaywordBoxViewForgetButtonDidClick:self];
    }
    if (self.forgetPwdBlock) {
        self.forgetPwdBlock();
    }
}

-(void)inputPasswordView:(DXInputPasswordView *)inputPasswordView completeInput:(NSString *)str
{
    if ([self.delegate respondsToSelector:@selector(verificationPaywordBoxView:completeInput:)]) {
        
        [self.delegate verificationPaywordBoxView:self completeInput:str];
    }
    if (self.successBlock) {
        self.successBlock(str);
    }
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

-(void)setLoading:(BOOL)loading
{
    [self.inputpwdView clearUpPassword];
    
    self.inputpwdView.hidden = loading;
    self.vStatusLabel.hidden = !loading;
    self.loadingView.hidden  = !loading;
    self.forgetPassWordButton.hidden = loading;
    
    if (loading) {
        
        [self.loadingView startAnimation];
        [self.inputpwdView.textField resignFirstResponder];
    } else {
    
        [self.loadingView stopAnimation];
        [self.inputpwdView becomeFirstResponder];
    }
}
#pragma mark - app4期 changed by pzj
static YMVerificationPaywordBoxView *instance = nil;
+ (YMVerificationPaywordBoxView *)getPayPwdBoxView
{
    instance = [[YMVerificationPaywordBoxView alloc] init];
    [instance show];
    return instance;
}
/**
 调起输入支付密码弹框view
 
 @param success 输入密码成功---返回输入的密码 当前view
 @param forgetPwd 忘记密码
 @param quit 退出view
 */
- (void)showPayPwdBoxViewResultSuccess:(void(^)(NSString *pwdStr))success
                          forgetPwdBtn:(void(^)())forgetPwd
                               quitBtn:(void(^)())quit
{

    
    self.successBlock = [success copy];
    self.forgetPwdBlock = [forgetPwd copy];
    self.quitBlock = [quit copy];
}


@end
