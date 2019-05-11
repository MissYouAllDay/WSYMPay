//
//  FeedbackViewController.m
//  WSYMPay
//
//  Created by jey on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "FeedbackViewController.h"
#import "YMBillComplainTextViewCell.h"
@implementation FeedbackModel
@end
@interface FeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,YMBillComplainTextViewCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,copy) NSString *reasonStr;
@property (nonatomic,copy) NSIndexPath *indexPath;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self setupTableView];
    [self loadData];
    
}
-(void)setupTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
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
- (void)selectComplaintsBtnMethod {
    
    
        YMLog(@"提交。。。");
        if (self.reasonStr.length>0) {
            [self loadFeedBack];
        }else{
            [MBProgressHUD showText:@"请说明投诉原因"];
        }
    
}
#pragma mark - 投诉
- (void)loadFeedBack {
    RequestModel *params = [[RequestModel alloc] init];
    FeedbackModel *model = self.datas[self.indexPath.row];
    params.tranCode = @"910100";
    params.token = [YMUserInfoTool shareInstance].token;
    params.backType = model.backType;
    params.backView = self.reasonStr;
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD showText:responseObject[@"resMsg"]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];

    }];
}
- (void)loadData {
    RequestModel *params = [[RequestModel alloc] init];
    params.tranCode = FEEDBACK;
    params.token = [YMUserInfoTool shareInstance].token;
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSArray *dataDict = dict[@"data"][@"list"];
        self.datas = [FeedbackModel mj_objectArrayWithKeyValuesArray:dataDict];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.datas.count : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//余额 当isShowBalance=YES时,才显示余额模块
        
        static NSString *cellID = @"YMPayBalanceCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.datas.count > indexPath.row) {
            FeedbackModel *model = self.datas[indexPath.row];
            cell.textLabel.text = model.backTypeDes;
        }
        if (indexPath == self.indexPath) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
        
    }else {
        
        static NSString *cellID = @"YMBillComplainTextViewCell";
        YMBillComplainTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMBillComplainTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.delegate = self;
        }
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *celled = [tableView cellForRowAtIndexPath:_indexPath];
        celled.accessoryType = UITableViewCellAccessoryNone;
        //记录当前选中的位置
        _indexPath = indexPath;
        //当前选择的打勾
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 46 : 119;
}
- (void)selectInputReasonStr:(NSString *)str
{
    self.reasonStr = str;
    if (self.reasonStr.length > 10) {
        _btn.enabled = YES;
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"register_available"]forState:UIControlStateNormal];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 33;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 33)];
    UILabel *conLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, SCREENWIDTH-34, 33)];
    conLbl.text = @"请补充详细问题和意见";
    conLbl.textColor = UIColorFromHex(0x9e9e9e);
    conLbl.textAlignment = NSTextAlignmentLeft;
    conLbl.font = [UIFont systemFontOfSize:12];
    [view addSubview:conLbl];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 0.01f : 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
