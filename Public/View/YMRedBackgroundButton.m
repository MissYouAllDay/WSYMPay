//
//  YMRedBackgroundButton.m
//  WSYMPay
//
//  Created by W-Duxin on 16/11/16.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMRedBackgroundButton.h"

@implementation YMRedBackgroundButton



- (instancetype)init
{
    self = [super init];
    if (self) {
        
         self.titleLabel.font     = COMMON_FONT;
         self.layer.cornerRadius  = CORNERRADIUS;
        self.layer.masksToBounds = YES;
        [self setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"register_available"] forState:UIControlStateNormal];
        [self setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"register"] forState:UIControlStateDisabled];
        [self setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
        [self setTitleColor:FONTCOLOR forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return self;
}

@end
