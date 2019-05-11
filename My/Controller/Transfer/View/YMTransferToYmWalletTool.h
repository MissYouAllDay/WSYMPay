//
//  YMTransferToYmWalletTool.h
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 有名钱包账户界面Tool（转账界面 点击转到有名钱包账户cell 进入的界面）
 */
#import <Foundation/Foundation.h>

@protocol YMTransferToYmWalletToolDelegate <NSObject>
/**
 下一步按钮
 @param account 有名钱包账号/手机号
 @param type 到账方式
 */
- (void)selectNextSearchAccount:(NSString *)account withType:(NSString *)type;
/**
 提示
 */
- (void)tipOfDefraudAction;
@end

@interface YMTransferToYmWalletTool : NSObject<UITableViewDelegate,UITableViewDataSource,YMTransferToYmWalletToolDelegate>

- (instancetype)initWithTableView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableViewController *vc;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *accountString;
@property (nonatomic, weak) UITextField *countTextField;

@property (nonatomic, weak) id<YMTransferToYmWalletToolDelegate>delegate;

@end
