//
//  YMLocationTool.h
//  WSYMPay
//
//  Created by W-Duxin on 16/10/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^LocationBlcok)(NSString *location,NSString *latitude,NSString *longitude);

typedef void(^ErrorBlock)(NSString *error);

@interface YMLocationTool : NSObject


+(instancetype)sharedInstance;

/**
 *  开始准确的定位
 *
 *  @param location  当前位置
 *  @param latitude  纬度
 *  @param longitude 精度
 */
-(void)startLocationWithFineLocation:(LocationBlcok)location
                         locationError:(ErrorBlock)error;

/**
 *  开始的定位block方法
 *
 *  @param location 当前位置
 */
-(void)startLocationWithCurrentLocation:(LocationBlcok)location
                          locationError:(ErrorBlock)error;;
@end
