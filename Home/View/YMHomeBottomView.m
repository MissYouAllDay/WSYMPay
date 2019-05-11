//
//  YMHomeBottomView.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHomeBottomView.h"
#import "YMCardButton.h"
@interface YMHomeBottomView ()
@end

@implementation YMHomeBottomView

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
    
    NSArray *columnsArray = @[
                              @{@"titleName":@"转账",@"imageName":@"home_转账"},
                              @{@"titleName":@"银行卡",@"imageName":@"home_信用卡还款"},
                              @{@"titleName":@"手机充值",@"imageName":@"home_手机充值"},
                              @{@"titleName":@"便民缴费",@"imageName":@"home_便民缴费"},
                              @{@"titleName":@"旅游票务",@"imageName":@"home_旅游票务"},
                              @{@"titleName":@"全部",@"imageName":@"home_全部"}];
    for (int i = 0; i<columnsArray.count; i++) {
        NSDictionary *dic      = columnsArray[i];
        YMCardButton *titleBtn = [[YMCardButton alloc]init];
        titleBtn.tag           = i;
        [titleBtn setTitle:dic[@"titleName"] forState:UIControlStateNormal];
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"mineback"] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:dic[@"imageName"]] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(titleBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleBtn];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnW = self.width / 3;
    CGFloat btnH = self.height / 2;
    
    for (int i = 0; i<self.subviews.count; i++) {
        
        YMCardButton *btn = self.subviews[i];
        btn.height        = btnH;
        btn.width         = btnW;
        btn.x             = (i % 3) * btnW;
        btn.y             = (i / 3) * btnH;
    }
}

-(void)titleBtnDidClick:(UIButton *)btn{
    if (self.clickItemBlock) {
        self.clickItemBlock(btn.tag);
    }
    
    if ([self.delegate respondsToSelector:@selector(bottomView:itemDidClick:)]) {
        [self.delegate bottomView:self itemDidClick:btn.tag];
    }
}

@end
