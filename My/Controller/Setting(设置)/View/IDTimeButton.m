//
//  IDTimeButton.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "IDTimeButton.h"

@implementation IDTimeButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIFont * font = nil;
        if (SCREENWIDTH == 320) {
            
            font = [UIFont systemFontOfSize:11];
            
        } else if (SCREENWIDTH == 375) {
        
            font = [UIFont systemFontOfSize:13];
        } else {
        
            font = [UIFont systemFontOfSize:16];
        
        }
        
        self.titleLabel.font = font;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = self.imageView.frame.size.height;
    CGFloat width  = self.bounds.size.width;
    self.imageView.frame  = CGRectMake(0, (self.bounds.size.height - height)/2, height, height);
    self.titleLabel.frame = CGRectMake(height +5, (self.bounds.size.height - height)/2, width - (height + 5), height);
    
}

@end
