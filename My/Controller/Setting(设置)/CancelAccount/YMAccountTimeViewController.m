//
//  YMAccountTimeViewController.m
//  WSYMPay
//
//  Created by jey on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMAccountTimeViewController.h"

@interface YMAccountTimeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSIndexPath *indexPath;
@end

@implementation YMAccountTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}
-(void)setupTableView
{
    self.title = @"解锁设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
    NSInteger index  = [[USER_DEFAULT objectForKey:@"indexPathrow"] intValue];
    self.indexPath = [NSIndexPath indexPathForRow:index inSection:0];

  
        

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"YMPayBalanceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.size = CGSizeMake(13, 13);
    cell.textLabel.text = @[@"无需保护",@"启动有名钱包",@"进入财富、我的"][indexPath.row];
    
    if (indexPath == self.indexPath) {
        cell.imageView.image = [UIImage imageNamed:@"bill_select"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"bill_unselect"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:_indexPath];
    celled.imageView.image = [UIImage imageNamed:@"bill_unselect"];
    //记录当前选中的位置
    _indexPath = indexPath;
    //当前选择的打勾
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"bill_select"];
    
    
    NSString *intstr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    [USER_DEFAULT setObject:intstr forKey:@"indexPathrow"];

    
  
    
}
#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 46;
    }
    return _tableView;
}





@end
