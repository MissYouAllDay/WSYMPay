//
//  HomeViewController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "HomeViewController.h"
#import "YMHomeTopView.h"
#import "YMHomeBottomView.h"
#import "YMBannerViewCell.h"
#import "YMHomeColumnCell.h"
#import "YMHomeColumnModel.h"
#import "YMUserInfoTool.h"
#import "LandViewController.h"
#import "AccountViewController.h"
#import "YMTravelTicketVC.h"
#import "YMPayCodeVC.h"
#import "YMMobileRechargeVC.h"
#import "YMEasyPaymentVC.h"
#import "YMCreditCardPaymentVC.h"
#import "YMCardPackageVC.h"
#import "YMAllVC.h"
#import "PromptBoxView.h"
#import "FirstRealNameCertificationViewController.h"
#import "YMHomeH5VC.h"

//添加
#import "YMPayCashierDeskVC.h"
#import "YMAllBillVC.h"
#import "YMTXSelectBankCardVC.h"
#import "FinancialTool.h"
#import "YMColumnModel.h"
#import "YMColumnImageModel.h"

@interface HomeViewController ()
<YMHomeColumnCellDelegate,
YMBannerViewCellDelegate,
PromptBoxViewDelegate,
YMHomeTopViewDelegate,
YMHomeBottomViewDelegate,FinancialToolDelegate>
@property (nonatomic, strong) NSMutableArray *arrays;
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) FinancialTool * financialtool;
@end

@implementation HomeViewController

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

#pragma mark - 生命周期
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self.financialtool;
        _collectionView.dataSource = self.financialtool;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _collectionView;
}
-(FinancialTool *)financialtool
{
    if (!_financialtool) {
        
        _financialtool = [[FinancialTool alloc] initWithCollectionViewFrame:CGRectZero];
        _financialtool.delegate = self;
        _financialtool.collectionView = self.collectionView;
        
    }
    return _financialtool;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupNavigationItem];
    [self addNotifications];
    
}
- (void)requestColumnData
{
    //    栏目类型 1首页 2理财 3发现
    YMUserInfoTool * user = [YMUserInfoTool shareInstance];
    NSDictionary * paramDic = @{
//                                @"token":user.token,
                                @"C_TYPE":@"1",
                                @"tranCode":COLUMNCODE
                                
                                };
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        if (resCode == 1) {
            
            [self setData:responseObject];
        }else
        {
            [MBProgressHUD showText:resMsg];
        }
        
        
    } failure:^(NSError *error) {
      
    }];
    
 
    
}

-(void)setData:(NSDictionary *)responseDic
{
    NSArray * modelArr = [YMColumnModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"LIST"]];
    
    
    self.arrays = [NSMutableArray array];
    
    
    
    for (YMColumnModel * model in modelArr ) {
       YMHomeColumnModel *column = [[YMHomeColumnModel alloc]init];
        column.imageArray         = model.C_IMAGE;
        column.title              = model.C_TITLE;
        if([column.title isEqualToString:@"精品推荐"]) {
            
        }else {
            [self.arrays addObject:column];
        }
    }
    [self.tableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNavigationImageView].hidden = YES;
    
    if([YMUserInfoTool shareInstance].loginStatus)
    {
        [[YMUserInfoTool shareInstance] loadUserInfoFromServer:nil];
    }
  
    [self requestColumnData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self getNavigationImageView].hidden = NO;
}

#pragma mark - 自定义方法
-(void)setupSubviews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    UIView *headerView           = [[UIView alloc]init];
    headerView.width             = SCREENWIDTH;
    headerView.height            = SCREENHEIGHT * 0.15 + SCREENHEIGHT * 0.3;
    [headerView addSubview:[self createTopView]];
    [headerView addSubview:[self createBottomView]];
    self.tableView.tableHeaderView = headerView;
    
 
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
}

-(UIView *)createTopView
{
    YMHomeTopView *topView = [[YMHomeTopView alloc]init];
    topView.delegate       = self;
    topView.x = topView.y  = 0;
    topView.width          = SCREENWIDTH;
    topView.height         = SCREENHEIGHT * 0.15;
    return topView;
}

-(UIView *)createBottomView
{
    YMHomeBottomView *bottomView = [[YMHomeBottomView alloc]init];
    bottomView.delegate          = self;
    bottomView.x                 = 0;
    bottomView.y                 = SCREENHEIGHT * 0.15;
    bottomView.width             = SCREENWIDTH;
    bottomView.height            = SCREENHEIGHT * 0.3;
    return bottomView;
}

-(void)setupNavigationItem
{
    self.navigationItem.title = nil;
    UIBarButtonItem  *leftBBI = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
    leftBBI.tintColor         = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBBI;
    [self updateAccountInfo];
}

-(void)addNotifications
{
    [WSYMNSNotification addObserver:self selector:@selector(updateAccountInfo) name:WSYMRefreshUserInfoNotification object:nil];
}

-(void)updateAccountInfo
{
    if ([YMUserInfoTool shareInstance].loginStatus) {
        NSLog(@"账号：%@",[[YMUserInfoTool shareInstance] getShowAccountStr]);
        self.navigationItem.leftBarButtonItem.tag   = 1;
        self.navigationItem.leftBarButtonItem.title = [[YMUserInfoTool shareInstance] getShowAccountStr];
    } else {
        self.navigationItem.leftBarButtonItem.tag   = 0;
        self.navigationItem.leftBarButtonItem.title = @"登录/注册";
    }

}

#pragma mark - UItableViewDataSource or delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrays.count + 1;
//    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        YMBannerViewCell *cell = [YMBannerViewCell configCell:tableView withBannerPosition:@"00"];
        cell.delegate          = self;
     
        return cell;
    } else {
        YMHomeColumnCell *cell = [YMHomeColumnCell configCell:tableView withColumns:self.arrays[indexPath.section - 1]];
        cell.delegate = self;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return BANNERHEIGHT;
    
    YMHomeColumnModel *column = self.arrays[indexPath.section - 1];
    return column.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (self.tableView.contentOffset.y <= 100) {
        self.tableView.bounces = NO;
    }
    else
    {
        self.tableView.bounces = YES;
    }
}

#pragma mark - customDelegate
//YMBannerViewCellDelegate
-(void)bannerViewCell:(YMBannerViewCell *)cell bannerButtonDidClick:(NSString *)h5url
{
  
    if (h5url.length > 0) {
        YMHomeH5VC * webVC = [[YMHomeH5VC alloc] init];
        webVC.loadUrl = h5url;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
    
        [MBProgressHUD showText:MSG0];

//    YMHomeH5VC *h5vc = [[YMHomeH5VC alloc]init];
//    h5vc.loadUrl     = @"http://test.cbapay.com/wap/collection.jsp?merchantId=00000000000197";
//    [self.navigationController pushViewController:h5vc animated:YES];
}
//YMHomeColumnCellDelegate
-(void)homeColumnCell:(YMHomeColumnCell *)cell columnsDidClick:(NSString *)h5url
{
   
    if (h5url.length > 0) {
        YMHomeH5VC *h5vc = [[YMHomeH5VC alloc]init];
        h5vc.loadUrl     = h5url;
        [self.navigationController pushViewController:h5vc animated:YES];
        return;
    }
    
//  #warning 暂时提示
    [MBProgressHUD showText:MSG0];
    

}

#pragma mark headerDelegate
-(void)topView:(YMHomeTopView *)view itemDidClick:(NSInteger)index
{
    NSArray *vcArray1 = @[@"YMScanViewController",
                          @"YMPayCodeVC",
                          @"YMCardPackageVC",
                          @"YMCollectionVC"];
    
        //未登录
        if (![YMUserInfoTool shareInstance].loginStatus) {
            [MBProgressHUD showText:@"请您登陆"];
            return ;
        }
        //未实名
        if ([YMUserInfoTool shareInstance].usrStatus == -1) {
            [self.promptBoxView show];
            return;
        }
        
        if (index == 1) {
#warning 暂时提示
            [MBProgressHUD showText:@"正在建设中，敬请期待!"];
            return;
        }
        NSString *vcName     = vcArray1[index];
        Class  vcClass       = NSClassFromString(vcName);
        UIViewController *vc = [[vcClass alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
}

-(void)bottomView:(YMHomeBottomView *)view itemDidClick:(NSInteger)index
{
    
    NSArray *vcArray = @[@"YMTransferVC",
                         @"YMMyBankCardController",
                         @"YMMobileRechargeVC",
                         @"YMEasyPaymentVC",
                         @"YMTravelTicketVC",
                         @"YMAllVC"];
    
        //未登录
        if (![YMUserInfoTool shareInstance].loginStatus) {
            [MBProgressHUD showText:@"请您登陆"];
            return ;
        }
        //未实名
        if ([YMUserInfoTool shareInstance].usrStatus == -1) {
            [self.promptBoxView show];
            return;
        }
        
//        if (index == 1) {
//
//            [MBProgressHUD showText:MSG0];
//            return;
//        }
        NSString *vcName      = vcArray[index];
        Class  vcClass        = NSClassFromString(vcName);
        UIViewController *vc  = [[vcClass alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 自定义点击
-(void)leftBtnClick:(UIBarButtonItem *)item
{
 
    
    UIViewController *vc = nil;
    if (item.tag == 1) {
        vc = [[AccountViewController alloc]init];
    } else {
        vc = [[LandViewController alloc]init];
    }
    [self.navigationController pushViewController:vc animated:YES];
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
