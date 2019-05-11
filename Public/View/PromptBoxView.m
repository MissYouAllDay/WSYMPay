//
//  PromptBoxView.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "PromptBoxView.h"

#define TitleLableFont [UIFont systemFontOfSize:[VUtilsTool fontWithString:16]]

@interface  PromptBoxView ()
@property (nonatomic, weak) UILabel * firstTitleLabel;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *leftButton;

@property (nonatomic, weak) UIButton *rightButton;

@property (nonatomic, weak) UIView *backgroungView;

@property (nonatomic, weak) UIImageView *titleImgView;
@end

@implementation PromptBoxView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOneBtn = NO;
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CORNERRADIUS;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView * titleImageV = [UIImageView new];
    titleImageV.backgroundColor = [UIColor clearColor];
    [self addSubview:titleImageV];
    self.titleImgView = titleImageV;
    
    UILabel *firsttitleLabel = [[UILabel alloc]init];
    firsttitleLabel.font = TitleLableFont;
    firsttitleLabel.textAlignment = NSTextAlignmentCenter;
    firsttitleLabel.textColor = RGBColor(113, 114, 115);
    firsttitleLabel.numberOfLines = 0;
    firsttitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:firsttitleLabel];
    self.firstTitleLabel = firsttitleLabel;
    
    
    UILabel *titleLabel      = [[UILabel alloc]init];
    titleLabel.font          = TitleLableFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor     = RGBColor(113, 114, 115);
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    if (self.isOneBtn) {
        
        UIButton *rightButton = [[UIButton alloc]init];
        rightButton.titleLabel.font = TitleLableFont;
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:RGBColor(242, 210, 208) forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[VUtilsTool createImageWithColor:RGBColor(205, 59, 47)] forState:UIControlStateHighlighted];
        [rightButton setBackgroundImage:[VUtilsTool createImageWithColor:RGBColor(226, 72, 61)] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        self.rightButton = rightButton;

    }else{
        UIButton *leftButton = [[UIButton alloc]init];
        leftButton.titleLabel.font = TitleLableFont;
        [leftButton setTitle:@"取 消" forState:UIControlStateNormal];
        [leftButton setTitleColor:RGBColor(222, 81, 78) forState:UIControlStateNormal];
        
        [leftButton setBackgroundImage:[VUtilsTool createImageWithColor:RGBColor(255, 209, 205)] forState:UIControlStateHighlighted];
        [leftButton setBackgroundImage:[VUtilsTool createImageWithColor:RGBColor(255, 216, 213)] forState:UIControlStateNormal];
        
        [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        self.leftButton = leftButton;
        
        UIButton *rightButton = [[UIButton alloc]init];
        
        rightButton.titleLabel.font = TitleLableFont;
        [rightButton setTitle:@"登 录" forState:UIControlStateNormal];
        [rightButton setTitleColor:RGBColor(242, 210, 208) forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[VUtilsTool createImageWithColor:RGBColor(205, 59, 47)] forState:UIControlStateHighlighted];
        [rightButton setBackgroundImage:[VUtilsTool createImageWithColor:RGBColor(226, 72, 61)] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        self.rightButton = rightButton;
    }
}

//左边按钮点击
-(void)leftButtonClick
{
    [self.backgroungView removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(promptBoxViewLeftButttonDidClick:)]) {
        
        [self.delegate promptBoxViewLeftButttonDidClick:self];
    }

}
//右边按钮点击
-(void)rightButtonClick
{
    [self.backgroungView removeFromSuperview];

    if ([self.delegate respondsToSelector:@selector(promptBoxViewRightButtonDidClick:)]) {
        
        [self.delegate promptBoxViewRightButtonDidClick:self];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.firstTitleLabel.text.length > 0) {
        [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(self.mas_height).multipliedBy(0.13);
            
        }];
        
        [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.firstTitleLabel.mas_centerY);
            make.right.equalTo(self.firstTitleLabel.mas_left).offset(-5);
            make.height.equalTo(self.firstTitleLabel.mas_height);
            make.width.equalTo(self.titleImgView.mas_height);
        }];
    }else
    {
        [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.offset(0);
            
        }];
        
        if (self.titleImgName.length > 0) {
            [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).offset(10);
                make.centerX.equalTo(self.mas_centerX);
                make.height.equalTo(self.mas_height).multipliedBy(0.13);
                make.width.equalTo(self.titleImgView.mas_height);
            }];
        }
    }
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.firstTitle.length == 0 && self.titleImgName.length > 0) {
            make.top.equalTo(self.titleImgView.mas_bottom);
        }else
        {
            make.top.equalTo(self.firstTitleLabel.mas_bottom);
        }
        
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        
    }];
    
    if (self.isOneBtn) {
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(self.mas_height).multipliedBy(.25);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
    }else{
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.width.equalTo(self.mas_width).multipliedBy(.5);
            make.height.equalTo(self.mas_height).multipliedBy(.25);
            
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(self.leftButton.mas_height);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.width.equalTo(self.leftButton.mas_width);
            
        }];
    }
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroungView = [[UIView alloc]init];
    backgroungView.backgroundColor = RGBAlphaColor(79, 79, 79, 0.5);
    [keyWindow addSubview:backgroungView];
    self.backgroungView = backgroungView;
    
    [backgroungView addSubview:self];
    
    [backgroungView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(keyWindow.mas_width);
        make.height.equalTo(keyWindow.mas_height);
        make.top.equalTo(keyWindow.mas_top);
        make.left.equalTo(keyWindow.mas_left);
        
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroungView.mas_centerX);
        make.centerY.equalTo(backgroungView.mas_centerY).offset(-30);
        make.height.equalTo(backgroungView.mas_height).multipliedBy(.32);
        make.width.equalTo(backgroungView.mas_width).multipliedBy(.8);
    }];

}

-(void)removeView
{
    [self removeFromSuperview];
}

-(void)setTitleImgName:(NSString *)titleImgName
{
    _titleImgName = titleImgName;
    self.titleImgView.image = [UIImage imageNamed:titleImgName];
}
-(void)setFirstTitle:(NSString *)firsttitle
{
    _firstTitle = firsttitle;
    self.firstTitleLabel.text = firsttitle;
}
-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:_title];
    NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent       = 15;
    style.headIndent                = 15;//头部缩进，相当于左padding
    style.tailIndent                = -15;//相当于右padding
    style.lineHeightMultiple        = 1.2;//行间距是多少倍
    style.alignment                 = NSTextAlignmentCenter;//对齐方式
    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,_title.length)];
    
    
    self.titleLabel.attributedText = str;

}

-(void)setLeftButtonTitle:(NSString *)leftButtonTitle
{
    _leftButtonTitle = [leftButtonTitle copy];
    
    [self.leftButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
    
}

-(void)setRightButtonTitle:(NSString *)rightButtonTitle
{
    _rightButtonTitle = [rightButtonTitle copy];
    [self.rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
}

@end
