//
//  YMCheckUpdateModel.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/26.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBaseResponseModel.h"

@interface YMCheckUpdateModel : YMBaseResponseModel
@property (nonatomic, copy)NSString    *oldVersion;
@property (nonatomic, copy)NSString    *ymqb_ver_ios;
@property (nonatomic, copy)NSString    *ymqbURL_ios;
@property (nonatomic, assign)NSInteger ymqbVerStatus; //是否强制更新 1 Yes 2NO
@property (nonatomic, assign)BOOL      haveNewUpdate;
@property (nonatomic, copy)NSString   *lastShowTime;//最后提示更新的时间
@property (nonatomic, assign) BOOL    isShow;//是否需要提示更新

/**
  新版本
 */
+(void)checkUpdate;

/**
 是否第一次运行新版本
 */
+(BOOL)isNewVersion;

@end
