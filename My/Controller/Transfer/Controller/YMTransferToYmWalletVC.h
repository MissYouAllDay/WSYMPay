//
//  YMTransferToYmWalletVC.h
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

/**
 * 有名钱包账户界面vc（转账界面 点击转到有名钱包账户cell 进入的界面）
 （ 里面有调起通讯录的功能）
 */
#import <UIKit/UIKit.h>
@class YMTransferCheckAccountDataModel;

@interface YMTransferToYmWalletVC : UITableViewController
@property (nonatomic, strong) NSString *accountString;
@property (nonatomic, copy) NSString *paymentDate;//0：实时到账 1：次日到账


@end
