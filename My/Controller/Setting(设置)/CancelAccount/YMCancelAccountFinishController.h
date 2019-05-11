//
//  YMCancelAccountFinishController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

/**
 我的--设置--安全管理--注销账户--已实名用户验证支付密码界面
 注销账户成功界面
 changed by pzj 2017/3/17
 */
#import <UIKit/UIKit.h>

@class YMResponseModel;
@interface YMCancelAccountFinishController : UITableViewController

@property (nonatomic,strong) YMResponseModel *model;

@end
