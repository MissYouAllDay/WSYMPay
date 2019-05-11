//
//  YMHomeColumnModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/7.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMHomeColumnModel : NSObject

@property (nonatomic, copy)  NSString *title;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *urlArray;

@property (nonatomic, assign) CGFloat cellHeight;

/**
 标题色块图片
 */
@property (nonatomic, copy) NSString *titleColorStr;

@end
