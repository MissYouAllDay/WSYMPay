//
//  YMRevokeOrConfirmDataModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMRevokeOrConfirmDataModel : NSObject

@property (nonatomic, copy) NSString *acceptState;//0未投诉  3已确认

-(NSString *)getStateStr;

@end
