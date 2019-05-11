//
//  YMCollectionVC.m
//  WSYMPay
//
//  Created by pzj on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCollectionVC.h"
#import "YMCollectionView.h"
#import "YMAllBillListVC.h"
#import "YMUserInfoTool.h"
#import "YMHomeHttpRequestApi.h"
#import "YMCollectionBaseListModel.h"
#import "YMAllBillDetailVC.h"
#import "SettingAmountVC.h"
#import "YMCollectionRecordViewController.h"
@interface YMCollectionVC ()<YMCollectionViewDelegate>
@property (nonatomic, strong) YMCollectionView *collectView;
@end

@implementation YMCollectionVC
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.getNavigationImageView.hidden= YES;
    [self initView];
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.getNavigationImageView.hidden= NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
- (void)initView
{
    self.view.backgroundColor = NAVIGATIONBARCOLOR;
    self.title = @"收款码";
    [self.view addSubview:self.collectView];
    //生成的二维码“WSYMSK”+“userID”
    self.collectView.userIdStr = self.collMoney.length>0?[NSString stringWithFormat:@"WSYMSK%@k_amount%@",[YMUserInfoTool shareInstance].userID, self.collMoney]:[NSString stringWithFormat:@"WSYMSK%@",[YMUserInfoTool shareInstance].userID];
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self setNavigationItem];
}
-(void)setNavigationItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" highImage:@"back" title:nil target:self action:@selector(backBtnTouchUp)];
}
- (void)backBtnTouchUp
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)loadData
{
//    WEAK_SELF;
//    [YMHomeHttpRequestApi loadHttpRequestWithCollectionSuccess:^(NSMutableArray *array) {
//        weakSelf.collectView.dataArray = array;
//    }];
}
#pragma mark - eventResponse                - Method -
- (void)rightBtnClick:(UIBarButtonItem *)btn
{
    YMLog(@"交易记录");
}
#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectRecordBtn{
    YMCollectionRecordViewController *vc = [[YMCollectionRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)didsetAmountAction {
    SettingAmountVC *amountVC=[SettingAmountVC new];
    amountVC.settingAmountBlock = ^(NSString * amount) {
        self.collectView.lblA.text=[NSString stringWithFormat:@"¥%@",amount];
        self.collMoney = amount;
    };
    [self.navigationController pushViewController:amountVC animated:YES];
    
}
#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -

- (YMCollectionView *)collectView
{
    if (!_collectView) {
        _collectView = [[YMCollectionView alloc] init];
        _collectView.delegate = self;
    }
    return _collectView;
}

@end
