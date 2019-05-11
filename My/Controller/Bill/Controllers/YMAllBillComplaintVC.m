//
//  YMAllBillComplaintVC.m
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillComplaintVC.h"
#import "YMAllBillDetailHeadView.h"
#import "YMBillComplainTextViewCell.h"
#import "YMAllBillDetailFootView.h"
#import "YMAllBillDetailVC.h"
#import "YMAllBillDetailDataModel.h"
#import "YMAllBillListDataListModel.h"
#import "YMMyHttpRequestApi.h"
#import "RequestModel.h"

@interface YMAllBillComplaintVC ()<UITableViewDelegate,UITableViewDataSource,YMAllBillDetailFootViewDelegate,YMBillComplainTextViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *reasonStr;
@property (nonatomic, strong) YMAllBillDetailFootView *footView;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation YMAllBillComplaintVC
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
- (void)initView
{
    self.title = @"订单疑问反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 33)];
    self.tableView.tableHeaderView = headerView;
    UILabel * conLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, SCREENWIDTH-34, 33)];
    conLbl.text = @"请补充详细问题和意见";
    conLbl.textColor = UIColorFromHex(0x9e9e9e);
    conLbl.textAlignment = NSTextAlignmentLeft;
    conLbl.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:conLbl];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 114)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    footerView.userInteractionEnabled = YES;
    
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(12, 64, SCREENWIDTH-24, 48)];
    _btn.backgroundColor = UIColorFromHex(0xd4d4d4);
    [_btn setTitle:@"提交" forState:UIControlStateNormal];
    [_btn setTitleColor:UIColorFromHex(0x737373)  forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:15];
    _btn.layer.cornerRadius = 5.f;
    _btn.enabled = NO;
    [_btn.layer setMasksToBounds:YES];
    [_btn addTarget:self action:@selector(selectComplaintsBtnMethod) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:_btn];
    
}
- (void)loadData
{
    RequestModel *params = [[RequestModel alloc] init];
    // // （1消费2手机充值3充值4转账5提现）
    //（1消费2账户充值3提现4转账5手机充值） 最新的文档中
    if ([self.tranType isEqualToString:@"1"]||[self.tranType isEqualToString:@"5"]) {
         params.prdOrdNo = [self.detailDataModel getPrdOrdNoStr];
    }else if ([self.tranType isEqualToString:@"2"]){
        params.prdOrdNo = [self.detailDataModel getAccountChonZhiDanHaoStr];
    }else if ([self.tranType isEqualToString:@"4"]){
        params.prdOrdNo = [self.detailDataModel getTraOrdNoStr];
    }else if ([self.tranType isEqualToString:@"3"]){
        params.prdOrdNo = [self.detailDataModel getAccountCasOrdNoStr];
    }
    params.comRemark = self.reasonStr;
    params.tranTypeSel = self.tranType;
    [YMMyHttpRequestApi loadHttpRequestWithApplyComplaintParams:params success:^() {//投诉成功
        [self.navigationController popViewControllerAnimated:NO];
    }];
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectInputReasonStr:(NSString *)str
{
    self.reasonStr = str;
    if (self.reasonStr.length > 10) {
        _btn.enabled = YES;
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"register_available"]forState:UIControlStateNormal];
    }
}
- (void)selectComplaintsBtnMethod
{
    YMLog(@"提交。。。");
    if (self.reasonStr.length>0) {
        [self loadData];
    }else{
        [MBProgressHUD showText:@"请说明投诉原因"];
    }
}

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YMBillComplainTextViewCell";
    YMBillComplainTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YMBillComplainTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 272;
}

#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)setBillDetailType:(BillDetailType)billDetailType
{
    _billDetailType = billDetailType;
    [self.tableView reloadData];
}
- (void)setDetailDataModel:(YMAllBillDetailDataModel *)detailDataModel
{
    _detailDataModel = detailDataModel;
    if (_detailDataModel == nil) {
        return;
    }
    [self.tableView reloadData];
}
- (void)setTranType:(NSString *)tranType
{
    _tranType = tranType;
    [self.tableView reloadData];
}
@end
