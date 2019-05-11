//
//  FindViewController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "FindViewController.h"
#import "YMCustomHeader.h"
#import "YMCustomFooter.h"
#import "YMFindHeaderImgView.h"
#import "YMFindCenterView.h"
#import "YMFindOtherCell.h"
#import "YMColumnModel.h"
#import "YMHomeH5VC.h"
#import "PromptBoxView.h"
#import "FirstRealNameCertificationViewController.h"

@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource,YMFinancialBannerCellDelegate,YMFindOtherCellDelegate,PromptBoxViewDelegate,YMFindCenterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@property (nonatomic, strong) YMFindHeaderImgView *
ymFindHeaderImgView;
@end

@implementation FindViewController

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated:NO];
}
#pragma mark - 懒加载
-(PromptBoxView *)promptBoxView
{
    if (!_promptBoxView) {
        _promptBoxView = [[PromptBoxView alloc]init];
        _promptBoxView.title = @"您的账户未实名认证,为保证您的安全，请先实名认证";
        _promptBoxView.leftButtonTitle = @"取消";
        _promptBoxView.rightButtonTitle = @"去认证";
        _promptBoxView.delegate = self;
    }
    return _promptBoxView;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];

    
}

/**
 下拉刷新
 */
- (void)tableViewHeaderRefresh
{
    //    栏目类型 1首页 2理财 3发现
    [self.ymFindHeaderImgView reloadBannerData];
    YMUserInfoTool * user = [YMUserInfoTool shareInstance];
    NSDictionary * paramDic = @{
//                                @"token":user.token,
                                @"C_TYPE":@"3",
                                @"tranCode":COLUMNCODE
                                
                                };
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        if (resCode == 1) {
            self.dataArr = [YMColumnModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"LIST"]];
            [self.tableView reloadData];
        }else
        {
            [MBProgressHUD showText:resMsg];
        }
        
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    
    
    
}
- (void)setupSubviews{
    self.navigationItem.title = nil;
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.view.backgroundColor      = VIEWGRAYCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    
    YMFindHeaderImgView* headerImgView = [[YMFindHeaderImgView alloc]init];
    headerImgView.frame = CGRectMake(0, 0, SCREENWIDTH, SCALEZOOM(328/2));
    headerImgView.delegate = self;
    self.ymFindHeaderImgView = headerImgView;
    
    self.tableView.tableHeaderView = headerImgView;
    
    
    self.tableView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefresh)];
    [self.tableView.mj_header beginRefreshing];
    [headerImgView reloadBannerData];

}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark -
#pragma mark - UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    } else {
        
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

      return self.dataArr.count+1;
}
#pragma mark -
#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        NSString *ID = @"centerView";
        YMFindCenterView *cell = [[YMFindCenterView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell requestBannerData];
        return cell;
    }
   else{
        
       NSString *ID = @"findOtherCell";
       YMFindOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
       if (!cell) {
           cell = [[[NSBundle mainBundle]loadNibNamed:@"YMFindOtherCell" owner:self options:nil] lastObject];
         
       }
       cell.model = self.dataArr[indexPath.section-1];
       cell.delegate = self;
       return cell;
    }
    
}

#pragma mark - customDelegate               - Method -
- (void)selectBannerItemAtIndex:(NSString *)h5Url
{
   
    if (h5Url.length > 0) {
        YMHomeH5VC * webVC = [[YMHomeH5VC alloc] init];
        webVC.loadUrl = h5Url;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
    
    [MBProgressHUD showText:MSG0];
    YMLog(@"select banner index = %ld ",(long)index);
}
-(void)selectCenterBannerItemAtIndex:(NSString *)h5Url
{
    if (h5Url.length > 0) {
        YMHomeH5VC * webVC = [[YMHomeH5VC alloc] init];
        webVC.loadUrl = h5Url;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
    
    [MBProgressHUD showText:MSG0];
    YMLog(@"select banner index = %ld ",(long)index);
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
       return SCALEZOOM(60/2);
      
    }
 
    return SCALEZOOM(445/2);
    
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  HEADERSECTION_HEIGHT/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01
    ;
}
-(void)yMFindOtherCellDidSelected:(YMColumnImageModel *)model
{
    
 
    
    if (model.url.length > 0) {
        YMHomeH5VC * webVC = [[YMHomeH5VC alloc] init];
        webVC.loadUrl = model.url;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
    [MBProgressHUD showText:MSG0];
    
}
#pragma mark - PromptBoxViewDelegate(未实名弹框代理)
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
}

-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    FirstRealNameCertificationViewController * firstCerVC = [[FirstRealNameCertificationViewController alloc] init];
    [self.navigationController pushViewController:firstCerVC animated:YES];
}
@end
