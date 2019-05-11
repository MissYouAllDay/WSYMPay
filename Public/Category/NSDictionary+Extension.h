//
//  NSDictionary+Extension.h
//  WSYMPay
//
//  Created by W-Duxin on 16/11/1.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+(NSDictionary *)attributesForUserTextWithlineHeightMultiple:(CGFloat)multiple;
@end
