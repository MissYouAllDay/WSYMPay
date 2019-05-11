//
//  ObtainUserIDFVTool.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObtainUserIDFVTool : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

+ (NSString *)getIDFV;
@end
