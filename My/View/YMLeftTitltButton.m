//
//  YMLeftTitltButton.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMLeftTitltButton.h"

@interface YMLeftTitltButton ()
@property (nonatomic, weak) UILabel *subTitleLabel;
@end

@implementation YMLeftTitltButton


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfMutableSize:13];
        
        UILabel *subTitleLabel  = [[UILabel alloc]init];
        subTitleLabel.textColor = FONTCOLOR;
        subTitleLabel.font      = [UIFont systemFontOfMutableSize:11];
        [self addSubview:subTitleLabel];
        self.subTitleLabel = subTitleLabel;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.x = 0;
    self.imageView.centerY = self.height/2;

    self.titleLabel.y = self.imageView.y;
    self.titleLabel.x = self.imageView.width + LEFTSPACE;
    
    self.subTitleLabel.y = self.imageView.bottom - self.subTitleLabel.height;
    self.subTitleLabel.x = self.imageView.width + LEFTSPACE;
}

-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = [subTitle copy];
    
    self.subTitleLabel.text = _subTitle;
    [self.subTitleLabel sizeToFit];
}

@end
