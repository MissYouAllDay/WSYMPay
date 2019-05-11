//
//  YMHomeColumnButton.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/7.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHomeColumnButton.h"

@implementation YMHomeColumnButton

-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = [imageUrl copy];
    if ([imageUrl  containsString:@"http"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE]];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE]];
        
    }else
    {
        [self setBackgroundImage:[UIImage stretchableImage:imageUrl] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage stretchableImage:imageUrl] forState:UIControlStateHighlighted];
    }
    

//    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:_imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_3-1.png"]];
//    [self sd_setBackgroundImageWithURL:[NSURL URLWithString:_imageUrl] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"home_3-1.png"]];
}

@end
