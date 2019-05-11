//
//  YMAudioPlay.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/8/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAudioPlay : NSObject

+ (instancetype)shareInstance;
+ (void)playAudio:(NSString *)str;
@end
