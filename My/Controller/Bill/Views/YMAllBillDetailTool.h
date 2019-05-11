//
//  YMAllBillDetailTool.h
//  WSYMPay
//
//  Created by pzj on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 账单详情界面 Tool
 BillDetailConsumeMobilePhoneRecharge         = 0,//消费---手机话费充值
 BillDetailConsumeScan                        = 1,//消费---扫一扫超级收款码
 BillDetailPCScan                             = 1,//扫一扫pc端生成的二维码
 BillDetailTX                                 = 1,//TX
 BillDetailAccountTransfer                    = 2,//转账(我要收款/ 扫一扫有名收款码)
 */

#import <Foundation/Foundation.h>
#import "YMAllBillDetailVC.h"

@class YMAllBillDetailDataModel;

@protocol YMAllBillDetailToolDelegate <NSObject>

- (void)selectComplaintsMethod;

@end

@interface YMAllBillDetailTool : NSObject<UITableViewDelegate,UITableViewDataSource,YMAllBillDetailToolDelegate>

- (instancetype)initWithTableView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (assign,nonatomic,readwrite) BillDetailType billDetailType;
@property (nonatomic, strong) YMAllBillDetailDataModel *detailDataModel;

@property (nonatomic, weak) id<YMAllBillDetailToolDelegate>delegate;

@end
