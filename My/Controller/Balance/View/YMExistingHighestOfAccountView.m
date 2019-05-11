//
//  YMExistingHighestForAccountView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/8.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMExistingHighestOfAccountView.h"
#import "YMUserInfoTool.h"

@interface YMExistingHighestOfAccountView ()

@property (nonatomic, weak) UIView  *contentView;

@property (nonatomic, weak) UILabel *mainTitleLabel;

@property (nonatomic, weak) UILabel *explainLabel;

@property (nonatomic, weak) UIButton *quitButton;



@end

@implementation YMExistingHighestOfAccountView

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
    self.backgroundColor   = RGBAlphaColor(0, 0, 0, 0.7);
    UIView *contentView             = [[UIView alloc]init];
    contentView.backgroundColor     = [UIColor whiteColor];
    contentView.layer.cornerRadius  = CORNERRADIUS;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    //退出按钮
    UIButton *quitButton = [[UIButton alloc]init];
    quitButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [quitButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:quitButton];
    [quitButton sizeToFit];
    self.quitButton = quitButton;
    
    
    UILabel *mainTitleLabel      = [[UILabel alloc]init];
    mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    mainTitleLabel.font          = [UIFont systemFontOfSize:[VUtilsTool fontWithString:19]];
    mainTitleLabel.text          = @"您名下已有III类账户";
    [contentView addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UILabel *explainLabel = [[UILabel alloc]init];
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.textColor     = FONTCOLOR;
    [contentView addSubview:explainLabel];
    self.explainLabel = explainLabel;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(SCREENHEIGHT * 0.4);
        make.width.mas_equalTo(SCREENWIDTH * 0.9);
        make.top.mas_equalTo(SCREENHEIGHT * 0.22);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    CGFloat interval = SCREENHEIGHT * 0.4 * 0.08;
    
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-interval);
        make.top.equalTo(self.contentView.mas_top).offset(interval / 2);
        
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(interval);
        make.top.equalTo(self.quitButton.mas_bottom).offset(interval * 0.5);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(.75);
        make.centerX.equalTo(self.contentView.mas_centerX);
        
    }];
}

-(void)quitButtonClick
{
    [self removeFromSuperview];

}

-(void)setUserName:(NSString *)userName
{
    _userName = [userName copy];

    self.explainLabel.attributedText = [self setExplanText:_userName];
    self.explainLabel.numberOfLines = 0;
    
    CGFloat  h       = [self.explainLabel sizeThatFits:CGSizeMake(SCREENWIDTH * 0.9 * 0.9,CGFLOAT_MAX)].height;
    CGFloat interval = SCREENHEIGHT * 0.4 * 0.08;
        [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.height.mas_equalTo(h);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.mainTitleLabel.mas_bottom).offset(interval);
            make.width.mas_equalTo(SCREENWIDTH * 0.9 * 0.8);
    
        }];
}


-(NSMutableAttributedString *)setExplanText:(NSString *)str
{
    
  
    NSString *text = [NSString stringWithFormat:@"根据央行监管办法,1人名下只能有1个III类账户,目前您名下已存在III类账户%@无法升级:如有疑问,建议您联系客服处理",str];
    NSRange range  =  [text rangeOfString:str];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttributes:[NSDictionary attributesForUserTextWithlineHeightMultiple:1.5] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:COMMON_FONT range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:FONTDARKCOLOR range:range];

    return attributedString;
}

@end
