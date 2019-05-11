//
//  CustomButton.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/28.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMFullTitleButton.h"

@implementation YMFullTitleButton

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

@end
