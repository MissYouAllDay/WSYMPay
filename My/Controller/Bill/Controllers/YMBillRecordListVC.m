//
//  YMBillRecordListVC.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/23.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "YMBillRecordListVC.h"
#import "YMAllBillListCell.h"
#import "YMSearchView.h"
#import "YMCustomFooter.h"
#import "YMCustomHeader.h"
#import "YMAllBillDetailVC.h"
#import "YMExpenditureDetailsController.h"//账户提现，账户充值进入的详情vc
#import "YMBillCollectListView.h"
#import "YMMyHttpRequestApi.h"
#import "RequestModel.h"
#import "YMAllBillListEndWantModel.h"
#import "YMAllBillListDataListModel.h"
#import "YMBillRecordScreenVC.h"
#import "YMBillRecordTimeVC.h"
@interface YMBillRecordListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) YMSearchView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, copy) NSString *keyWords;//关键词
@property (nonatomic, copy) NSString *tranTypeSel;//交易类型
@property (nonatomic, assign) NSInteger pageNum;//页数默认1
@property (nonatomic, assign) NSInteger numPerPag;//每页显示条数默认20
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong)YMBillCollectListView *collectTopView;
@property (nonatomic,strong) UIButton *monthBtn;
@property (nonatomic,copy) NSString *value;
@end

@implementation YMBillRecordListVC

#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self setupRefresh];
    [self loadNotification];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [WSYMNSNotification removeObserver:self name:WSYMRefreshUserInfoNotification object:nil];
}
#pragma mark - privateMethods               - Method -
- (void)initView
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    if(_billType==BillCollect) {
        [self.view addSubview:self.collectTopView];
        [_collectTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.view);
            make.height.mas_equalTo(SCALEZOOM(160));
        }];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(0);
            make.bottom.mas_equalTo(self.view);
        }];
    }else {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(SCALEZOOM(60));
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(self.view);
    }];
    }
    self.tableView.hidden = YES;
    self.keyWords = @"";
    self.pageNum = 1;
    self.numPerPag = 20;
}
-(void)nextTimeAction {
    
}
-(void)nextScreenVCAction {
    YMBillRecordScreenVC *screenVC=[YMBillRecordScreenVC new];
    WEAK_SELF;
    screenVC.clickValueblock = ^(NSString * _Nullable value) {
        STRONG_SELF;
        strongSelf.value = value;
        [strongSelf loadData];
    };
    [self.navigationController pushViewController:screenVC animated:YES];
}
-(UIView *)topView {
    if(!_topView) {
        _topView=[UIView new];
        _topView.backgroundColor=[UIColor whiteColor];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"lou"] forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextTimeAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.topView).mas_offset(SCALEZOOM(-14));
            make.centerY.mas_equalTo(self.topView);
        }];
        UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"筛选" forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(nextScreenVCAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:btn2];
        [btn2 setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.topView).mas_offset(SCALEZOOM(14));
            make.centerY.mas_equalTo(self.topView);
        }];
        [btn2 layoutIfNeeded];
        btn2.imageEdgeInsets=UIEdgeInsetsMake(0,btn2.titleLabel.intrinsicContentSize.width+4, -4,0);
        btn2.titleEdgeInsets=UIEdgeInsetsMake(0,-btn2.currentImage.size.width-4,0,0);
        
    }
    return _topView;
}
-(YMBillCollectListView *)collectTopView {
    if(!_collectTopView) {
        _collectTopView=[[YMBillCollectListView alloc]init];
    }
    return _collectTopView;
}
- (void)loadData
{
    [self.dataArray removeAllObjects];
    NSString *transTypeSelStr = @"";
    if (self.billType == BillConsume) {//1消费
        transTypeSelStr = @"1";
    }else if (self.billType == BillAccountRecharge){//2充值
        transTypeSelStr = @"2";
    }else if (self.billType == BillAccountWithDrawal){//3提现
        transTypeSelStr = @"3";
    }else if (self.billType == BillAccountTransfer){//4转账
        transTypeSelStr = @"4";
    }else if (self.billType == BillMobilePhoneRecharge){//5手机充值
        transTypeSelStr = @"5";
    }else if (self.billType == BillCollect){//6我要收款
        transTypeSelStr = @"6";
    }else if(self.billType  == BillTransaction){//0全部
        transTypeSelStr = @"0";

    }


    RequestModel *params = [[RequestModel alloc] init];

    params.tranTypeSel = transTypeSelStr;
    params.pageNum = [NSString stringWithFormat:@"%ld",self.pageNum];
    params.numPerPag = [NSString stringWithFormat:@"%ld",self.numPerPag];
    params.keyWords = self.keyWords;
    if ([self.value isEqualToString:@"转账"]) {
        params.tranTypeSel = @"1";
    }
    else if ([self.value isEqualToString:@"网购"]) {
        params.tranTypeSel = @"2";
    }
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithBillList:params success:^(NSMutableArray *array, YMAllBillListModel *model) {
     
        STRONG_SELF;
        
        
//        NSLog(@"model---------%@",model.countNum);
//        NSLog(@"-------%@",model.get.AllTxamt);我
//        NSString *AllTxamt = [NSString stringWithFormat:@"%@",model.data.AllTxamt];
        
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        strongSelf.backgroundView.hidden = YES;
        strongSelf.tableView.hidden = NO;
        
        if (array.count > 0) {
            if (strongSelf.pageNum>1) {
                [strongSelf.allDataArray addObjectsFromArray:array];
            }else{
                [strongSelf.allDataArray removeAllObjects];
                strongSelf.tableView.mj_footer.hidden = array.count>19?NO:YES;
                strongSelf.allDataArray = array;
            }
        }else{
            if (strongSelf.pageNum>1) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.backgroundView.hidden = NO;
                strongSelf.tableView.hidden = YES;
            }
        }
        strongSelf.dataArray = [YMAllBillListEndWantModel getDataArray:strongSelf.allDataArray];
        [strongSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
    
}
-(void)setNavigationItem
{
//    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}
-(void)setupRefresh
{
    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeadRefresh)];
    self.tableView.mj_footer = [YMCustomFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFootRefresh)];
}
-(void)tableViewHeadRefresh
{
    self.pageNum = 1;
    [self loadData];
}

-(void)tableViewFootRefresh
{
    self.pageNum ++;
    [self loadData];
}
/**
 每个分区中的cell个数
 */
- (NSInteger)getItemCount:(NSInteger)section
{
    NSInteger count = 0;
    if (self.dataArray.count>0) {
        YMAllBillListEndWantModel *listModel = self.dataArray[section];
        count = [listModel getListArrayCount];
    }
    return count;
}
/**
 每个分区header
 */
- (NSString *)getHeaderStr:(NSInteger)section
{
    NSString *str = @"";
    if (self.dataArray.count>0) {
        YMAllBillListEndWantModel *listModel = self.dataArray[section];
        str = [listModel getDateString];
    }
    return str;
}
/**
 每个分区中的cell对应的model
 */
- (YMAllBillListDataListModel *)getDetailsModelSection:(NSUInteger)section row:(NSInteger)row
{
    YMAllBillListDataListModel *model;
    if (self.dataArray.count>0) {
        YMAllBillListEndWantModel *listModel = self.dataArray[section];
        NSMutableArray *listArray = [listModel getListArray];
        if (listArray.count>0) {
            model = listArray[row];
        }
    }
    return model;
}

#pragma mark - eventResponse                - Method -
-(void)rightBarButtonItemDidClick
{
    self.leftBarButtonItem  = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = self.cancelButtonItem;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setNavigationBarTitntColor:RGBColor(239, 239, 239) titleColor:nil];
    [self.searchView show];
}
-(void)cancelBtnDidClick
{
    [self hideSearchView];
}
-(void)hideSearchView
{
    self.navigationItem.leftBarButtonItem  = self.leftBarButtonItem;
//    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.titleView = nil;
    [self.searchView hide];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setNavigationBarTitntColor:NAVIGATIONBARCOLOR titleColor:nil];
}

#pragma mark - notification                 - Method -
- (void)loadNotification
{
    [WSYMNSNotification addObserver:self selector:@selector(refreshTableView) name:WSYMRefreshUserInfoNotification object:nil];
}
- (void)refreshTableView
{
    [self loadData];
}
#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getItemCount:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *cellID = @"YMAllBillListCell";
        YMAllBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[YMAllBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        YMAllBillListDataListModel *billListModel = [self getDetailsModelSection:indexPath.section row:indexPath.row];
        cell.model = billListModel;
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156/2;//高度不需要适配
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    headView.backgroundColor = VIEWGRAYCOLOR;
    _monthBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_monthBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    _monthBtn.titleLabel.font=[UIFont systemFontOfMutableSize:12];
    [_monthBtn setTitle:@"本月" forState:UIControlStateNormal];
    [_monthBtn addTarget:self action:@selector(monthbtnclick) forControlEvents:UIControlEventTouchDown];
    _monthBtn.backgroundColor=[UIColor whiteColor];
    [headView addSubview:_monthBtn];
    [_monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KP6(72));
        make.height.mas_equalTo(KP6(28));
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(headView).mas_offset(KP6(14));
    }];
    _monthBtn.layer.cornerRadius=KP6(14);
    UILabel *lbl1=[UILabel new];
        lbl1.textColor = FONTCOLOR;
        lbl1.font = [UIFont systemFontOfMutableSize:12];
    lbl1.text=@"支出：1223元";
    [headView addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView).mas_offset(KP6(-14));
        make.top.mas_equalTo(headView).mas_offset(KP6(4));
    }];
    UILabel *lbl2=[UILabel new];
    lbl2.textColor = FONTCOLOR;
    lbl2.font = [UIFont systemFontOfMutableSize:12];
    lbl2.text=@"收入：1223元";
    [headView addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView).mas_offset(KP6(-14));
        make.top.mas_equalTo(lbl1.mas_bottom).mas_offset(KP6(4));
    }];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE, 0, SCREENWIDTH-LEFTSPACE*2, 50/2)];
//    titleLabel.text = [self getHeaderStr:section];
//    titleLabel.textColor = FONTCOLOR;
//    titleLabel.font = [UIFont systemFontOfMutableSize:12];
//    [headView addSubview:titleLabel];
    return headView;
}
- (void)monthbtnclick {
    YMBillRecordTimeVC *vc = [[YMBillRecordTimeVC alloc]init];
    WEAK_SELF;
    vc.clickMonthblock = ^(NSString * _Nullable month) {
        STRONG_SELF;
        [strongSelf.monthBtn setTitle:month forState:UIControlStateNormal];
        CGSize size = [month sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [strongSelf.monthBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KP6(48+size.width));
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMAllBillListDataListModel *billListModel = [self getDetailsModelSection:indexPath.section row:indexPath.row];
    YMAllBillDetailVC *detailVC = [[YMAllBillDetailVC alloc] init];
    if (self.billType == BillConsume) {//消费
        
        if ([[billListModel getTranTypeStr]isEqualToString:@"1"]) {//消费---扫一扫超级收款码
            detailVC.billDetailType = BillDetailConsumeScan;//消费---扫一扫超级收款码
            
        }else if ([[billListModel getTranTypeStr]isEqualToString:@"2"]){//手机充值时
            
            detailVC.billDetailType = BillDetailConsumeMobilePhoneRecharge;//消费---手机话费充值
        }
        
    }else if (self.billType == BillAccountTransfer){//转账
        
        detailVC.billDetailType = BillDetailAccountTransfer;//转账(我要收款/ 扫一扫有名收款码)
        
    }else if (self.billType == BillMobilePhoneRecharge){//手机充值
        
        detailVC.billDetailType = BillDetailConsumeMobilePhoneRecharge;//消费---手机话费充值
        
    }else if (self.billType == BillCollect){//收款账单（我要收款界面进入的）
        
        detailVC.billDetailType = BillDetailAccountTransfer;//转账(我要收款/ 扫一扫有名收款码)
        
    }else if (self.billType == BillAccountRecharge){//账户充值
        
        detailVC.billDetailType = BillDetailAccountRecharge;
        
    }else if (self.billType == BillAccountWithDrawal){//账户提现
        
        detailVC.billDetailType = BillDetailAccountWithDrawal;
        
    }else if (self.billType == BillTransaction){//全部
        detailVC.billDetailType = BillDetailAccountTransfer;

    }
    detailVC.billListModel = billListModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.keyWords             = searchBar.text;
    searchBar.text            = nil;
    [self hideSearchView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight=KP6(196/2);
    }
    return _tableView;
}
- (NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        _allDataArray = [[NSMutableArray alloc] init];
    }
    return _allDataArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(YMSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[YMSearchView alloc]init];
        _searchView.columns = @[@"消费",@"账户充值",@"账户提现",@"转账"];
        WEAK_SELF;
        _searchView.columnBtnClick = ^(NSInteger index) {
            weakSelf.billType = index;
            [weakSelf hideSearchView];
            weakSelf.keyWords    = nil;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    return _searchView;
}
-(UIBarButtonItem *)cancelButtonItem
{
    if (!_cancelButtonItem) {
        UIButton *cancelBtn = [[UIButton alloc]init];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:RGBColor(83, 83, 83) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.size = [cancelBtn.titleLabel sizeThatFits:CGSizeMake(50, 40)];
        _cancelButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    }
    return _cancelButtonItem;
}

-(UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = NAVIGATIONBARCOLOR;
        _searchBar.placeholder = @"请输入关键字搜索";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

-(UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"screen"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemDidClick)];
    }
    return _rightBarButtonItem;
}

-(UIImageView *)backgroundView
{
    if (!_backgroundView) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
        backgroundView.hidden   = YES;
        backgroundView.centerX  = SCREENWIDTH * 0.5;
        backgroundView.centerY  = SCREENHEIGHT * 0.5 - 64;
        [self.view insertSubview:backgroundView atIndex:0];
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (void)setBillType:(BillType)billType
{
    _billType = billType;
    switch (_billType) {
        case BillConsume:
        {
            self.title = @"消费";
            [self setNavigationItem];
        }
            break;
        case BillAccountRecharge:
        {
            self.title = @"账户充值";
            [self setNavigationItem];
        }
            break;
        case BillAccountWithDrawal:
        {
            self.title = @"账户提现";
            [self setNavigationItem];
        }
            break;
        case BillAccountTransfer:
        {
            self.title = @"转账";
            [self setNavigationItem];
        }
            break;
        case BillCollect:
        {
            self.title = @"收款账单";
        }
            break;
        case BillMobilePhoneRecharge:
        {
            self.title = @"手机充值记录";
        }
            break;
        case BillTransaction:
        {
            self.title = @"交易记录";
        }
            break;
        default:
            break;
    }
}



@end
