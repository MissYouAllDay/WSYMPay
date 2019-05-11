//
//  YMMonthModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMMonthModel : NSObject
@property (nonatomic, copy) NSString *month;
@property (nonatomic, strong) NSMutableArray *billList;

+(NSArray *)getHaveMonthTitleArray:(NSArray *)array;
@end
