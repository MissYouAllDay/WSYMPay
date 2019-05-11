//
//  YMAllBillComplaintVC.h
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 订单投诉界面
 */
#import <UIKit/UIKit.h>
#import "YMAllBillDetailVC.h"

@class YMAllBillDetailDataModel;
@class YMAllBillListDataListModel;
@interface YMAllBillComplaintVC : UIViewController

@property (assign,nonatomic,readwrite) BillDetailType billDetailType;
@property (nonatomic, strong) YMAllBillDetailDataModel *detailDataModel;
@property (nonatomic, copy) NSString *tranType;//类型


@end
