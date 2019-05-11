//
//  YMDetailsVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMDetailsVC.h"
#import "YMMoneyView.h"
#import "YMGetUserInputCell.h"
#import "YMRedBackgroundButton.h"
@interface YMDetailsVC ()

@end

@implementation YMDetailsVC

-(YMRedBackgroundButton *)nextBtn
{
    if (!_nextBtn) {
        
        //注册按钮
        YMRedBackgroundButton*nextBtn = [[YMRedBackgroundButton alloc]init];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:nextBtn];
        _nextBtn = nextBtn;
    }
    
    return _nextBtn;
}

#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

#pragma mark - privateMethods               - Method -
- (void)setupSubviews
{
    self.tableView.tableHeaderView = [self moneyView];
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
}


#pragma mark - objective-cDelegate          - Method -（Table view data source）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
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

- (YMMoneyView *)moneyView
{
    if (!_moneyView) {
        _moneyView                 = [[YMMoneyView alloc]init];
        _moneyView.backgroundColor = [UIColor whiteColor];
        _moneyView.frame           = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.17);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _moneyView.frame.size.height-1, SCREENWIDTH, 1)];
        lineView.backgroundColor = lINECOLOR;
        [_moneyView addSubview:lineView];
    }
    return _moneyView;
}

-(void)nextBtnClick
{
}

@end
