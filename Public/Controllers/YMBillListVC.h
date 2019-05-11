//
//  YMBillListVC.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMPopMenu,YMBillDetailsCell;
@interface YMBillListVC : UITableViewController
-(NSString *)getHeaderStr:(NSInteger)section;
@end
