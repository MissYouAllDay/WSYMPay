//
//  YMBaseDB.h
//  WSYMPay
//
//  Created by pzj on 2017/3/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 存数据库 baseModel
 * 所有要做数据库存储的都要继承自这个类
 */
#import <Foundation/Foundation.h>
#import "LKDBHelper.h"

@interface YMBaseDB : NSObject

@end

@interface NSObject(PrintSQL)
+(NSString*)getCreateTableSQL;//可写可不写 这个是根据demo上写的
@end
