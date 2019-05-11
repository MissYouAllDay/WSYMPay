//
//  YMQueryRecordViewController.m
//  WSYMPay
//
//  Created by PengCheng on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMQueryRecordViewController.h"

#define XY_LAZY(object, assignment) (object = object?:assignment)

@interface YMQueryRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;
@end

@implementation YMQueryRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"自定义查询";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    _dataSource = @[@{@"title":@"开始时间",@"detail":self.startLabel},@{@"title":@"结束时间",@"detail":self.endLabel}];
    [self initWithQueryView];
}
- (void)initWithQueryView{
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.queryButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setBackgroundColor:VIEWGRAYCOLOR];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLINDIFITERONE = @"CELLINDIFITERONE";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLINDIFITERONE];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLINDIFITERONE];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [self.dataSource[indexPath.row] valueForKey:@"title"];
    [cell addSubview:[self.dataSource[indexPath.row] valueForKey:@"detail"]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    view.backgroundColor = VIEWGRAYCOLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 40)];
    label.text = @"目前仅支持开始时间起30内的查询";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [CGXPickerView showDatePickerWithTitle:@"开始时间" DateType:UIDatePickerModeDateAndTime DefaultSelValue:nil MinDateStr:[self getCurrentDateAndTime:@"yy-MM-dd HH:mm:ss"] MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            weakSelf.startLabel.text = selectValue;
            weakSelf.startLabel.textColor = [UIColor blackColor];
        }];
    }
    else{
        [CGXPickerView showDatePickerWithTitle:@"结束时间" DateType:UIDatePickerModeDateAndTime DefaultSelValue:nil MinDateStr:[self getCurrentDateAndTime:@"yy-MM-dd HH:mm:ss"] MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            weakSelf.endLabel.text = selectValue;
            weakSelf.endLabel.textColor = [UIColor blackColor];
        }];
    }
}
- (UILabel *)startLabel{
    return XY_LAZY(_startLabel, ({
        UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, SCREENWIDTH-130, 50)];
        startLabel.textColor = [UIColor grayColor];
        startLabel.font = [UIFont systemFontOfSize:15];
        startLabel.textAlignment = NSTextAlignmentCenter;
        startLabel.text = @"请选择开始时间";
        startLabel;
    }));
}
- (UILabel *)endLabel{
    return XY_LAZY(_endLabel, ({
        UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, SCREENWIDTH-130, 50)];
        endLabel.textColor = [UIColor grayColor];
        endLabel.font = [UIFont systemFontOfSize:15];
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.text = @"请选择结束时间";
        endLabel;
    }));
}
- (UIView *)footerView{
    if (_footerView==nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
        _footerView.backgroundColor = VIEWGRAYCOLOR;
    }
    return _footerView;
}
- (UIButton *)queryButton{
    if (_queryButton==nil) {
        _queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_queryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_queryButton setBackgroundColor:[UIColor whiteColor]];
        _queryButton.layer.cornerRadius = 8;
        _queryButton.layer.masksToBounds = YES;
        _queryButton.frame = CGRectMake(20, 25, SCREENWIDTH-40, 45);
        [_queryButton addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryButton;
}
- (void)queryAction{
    if (self.queryDateBlock) {
        self.queryDateBlock(self.startLabel.text, self.endLabel.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -当前时间 yyyy-MM-dd HH:mm:ss
- (NSString *)getCurrentDateAndTime:(NSString *)type{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    return destDateString;
}
@end
