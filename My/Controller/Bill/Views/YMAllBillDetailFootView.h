//
//  YMAllBillDetailFootView.h
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAllBillDetailVC.h"
@class YMAllBillDetailDataModel;

@protocol YMAllBillDetailFootViewDelegate <NSObject>

- (void)selectComplaintsBtnMethod;

@end

@interface YMAllBillDetailFootView : UIView<YMAllBillDetailFootViewDelegate>

+ (YMAllBillDetailFootView *)instanceView;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, weak) id <YMAllBillDetailFootViewDelegate>delegate;
- (void)sendSelectMoney:(NSString *)money isSelect:(BOOL)isSelect;

- (void)sendBillDetailType:(BillDetailType)billDetailType model:(YMAllBillDetailDataModel *)model;

@end
