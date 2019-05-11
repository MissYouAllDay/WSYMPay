//
//  SettingPayPasswordView.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/22.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPayPasswordBoxView.h"
#import "DXInputPasswordView.h"
@interface YMPayPasswordBoxView ()<DXInputPasswordViewDelegate>

@property (nonatomic, weak) UIImageView *logoImageView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) DXInputPasswordView *inputpwdView;

@property (nonatomic, weak) UIButton *backButton;

@property (nonatomic, weak) UIButton *quitButton;

@end

@implementation YMPayPasswordBoxView

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
    self.backgroundColor     = RGBColor(250, 251, 252);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = CORNERRADIUS;
    self.layer.borderColor   = RGBColor(250, 251, 252).CGColor;
    
    UIImageView *logoImageView = [[UIImageView alloc]init];
    logoImageView.image = [UIImage imageNamed:@"smallLogo"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
   // logoImag
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.textColor = FONTDARKCOLOR;
    titleLabel.font      = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //密码输入框
    DXInputPasswordView *inputpwdView = [[DXInputPasswordView alloc]init];
    inputpwdView.intervalLineColor    = LAYERCOLOR;
    inputpwdView.borderColor          = LAYERCOLOR;
    inputpwdView.backgroundColor      = [UIColor whiteColor];
    inputpwdView.delegate             = self;
    [inputpwdView becomeFirstResponder];
    [self addSubview:inputpwdView];
    self.inputpwdView = inputpwdView;
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setImage:[UIImage imageNamed:@"left_arrow"]forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.backButton = backButton;
    
    //退出按钮
    UIButton *quitButton = [[UIButton alloc]init];
    [quitButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:quitButton];
    self.quitButton = quitButton;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width   = self.bounds.size.width;
    CGFloat height  = self.bounds.size.height;
    CGFloat inteval = height *0.13;
    
    self.logoImageView.frame  = CGRectMake((width - (width * 0.3))/2, height *0.07, width * 0.3,  inteval);
    CGFloat logoImageViewmaxY = CGRectGetMaxY(self.logoImageView.frame);
    self.titleLabel.frame     = CGRectMake(0, logoImageViewmaxY + inteval, width, inteval);
    self.inputpwdView.frame   = CGRectMake((width - (width * 0.87))/2, logoImageViewmaxY + inteval *3, width * 0.87, height *0.26);
    self.backButton.frame     = CGRectMake(height *0.07, height *0.07, inteval, inteval);
    self.quitButton.frame     = CGRectMake(width - inteval -height *0.07 , height *0.07, inteval, inteval);
}

-(void)inputPasswordView:(DXInputPasswordView *)inputPasswordView completeInput:(NSString *)str
{
   
    if ([self.delegate respondsToSelector:@selector(payPasswordBoxView:inputPasswordComplete:)]) {
        
       [self.delegate payPasswordBoxView:self inputPasswordComplete:str];
    }
}

//返回按钮点击
-(void)backButtonClick
{
    if ([self.delegate respondsToSelector:@selector(payPasswordBoxViewBackButtonDidClick:)]) {
        
        [self.delegate payPasswordBoxViewBackButtonDidClick:self];
    }
}
//退出按钮点击
-(void)quitButtonClick
{
    
    if ([self.delegate respondsToSelector:@selector(payPasswordBoxViewQuitButtonDidClick:)]) {
        
        [self.delegate payPasswordBoxViewQuitButtonDidClick:self];
    }
    
}

-(void)becomeFirstResponder
{
    [self.inputpwdView becomeFirstResponder];
}

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.titleLabel.text = _title;
}

-(void)clearPasswordBox
{

    [self.inputpwdView clearUpPassword];
}

-(void)setBackButtonHiden:(BOOL)backButtonHiden
{
    _backButtonHiden = backButtonHiden;

    self.backButton.hidden = _backButtonHiden;
}

-(void)setQuitButtonHiden:(BOOL)quitButtonHiden
{
    _quitButtonHiden = quitButtonHiden;
    
    self.quitButton.hidden = _quitButtonHiden;

}
@end
