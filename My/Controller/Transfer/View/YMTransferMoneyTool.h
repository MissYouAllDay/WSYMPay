//
//  YMTransferMoneyTool.h
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 有名钱包账户转账界面Tool（转账金额）
 */
#import <Foundation/Foundation.h>

@class YMTransferCheckAccountDataModel;
@class YMBankCardModel;

@protocol YMTransferMoneyToolDelegate <NSObject>

- (void)selectSureTransferBtnWithMoney:(NSString *)money beiZhuMsg:(NSString *)beiZhuMsg;
//更换按钮
- (void)selectPayTypeBtnWithMoneyStr:(NSString *)money;

@end

@interface YMTransferMoneyTool : NSObject<UITableViewDelegate,UITableViewDataSource,YMTransferMoneyToolDelegate>

- (instancetype)initWithTableView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMTransferCheckAccountDataModel *dataModel;
@property (nonatomic, strong) UITableViewController *vc;
@property (nonatomic, weak) id<YMTransferMoneyToolDelegate>delegate;
@property (nonatomic, copy) NSString *payTypeStr;
@property (nonatomic, strong) NSString *scanMoney;
@end
