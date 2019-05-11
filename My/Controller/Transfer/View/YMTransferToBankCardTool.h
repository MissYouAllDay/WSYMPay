//
//  YMTransferToBankCardTool.h
//  WSYMPay
//
//  Created by pzj on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转到银行卡界面Tool（转账界面 点击转到银行卡cell 进入的界面）
 */
#import <Foundation/Foundation.h>

@class YMTransferToBankCheckBankDataModel;
@class YMTransferRecentRecodeDataListModel;
@class YMTransferToBankLimitDataModel;

@protocol YMTransferToBankCardToolDelegate <NSObject>
/**
 确认转账
 */
- (void)selectSureTransferBtnName:(NSString *)name bankCard:(NSString *)bankCard money:(NSString *)money;

/**
 限额说明点击事件
 */
- (void)selectLimitBtn;

/**
 验证银行卡
 @param bankAcNo 银行卡号
 */
- (void)checkBankCard:(NSString *)bankAcNo;

@end

@interface YMTransferToBankCardTool : NSObject<UITableViewDelegate,UITableViewDataSource,YMTransferToBankCardToolDelegate>

- (instancetype)initWithTableView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableViewController *vc;
@property (nonatomic, weak) id<YMTransferToBankCardToolDelegate>delegate;

@property (nonatomic, strong) YMTransferToBankCheckBankDataModel *checkBankModel;//验证银行信息model
@property (nonatomic, strong) YMTransferRecentRecodeDataListModel *fromDataListModel;//最近转账记录请求回来的，不为空默认展示出来
@property (nonatomic, strong) YMTransferToBankLimitDataModel *limitDataModel;

@end
