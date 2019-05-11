//
//  YMPopMenuButton.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/12.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPopMenuButton.h"

@implementation YMPopMenuButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfMutableSize:12];
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self setTitleColor:FONTCOLOR forState:UIControlStateNormal];
    }
    return self;
}
@end
