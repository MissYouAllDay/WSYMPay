//
//  YMTransferProcessTool.h
//  WSYMPay
//
//  Created by pzj on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 转账结果----处理中Tool
 */
#import <Foundation/Foundation.h>

@class YMTransferCheckPayPwdDataModel;

@protocol YMTransferProcessToolDelegate <NSObject>

- (void)selectCheckDetailBtn;

@end

@interface YMTransferProcessTool : NSObject<UITableViewDelegate,UITableViewDataSource,YMTransferProcessToolDelegate>

- (instancetype)initWithTableView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMTransferCheckPayPwdDataModel *dataModel;
@property (nonatomic, weak) id<YMTransferProcessToolDelegate>delegate;

@end
