//
//  YMRightOfImageButton.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMRightOfImageButton.h"
#import "UIView+Extension.h"
@implementation YMRightOfImageButton

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.x = self.width - self.imageView.width;
    self.imageView.y = 0;
    
    self.titleLabel.x  = self.width - self.titleLabel.width - 5 - self.imageView.width;
    self.titleLabel.y  = 0;
}

@end
