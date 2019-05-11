//
//  YMTransferTool.h
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转账服务首界面对应的Tool（点击转账服务进入的界面）
 */
#import <Foundation/Foundation.h>

@class YMTransferRecentRecodeDataListModel;

@protocol YMTransferToolDelegate <NSObject>
/**
 点击转到有名钱包账户/转到银行卡 cell 触发的事件
 
 @param row 区分点击的那一行
 */
- (void)selectLocalMethod:(NSInteger)row;

/**
 点击最近的转账用户对应的cell
 
 @param model 点击行所对应的model信息
 */
- (void)selectRecentlyMethod:(YMTransferRecentRecodeDataListModel *)model;

@end


@interface YMTransferTool : NSObject<UITableViewDelegate,UITableViewDataSource,YMTransferToolDelegate>

- (instancetype)initWithTableView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, weak)id<YMTransferToolDelegate>delegate;

@end
