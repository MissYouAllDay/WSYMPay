//
//  YMTransferDetailsVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/4.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferListVC.h"
#import "YMSearchView.h"
#import "YMTransferDetailsModel.h"
#import "YMMyHttpRequestApi.h"
#import "YMUserInfoTool.h"
#import "RequestModel.h"
#import "YMTransferDetailsCell.h"
#import "YMMonthModel.h"
#import "YMCustomFooter.h"
#import "YMCustomHeader.h"
#import "YMTransferDetailsVC.h"
#import "YMScanDetailsVC.h"
@interface YMTransferListVC ()<UISearchBarDelegate>
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, strong) YMSearchView *searchView;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, copy) NSString *keyWords;//关键词
@property (nonatomic, copy) NSString *tranTypeSel;//交易类型
@property (nonatomic, strong) UIImageView *backgroundView;
@end

@implementation YMTransferListVC

#pragma mark - 懒加载

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(YMSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[YMSearchView alloc]init];
        _searchView.columns = @[@"转账",@"网购"];
        WEAK_SELF;
        _searchView.columnBtnClick = ^(NSInteger index) {
        
            NSInteger count = index + 1;
            
            if (count == 1) {
                 weakSelf.navigationItem.title = @"转账记录";
            } else if (count == 2) {
                 weakSelf.navigationItem.title = @"网购记录";
            }
            
            [weakSelf hideSearchView];
            weakSelf.keyWords    = nil;
            weakSelf.tranTypeSel = [NSString stringWithFormat:@"%ld",(long)count];
            
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

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转账记录";
    self.isLoad = NO;
    self.pageNumber = 1;
    self.keyWords = nil;
    self.tranTypeSel = @"1";
    [self setNavigationItem];
    [self setupRefresh];
    [self setupNotification];
    [self.tableView.mj_header beginRefreshing];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setShouldResignOnTouchOutside:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setShouldResignOnTouchOutside:YES];
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

#pragma mark - customMethod
-(void)setupRefresh
{
    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeadRefresh)];
    self.tableView.mj_footer = [YMCustomFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFootRefresh)];
}

-(void)loadData
{
    self.pageNumber = 1;
    RequestModel *params = [[RequestModel alloc]init];
    params.tranTypeSel = self.tranTypeSel;
    params.pageNum = [NSString stringWithFormat:@"%ld",(unsigned long)self.pageNumber];
    params.numPerPag = @"20";
    params.keyWords = self.keyWords;
    WEAK_SELF;
//    [YMMyHttpRequestApi loadHttpRequestWithBillList:params success:^(NSArray *dataArray, NSInteger count) {
//        [weakSelf.dataArray removeAllObjects];
//        [weakSelf.dataArray addObjectsFromArray:dataArray];
//        [weakSelf.tableView.mj_header endRefreshing];
//        weakSelf.isLoad = YES;
//        [weakSelf.tableView reloadData];
//        [weakSelf setFooterRefreshStatus:count];
//    }];
}

-(void)setupNotification
{
    [WSYMNSNotification addObserver:self selector:@selector(loadData) name:WSYMRefreshTransferNotification object:nil];
}

-(void)loadMoreData
{
    self.pageNumber++;
    RequestModel *params = [[RequestModel alloc]init];
    params.tranTypeSel   = self.tranTypeSel;
    params.PageNum       = [NSString stringWithFormat:@"%ld",(unsigned long)self.pageNumber];
    params.NumPerPag     = @"20";
    params.keyWords      = self.keyWords;
    WEAK_SELF;
//    [YMMyHttpRequestApi loadHttpRequestWithBillList:params success:^(NSArray *dataArray, NSInteger count) {
//        [weakSelf.tableView.mj_footer endRefreshing];
//        [weakSelf addBillsList:dataArray];
//        [weakSelf setFooterRefreshStatus:count];
//        [weakSelf.tableView reloadData];
//    }];
}

-(void)addBillsList:(NSArray *)array
{
    for (YMMonthModel *m1 in array) {
        BOOL isHave = NO;
        for (YMMonthModel *m2 in self.dataArray) {
            if ([m2.month isString:m1.month]) {
                isHave = YES;
                [m2.billList addObjectsFromArray:m1.billList];
                continue;
            }
        }
        if (!isHave) {
            [self.dataArray addObject:m1];
        }
    }

}

-(void)setFooterRefreshStatus:(NSInteger)count
{
    BOOL isShowIcon = [self getTotalDataCount] == 0;
    
    self.backgroundView.hidden      = !isShowIcon;
    self.tableView.scrollEnabled    = !isShowIcon;
    self.tableView.mj_footer.hidden = isShowIcon;
    
    if ([self getTotalDataCount] >= count) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)cancelBtnDidClick
{
    [self hideSearchView];
}

-(void)hideSearchView
{
    self.navigationItem.leftBarButtonItem  = self.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.titleView = nil;
    [self.searchView hide];
    [self setNavigationBarTitntColor:NAVIGATIONBARCOLOR titleColor:nil];
}

-(void)setNavigationItem
{
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

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

-(NSInteger)getTotalDataCount
{
    NSInteger count = 0;
    for (YMMonthModel *m in self.dataArray) {
        count += m.billList.count;
    }
    
    return count;
}

#pragma mark - 上拉下拉刷新
-(void)tableViewHeadRefresh
{
    [self loadData];
}

-(void)tableViewFootRefresh
{
    [self loadMoreData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.keyWords             = searchBar.text;
    searchBar.text            = nil;
    self.tranTypeSel          = @"0";
    self.navigationItem.title = @"账单详情";
    [self hideSearchView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -父类方法
-(NSString *)getHeaderStr:(NSInteger)section
{
    YMMonthModel *m = _dataArray[section];
    return m.month;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (self.isLoad) {
        if (_dataArray.count) {
            self.tableView.mj_footer.hidden = NO;
        }
        return _dataArray.count;
    } else {
        self.tableView.mj_footer.hidden = YES;
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMMonthModel *m = self.dataArray[indexPath.section];
    YMTransferDetailsModel *model = m.billList[indexPath.row];
    if ([model.tranType isString:@"转账"]) {
        YMTransferDetailsVC *detailsVC = [[YMTransferDetailsVC alloc]init];
        detailsVC.orderNo = model.traordNo;
        [self.navigationController pushViewController:detailsVC animated:YES];
    } else {
        YMScanDetailsVC *detailsVC = [[YMScanDetailsVC alloc]init];
        detailsVC.orderNO = model.traordNo;
        detailsVC.isPay   = [model.ordStatus isString:@"00"];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YMMonthModel *m  = _dataArray[section];
    return m.billList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"transferCell";
    YMMonthModel *m     = _dataArray[indexPath.section];
    
    YMTransferDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMTransferDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.details = m.billList[indexPath.row];
    return cell;
}

@end
