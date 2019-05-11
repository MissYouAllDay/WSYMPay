//
//  UIImage+QRCode.h
//  QrCodeDemo
//
//  Created by pzj on 2017/4/11.
//  Copyright © 2017年 pzj. All rights reserved.
//


/*
 * 生成二维码
 */
#import <UIKit/UIKit.h>

@interface UIImage (QRCode)

+ (UIImage *)qrImageByContent:(NSString *)content;

//pre
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size;


@end
