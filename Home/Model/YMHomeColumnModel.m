//
//  YMHomeColumnModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/7.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHomeColumnModel.h"

#define column  2


@implementation YMHomeColumnModel

-(void)setImageArray:(NSArray *)imageArray
{
    _imageArray        = imageArray;
    int row            = (int)(_imageArray.count + column - 1) / column;
    self.cellHeight    = COLUMNHEIGHT * row + SCALEZOOM(38);
    self.titleColorStr = [NSString stringWithFormat:@"home_标题色块%d",arc4random_uniform(2) + 1];
}

@end
