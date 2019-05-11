//
//  YMPopMenu.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPopMenu.h"
#import "UIView+Extension.h"
#import "YMPopMenuButton.h"
@interface YMPopMenu ()

@property (nonatomic, weak) UIImageView     *bgImageView;

@property (nonatomic, weak) YMPopMenuButton *firstButton;

@property (nonatomic, weak) YMPopMenuButton *secondButton;

@property (nonatomic, weak) YMPopMenuButton *thirdButton;

@property (nonatomic, weak) UIView          *firstLineView;

@property (nonatomic, weak) UIView          *secondLineView;

@end

@implementation YMPopMenu

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupSubviews];
        
        self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.6);
    }
    return self;
}


-(void)setupSubviews
{
    UIImageView *bgImageView    = [[UIImageView alloc]init];
    bgImageView.image           = [UIImage imageNamed:@"popuppanels"];
    bgImageView.userInteractionEnabled = YES;
    [self addSubview:bgImageView];
    _bgImageView = bgImageView;
    
    YMPopMenuButton *firstButton = [[YMPopMenuButton alloc]init];
    [firstButton setTitle:@"全部" forState:UIControlStateNormal];
    [firstButton setImage:[UIImage imageNamed:@"all"] forState:UIControlStateNormal];
    firstButton.tag = 0;
    [firstButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:firstButton];
    self.firstButton = firstButton;

    YMPopMenuButton *secondButton = [[YMPopMenuButton alloc]init];
    [secondButton setTitle:@"收入" forState:UIControlStateNormal];
    [secondButton setImage:[UIImage imageNamed:@"income"] forState:UIControlStateNormal];
    secondButton.tag = 1;
    [secondButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:secondButton];
    self.secondButton = secondButton;
    
    YMPopMenuButton *thirdButton = [[YMPopMenuButton alloc]init];
    [thirdButton setTitle:@"支出" forState:UIControlStateNormal];
    [thirdButton setImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
    thirdButton.tag = 2;
    [thirdButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:thirdButton];
    self.thirdButton = thirdButton;
    
    UIView *l1 = [[UIView alloc]init];
    l1.backgroundColor = FONTCOLOR;
    l1.alpha           = 0.4;
    [bgImageView addSubview:l1];
    self.firstLineView = l1;
    
    UIView *l2 = [[UIView alloc]init];
    l2.alpha           = 0.4;
    l2.backgroundColor = FONTCOLOR;
    [bgImageView addSubview:l2];
    self.secondLineView = l2;
    
}

-(void)showInRect:(CGRect)rect
{
    self.frame = KEYWINDOW.bounds;
    [KEYWINDOW addSubview:self];
    
    _bgImageView.width  = SCREENWIDTH * 0.21;
    _bgImageView.height = SCREENHEIGHT * 0.16;
    _bgImageView.y      = 44 + rect.size.height * 1.5;
    _bgImageView.x      = SCREENWIDTH - _bgImageView.width - rect.size.width/ 2;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _firstButton.width   = _bgImageView.width;
    _firstButton.height  = (_bgImageView.height - 5)/ 3 - 1;
    _firstButton.x       = 0;
    _firstButton.y       = 5;
    
    _firstLineView.width  = _bgImageView.width *0.8;
    _firstLineView.height = 1;
    _firstLineView.y      = _firstButton.bottom;
    _firstLineView.centerX  = _firstButton.width * 0.5;
    
    _secondButton.width   = _bgImageView.width;
    _secondButton.height  = (_bgImageView.height - 5)/ 3 - 1;
    _secondButton.x       = 0;
    _secondButton.y       = _firstLineView.bottom;
    
    _secondLineView.width  = _bgImageView.width *0.8;
    _secondLineView.height = 1;
    _secondLineView.y      = _secondButton.bottom;
    _secondLineView.centerX  = _firstButton.width * 0.5;
    
    _thirdButton.width   = _bgImageView.width;
    _thirdButton.height  = (_bgImageView.height - 5)/ 3 - 1;
    _thirdButton.x       = 0;
    _thirdButton.y       = _secondLineView.bottom;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

-(void)buttonClick:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(popMenu:clickedButtonAtIndex:)]) {
        
        [self.delegate popMenu:self clickedButtonAtIndex:button.tag];
    }
    
    [self removeFromSuperview];
}

@end
