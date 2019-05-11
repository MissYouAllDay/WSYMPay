//
//  YMSearchView.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMSearchView.h"

@interface YMSearchView ()

@property (nonatomic, weak) UIView *columnView;

@end

@implementation YMSearchView

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
    self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.6);
    
    UIView *columnView = [[UIView alloc]init];
    columnView.backgroundColor = RGBColor(223, 223, 223);
    [self addSubview:columnView];
    self.columnView = columnView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.columnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.equalTo(self).multipliedBy(.27);
        make.width.equalTo(self);
        
    }];
}

-(void)setColumns:(NSArray *)columns
{
    _columns = columns;
    CGFloat btnH = 30;
    CGFloat btnW = SCREENWIDTH / 4;
    for (int i = 0; i < _columns.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        [btn setTitle:_columns[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(83, 83, 83) forState:UIControlStateNormal];
        btn.titleLabel.font = COMMON_FONT;
        [btn addTarget:self action:@selector(columnBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.columnView addSubview:btn];
        btn.width  = btnW;
        btn.height = btnH;
        btn.x = (i % 4) * btn.width;
        btn.y = (int)(i / 4) * btn.height + LEFTSPACE/2;
    }
}

-(void)columnBtnDidClick:(UIButton *)btn
{
    if (self.columnBtnClick) {
        self.columnBtnClick(btn.tag);
    }
    
}

-(void)show
{
    self.alpha  = 1;
    self.x      = 0;
    self.y      = 64;
    self.height = SCREENHEIGHT - 64;
    self.width  = SCREENWIDTH;
    [KEYWINDOW addSubview:self];
}

-(void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.y = SCREENHEIGHT;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
