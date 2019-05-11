//
//  YMTransferToBankCardConfirmTool.h
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转到银行卡确认转账信息界面Tool （转到银行卡界面点击确认转账按钮进入的界面）
 */
#import <Foundation/Foundation.h>

@class YMTransferToBankSearchFeeDataModel;

@protocol YMTransferToBankCardConfirmToolDelegate <NSObject>

- (void)selectSureTransferBtnWithbeiZhuMsg:(NSString *)beiZhuMsg;

@end

@interface YMTransferToBankCardConfirmTool : NSObject<UITableViewDelegate,UITableViewDataSource,YMTransferToBankCardConfirmToolDelegate>

- (instancetype)initWithTableView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMTransferToBankSearchFeeDataModel *dataModel;
@property (nonatomic, weak) id<YMTransferToBankCardConfirmToolDelegate>delegate;

@end
