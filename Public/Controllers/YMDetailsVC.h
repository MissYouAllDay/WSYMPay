//
//  YMDetailsVC.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMMoneyView,YMGetUserInputCell,YMRedBackgroundButton;
@interface YMDetailsVC : UITableViewController
@property (nonatomic, strong) YMMoneyView *moneyView;
@property (nonatomic, strong) YMRedBackgroundButton *nextBtn;
-(void)nextBtnClick;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (YMGetUserInputCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
