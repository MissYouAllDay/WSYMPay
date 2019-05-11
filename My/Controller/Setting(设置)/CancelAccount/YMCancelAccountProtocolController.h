//
//  YMCancelAccountProtocolController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

/**
 我的--设置--安全管理--注销账户界面
 
 已实名与未实名都在这一个类中判断
 
 changed by pzj 2017/3/17
 */
#import <UIKit/UIKit.h>

@class YMResponseModel;

@interface YMCancelAccountProtocolController : UIViewController

@property (nonatomic, strong) YMResponseModel *model;

@end
