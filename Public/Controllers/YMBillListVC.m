//
//  YMBillListVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBillListVC.h"
#import "YMBillDetailsCell.h"
#import "YMMyHttpRequestApi.h"

@interface YMBillListVC ()
@end

@implementation YMBillListVC

#pragma mark - getters and setters          - Method -

#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
}

-(NSString *)getHeaderStr:(NSInteger)section{
    return nil;
}

- (YMBillDetailsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView         = [[UIView alloc] init];
    myView.backgroundColor = RGBColor(242, 242, 242);
    UILabel *titleLabel    = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE / 2, 0, SCREENWIDTH, HEADERSECTION_HEIGHT)];
    titleLabel.textColor   =RGBColor(157, 157, 157);
    titleLabel.font        = [UIFont systemFontOfMutableSize:12];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self getHeaderStr:section];
    [myView addSubview:titleLabel];
    return myView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREENHEIGHT * 0.15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
