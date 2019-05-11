//
//  YMUserInfoView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/29.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMUserInfoView.h"
#import "YMUserInfoTool.h"
#import "UIView+Extension.h"
@interface YMUserInfoView ()
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIButton    *loginButton;
@property (nonatomic, weak) UILabel     *availableTitleLabel;
@property (nonatomic, weak) UILabel     *availableMoneyLabel;
@property (nonatomic, weak) UIButton    *HideMoneyBtn;
@property (nonatomic, copy) NSString    *money;
@end

@implementation YMUserInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = NAVIGATIONBARCOLOR;
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"User profile"]];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginBtn)];
    //使用一根手指单击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired    = 1;
    recognizer.numberOfTouchesRequired = 1;
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:recognizer];
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"btn-login-register"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
    [loginButton addTarget:nil action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    loginButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:loginButton];
    self.loginButton = loginButton;
    
    

    UILabel *availableTitleLabel = [[UILabel alloc]init];
    availableTitleLabel.text                      = @"可用余额（元）";
    availableTitleLabel.numberOfLines             = 0;
    availableTitleLabel.textAlignment             = NSTextAlignmentCenter;
    availableTitleLabel.adjustsFontSizeToFitWidth = YES;
    availableTitleLabel.textColor                 = [UIColor whiteColor];
    availableTitleLabel.hidden                    = YES;
    availableTitleLabel.userInteractionEnabled    = YES;
    UITapGestureRecognizer *recognizer2           = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyBtn)];
    //使用一根手指单击时，才触发点按手势识别器
    recognizer2.numberOfTapsRequired              = 1;
    recognizer2.numberOfTouchesRequired           = 1;
    [availableTitleLabel addGestureRecognizer:recognizer2];
    [self addSubview:availableTitleLabel];
    self.availableTitleLabel = availableTitleLabel;
    

    UILabel *availableMoneyLabel = [[UILabel alloc]init];
    availableMoneyLabel.text                      = @"***";
    availableMoneyLabel.numberOfLines             = 0;
    availableMoneyLabel.textColor                 = [UIColor whiteColor];
    availableMoneyLabel.textAlignment             = NSTextAlignmentCenter;
    availableMoneyLabel.adjustsFontSizeToFitWidth = YES;
    availableMoneyLabel.hidden                    = YES;
    availableMoneyLabel.userInteractionEnabled    = YES;
    UITapGestureRecognizer *recognizer3           = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyBtn)];
    //使用一根手指单击时，才触发点按手势识别器
    recognizer3.numberOfTapsRequired              = 1;
    recognizer3.numberOfTouchesRequired           = 1;
    [availableMoneyLabel addGestureRecognizer:recognizer3];
    [self addSubview:availableMoneyLabel];
     self.availableMoneyLabel = availableMoneyLabel;

    UIButton *HideMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    HideMoneyBtn.hidden    = YES;
    [HideMoneyBtn setImage:[UIImage imageNamed:@"my_close"] forState:UIControlStateNormal];
    [HideMoneyBtn setImage:[UIImage imageNamed:@"my_open"]  forState:UIControlStateSelected];
    [HideMoneyBtn addTarget:self action:@selector(lookBtn:)  forControlEvents:UIControlEventTouchUpInside];
    HideMoneyBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:HideMoneyBtn];
    self.HideMoneyBtn = HideMoneyBtn;
    
}
-(void)setUserLoginStatus:(BOOL)userLoginStatus;
{
    _userLoginStatus = userLoginStatus;
    
    if (_userLoginStatus) {
        
        self.iconImageView.hidden                     = YES;
        self.loginButton.hidden                       = YES;
        self.HideMoneyBtn.hidden                      = NO;
        self.availableTitleLabel.hidden               = NO;
        self.availableMoneyLabel.hidden               = NO;
        self.money = [YMUserInfoTool shareInstance].cashAcBal;
        self.availableMoneyLabel.text                 = self.money;
        _HideMoneyBtn.selected                        = ![YMUserInfoTool shareInstance].isHiddenMony;
        
        if ([YMUserInfoTool shareInstance].isHiddenMony) {
            
            self.availableMoneyLabel.text =@"***";
            
        }else{
            
            self.availableMoneyLabel.text = [YMUserInfoTool shareInstance].cashAcBal;
        }
        
    } else {
    
        self.iconImageView.hidden                     = NO;
        self.loginButton.hidden                       = NO;
        self.availableTitleLabel.hidden               = YES;
        self.availableMoneyLabel.hidden               = YES;
        self.HideMoneyBtn.hidden                      = YES;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.iconImageView.x      = SCREENWIDTH/2.0-(80/375.0*SCREENWIDTH/2.0);
    self.iconImageView.y      = 0;
    self.iconImageView.width  = 80/375.0*SCREENWIDTH;
    self.iconImageView.height = 80/375.0*SCREENWIDTH;
    

    self.loginButton.x      = SCREENWIDTH/2.0-(160/375.0*SCREENWIDTH/2);
    self.loginButton.y      = 150.0/667*SCREENHEIGHT-(55/667.0*SCREENHEIGHT);
    self.loginButton.width  = 160/375.0*SCREENWIDTH;
    self.loginButton.height = 35/667.0*SCREENHEIGHT;
    
 
    self.HideMoneyBtn.x      = SCREENWIDTH-(75.0/375*SCREENWIDTH);
    self.HideMoneyBtn.y      = 150.0/667*SCREENHEIGHT/2+(10.0/667*SCREENHEIGHT);
    self.HideMoneyBtn.width  = 30/375.0*SCREENWIDTH;
    self.HideMoneyBtn.height = 25/667.0*SCREENHEIGHT;
    
    
    self.availableTitleLabel.x      = SCREENWIDTH/2.0-(200/375.0*SCREENWIDTH/2);
    self.availableTitleLabel.y      = 150.0/667*SCREENHEIGHT/2-(30/667.0*SCREENHEIGHT);
    self.availableTitleLabel.width  = 200/375.0*SCREENWIDTH;
    self.availableTitleLabel.height = 30/667.0*SCREENHEIGHT;

    
    self.availableMoneyLabel.x      = SCREENWIDTH/2-(200/375.0*SCREENWIDTH/2);
    self.availableMoneyLabel.y      = 150.0/667*SCREENHEIGHT/2+(10.0/667*SCREENHEIGHT);
    self.availableMoneyLabel.width  = 200/375.0*SCREENWIDTH;
    self.availableMoneyLabel.height = 30/667.0*SCREENHEIGHT;

}

- (void)lookBtn:(UIButton *)lookBtn{
    lookBtn.selected = !lookBtn.isSelected;
    
    BOOL status = lookBtn.selected;
    
    if (status) {
        
        self.availableMoneyLabel.text = self.money;
        
    }else{
        
        self.availableMoneyLabel.text  = @"***";
    }
    
    [YMUserInfoTool shareInstance].HiddenMony = !status;
    [[YMUserInfoTool shareInstance] saveUserInfoToSanbox];
    
}

- (void)loginBtn{

    if ([self.delegate respondsToSelector:@selector(userInfoViewLoginButtonDidClick:)]) {
        
        [self.delegate userInfoViewLoginButtonDidClick:self];
    }
}

-(void)moneyBtn
{
    if ([self.delegate respondsToSelector:@selector(userInfoViewMoneyDidClick:)]) {
        
        [self.delegate userInfoViewMoneyDidClick:self];
    }

}

@end
