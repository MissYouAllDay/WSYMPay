//
//  ImageViewTool.m
//  MasonryDemo
//
//  Created by pzj on 2017/3/6.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "ImageViewTool.h"

@implementation ImageViewTool

/**
 UIImageView 网络图片 不带占位图
 
 @param imageView 展示网络图片的imageView
 @param imageUrl 网络图片的url
 */
+ (void)setImage:(UIImageView *)imageView imageUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    [imageView sd_setImageWithURL:url];
}

/**
 UIImageView 网络图片 带占位图
 
 @param imageView 展示网络图片的imageView
 @param imageUrl 网络图片的url
 @param placeholderImage 占位图
 */
+ (void)setImage:(UIImageView *)imageView imageUrl:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    UIImage *image = [UIImage imageNamed:placeholderImage];
    [imageView sd_setImageWithURL:url placeholderImage:image];
}

/**
 UIButton 网络图片
 
 @param button 展示网络图片的button
 @param imageUrl 网络图片的url
 */
+ (void)setButton:(UIButton *)button imageUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    [button sd_setImageWithURL:url forState:UIControlStateNormal];
}

/**
 UIButton 网络图片
 
 @param button 展示网络图片的button
 @param imageUrl 网络图片的url
 @param placeholderImage 占位图
 */
+ (void)setButton:(UIButton *)button imageUrl:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    UIImage *image = [UIImage imageNamed:placeholderImage];
    [button sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:image];
}


@end
