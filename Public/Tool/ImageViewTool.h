//
//  ImageViewTool.h
//  MasonryDemo
//
//  Created by pzj on 2017/3/6.
//  Copyright © 2017年 pzj. All rights reserved.
//

/**
 * 网络图片处理工具类
 */


/**
 网络图片处理工具类
 加载网络图片通过这个类调用 SDWebImage,
 目的防止SDWebImage使用方法修改，如果修改了直接修改这个类即可，否则需要修改的地方比较多
 */
#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface ImageViewTool : NSObject

/**
 UIImageView 网络图片 不带占位图

 @param imageView 展示网络图片的imageView
 @param imageUrl 网络图片的url
 */
+ (void)setImage:(UIImageView *)imageView imageUrl:(NSString *)imageUrl;

/**
 UIImageView 网络图片 带占位图

 @param imageView 展示网络图片的imageView
 @param imageUrl 网络图片的url
 @param placeholderImage 占位图
 */
+ (void)setImage:(UIImageView *)imageView imageUrl:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage;

/**
 UIButton 网络图片

 @param button 展示网络图片的button
 @param imageUrl 网络图片的url
 */
+ (void)setButton:(UIButton *)button imageUrl:(NSString *)imageUrl;

/**
 UIButton 网络图片

 @param button 展示网络图片的button
 @param imageUrl 网络图片的url
 @param placeholderImage 占位图
 */
+ (void)setButton:(UIButton *)button imageUrl:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage;

@end
