//
//  YMTransferMoneyLimitTool.h
//  WSYMPay
//
//  Created by pzj on 2017/5/3.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 限额说明界面Tool (转账到银行卡的限额说明页)
 */
#import <Foundation/Foundation.h>

@interface YMTransferMoneyLimitTool : NSObject<UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithTableView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
