//
//  YMCardButton.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/29.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCardButton.h"
#import "UIView+Extension.h"

@implementation YMCardButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitleColor:FONTDARKCOLOR forState:UIControlStateNormal];
        self.titleLabel.font             = [UIFont systemFontOfMutableSize:13];
        self.titleLabel.textAlignment    = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.y        = self.height/2 - self.imageView.height;
    self.imageView.centerX  = self.width / 2;
    
    self.titleLabel.centerX = self.width/2;
    self.titleLabel.y       = self.height/2 + (self.height/2 - self.titleLabel.height)/2;
    
}

@end
