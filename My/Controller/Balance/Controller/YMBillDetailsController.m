//
//  YMBillDetailsController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/9.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMBillDetailsController.h"
#import "YMBillDetailsModel.h"
#import "YMBillDetailsCell.h"
#import "YMPopMenu.h"
#import "YMExpenditureDetailsController.h"
#import "YMMyHttpRequestApi.h"
#import "YMBillDetailsListModel.h"
#import "YMCustomHeader.h"
#import "YMCustomFooter.h"
#import "YMBillBaseModel.h"

@interface YMBillDetailsController ()<YMPopMenuDelegate>

@property (nonatomic, strong) NSMutableArray *allDataArray;

@property (nonatomic, strong) NSMutableArray *billDetailsArray;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger allCount;//总条数

@property (nonatomic, assign) BOOL hasMore;//是否还有还可以继续请求

@property (nonatomic, strong) LKDBHelper *listDB;

@property (nonatomic, strong) YMPopMenu *popMenu;

@end

@implementation YMBillDetailsController

#pragma mark - getters and setters          - Method -
- (NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        _allDataArray = [[NSMutableArray alloc] init];
    }
    return _allDataArray;
}
-(NSMutableArray *)billDetailsArray
{
    if (!_billDetailsArray) {
        _billDetailsArray = [NSMutableArray array];
    }
    return _billDetailsArray;
}
-(YMPopMenu *)popMenu
{
    if (!_popMenu) {
        _popMenu = [[YMPopMenu alloc]init];
        _popMenu.delegate   = self;
    }
    return _popMenu;
}
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    self.type    = 0;
    self.pageNum = 1;
    self.hasMore = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        [self initDB];
    });
    [self loadData];
}

#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    self.navigationItem.title = @"收支明细";
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"screen"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarButtonItemDidClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.size = btn.currentImage.size;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeadRefresh)];
    self.tableView.mj_footer =[YMCustomFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableViewFootRefresh)];
    
}
- (void)loadData
{
    [self.billDetailsArray removeAllObjects];
    
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithPaymentDetailsType:weakSelf.type pageNum:weakSelf.pageNum Success:^(NSMutableArray *dataArray, YMBillBaseModel *model) {
        STRONG_SELF;
        
        strongSelf.allCount = [model getAllCountNum];//总条数
        
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        
        if (dataArray.count>0) {
            if (strongSelf.pageNum > 1) {
                [strongSelf.allDataArray addObjectsFromArray:dataArray];
            }else{
                strongSelf.tableView.mj_footer.hidden = dataArray.count>19?NO:YES;
                strongSelf.allDataArray = dataArray;
            }
            //存入数据库：（更新数据库）
            [strongSelf saveDB];
            
            if (strongSelf.type == 0) {//全部
                strongSelf.billDetailsArray = [YMBillDetailsListModel getDataArray:strongSelf.allDataArray];
                [strongSelf isShowMethod];
                [strongSelf.tableView reloadData];
            }else{//显示部分，1支出 或 2收入,此时从数据库中取可以
                [strongSelf searchDBWithType:strongSelf.type];
            }
            
        }else{//没有更多
            if (strongSelf.allCount == 0) {
                [strongSelf isShowMethod];
                [strongSelf.tableView reloadData];
            }
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [strongSelf loadCommonMethod];
        
    } failure:^(NSError *error) {
        STRONG_SELF;
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        
        if (error.code == AFNetworkErrorType_NoNetwork || error.code == AFNetworkErrorType_ConnectToHost) {
            //没有网络，从数据库中取
            [strongSelf searchDB];
        }
    }];
}
- (void)isShowMethod
{
    if (self.billDetailsArray.count>0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}
- (void)loadCommonMethod
{
    NSInteger currentCount = self.allDataArray.count;
    YMLog(@"总数 = %ld ，当前已请求数 = %ld",(long)self.allCount,(long)currentCount);
    if (self.allCount > currentCount) {
        self.hasMore = YES;
    }else{//不用继续请求
        self.hasMore = NO;
    }
}
#pragma mark - 数据库相关
- (void)initDB//清空数据库（或者说init）
{
    self.listDB = [YMBillDetailsModel getUsingLKDBHelper];
    YMLog(@"create table sql :\n%@\n",[YMBillDetailsModel getCreateTableSQL]);
}
//存入数据库
- (void)saveDB
{
    //清空表数据
    [LKDBHelper clearTableData:[YMBillDetailsModel class]];
    
    for (YMBillDetailsModel *billModel in self.allDataArray) {
        YMBillDetailsModel *model = [[YMBillDetailsModel alloc] init];
        
        model = billModel;
        
        model.currentPageNum = self.pageNum;
        model.allCount = self.allCount;
        model.currentCount = self.allDataArray.count;
        [model saveToDB];
    }
}
/*
 * 查询数据库
 */
- (void)searchDB
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *sql = @"select * from YMBillListModelDBTable";
        NSMutableArray *array = [self.listDB searchWithSQL:sql toClass:[YMBillDetailsModel class]];
        YMLog(@"查询结果 array.count = %ld",(unsigned long)array.count);
        self.allDataArray = array;
        if (self.allDataArray.count>0) {
            YMBillDetailsModel *model = self.allDataArray[0];
            self.pageNum = model.currentPageNum;
            self.allCount = model.allCount;
        }
        self.billDetailsArray = [YMBillDetailsListModel getDataArray:array];
        [self isShowMethod];
        [self.tableView reloadData];
    });
}
/**
 * 查询数据库
 * type 0全部 1支出 2 收入
 */
- (void)searchDBWithType:(NSInteger)type
{
    if (type == 0) {
        self.billDetailsArray = [YMBillDetailsListModel getDataArray:self.allDataArray];
        [self isShowMethod];
        [self.tableView reloadData];
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *sql = [NSString stringWithFormat:@"select * from YMBillListModelDBTable where inOrOut='%ld'",(long)type];
            NSMutableArray *array = [self.listDB searchWithRAWSQL:sql toClass:[YMBillDetailsModel class]];
            self.billDetailsArray = [YMBillDetailsListModel getDataArray:array];
            [self isShowMethod];
            [self.tableView reloadData];
        });
    }
}

#pragma mark - 下拉刷新 上拉加载更多
- (void)tableViewHeadRefresh
{
    self.pageNum = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self loadData];
}
- (void)tableViewFootRefresh
{
    if (self.hasMore) {
        self.pageNum ++;
        [self loadData];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
/**
 每个分区中的cell个数
 */
- (NSInteger)getItemCount:(NSInteger)section
{
    NSInteger count = 0;
    if (self.billDetailsArray.count>0) {
        YMBillDetailsListModel *listModel = self.billDetailsArray[section];
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
    if (self.billDetailsArray.count>0) {
        YMBillDetailsListModel *listModel = self.billDetailsArray[section];
        str = [listModel getDateString];
    }
    return str;
}
/**
 每个分区中的cell对应的model
 */
- (YMBillDetailsModel *)getBillDetailsModelSection:(NSUInteger)section row:(NSInteger)row
{
    YMBillDetailsModel *model;
    if (self.billDetailsArray.count>0) {
        YMBillDetailsListModel *listModel = self.billDetailsArray[section];
        model = [listModel getListArray][row];
    }
    return model;
}
#pragma mark - eventResponse                - Method -
-(void)rightBarButtonItemDidClick:(UIButton *)item
{
    CGRect rect =  [KEYWINDOW convertRect:item.frame fromWindow:KEYWINDOW];
    [self.popMenu showInRect:rect];
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -(YMPopMenuDelegate)
-(void)popMenu:(YMPopMenu *)popMenu clickedButtonAtIndex:(NSUInteger)tag
{
    YMLog(@"tag = %lu",(unsigned long)tag);
    if (tag == 0) {
        self.type = 0;
    }else if (tag == 1){
        self.type = 2;
    }else if (tag == 2){
        self.type = 1;
    }
    //从数据库中取
    [self searchDBWithType:self.type];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.billDetailsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getItemCount:section];
}

-(YMBillDetailsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = @"cell";
    YMBillDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMBillDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.billDetails = [self getBillDetailsModelSection:indexPath.section row:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMExpenditureDetailsController *expenditureDetailsVC = [[YMExpenditureDetailsController alloc]init];
    
    YMBillDetailsModel *model = [self getBillDetailsModelSection:indexPath.section row:indexPath.row];
    expenditureDetailsVC.billDetails = model;
    
    

    
    [self.navigationController pushViewController:expenditureDetailsVC animated:YES];
    
}

@end
