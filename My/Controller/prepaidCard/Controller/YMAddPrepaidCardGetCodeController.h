//
//  YMAddPrepaidCardGetCodeController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/5.
//  Copyright © 2016年 赢联. All rights reserved.
//

/**
 添加预付卡 验证码 界面（我的--预付卡--有名预付卡界面--我的预付卡界面--添加预付卡--下一步）
 changed by pzj 2017-3-20
 */
#import "YMAddGetVCodeController.h"

@class YMResponseModel;

@interface YMAddPrepaidCardGetCodeController : YMAddGetVCodeController

@property (nonatomic, copy) NSString *prepaidNoStr;
@property (nonatomic, copy) NSString *usrMpStr;
@property (nonatomic, strong) YMResponseModel *responseModel;

@end
