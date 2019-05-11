//
//  FinancialViewController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "FinancialViewController.h"
#import "FinancialTool.h"
#import "YMCustomHeader.h"
#import "YMCollectionModel.h"
#import "YMUserInfoTool.h"
#import "YMColumnModel.h"
#import "YMColumnImageModel.h"
#import "YMHomeH5VC.h"
#import "PromptBoxView.h"
#import "FirstRealNameCertificationViewController.h"


@interface FinancialViewController ()<FinancialToolDelegate,PromptBoxViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FinancialTool *collectionViewTool;
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@end

@implementation FinancialViewController

#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self.collectionView.mj_header beginRefreshing];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self collectionView]];
    
    [self collectionViewTool].registerCellArr = @[
                                                  @{@"name":@"YMFinancialBannerCell",
                                                    @"isXib":@YES
                                                    },
                                                  @{@"name":@"YMFinancialClassCell",
                                                    @"isXib":@YES
                                                    },
                                                  @{@"name":@"YMFinancialListCell",
                                                    @"isXib":@YES
                                                    }
                                                  ];
    [self collectionViewTool].registerSectionHeaderArr = @[
                                                           @{@"name":@"YMFinancialListHeaderView",
                                                             @"isXib":@YES
                                                             }
                                                           ];
    [self collectionViewTool].registerSectionFooterArr = @[
                                                           @{@"name":@"YMSpecReusableView",
                                                             @"isXib":@YES
                                                             }
                                                           ];
    
  
    [self.collectionView reloadData];
    
   
}
- (void)setData:(NSDictionary *)responseDic
{
    
    YMCollectionModel * classModel1 = [YMCollectionModel new];
    classModel1.imgName = @"financial_1-1";
    classModel1.nextVC = @"新手";
    
    YMCollectionModel * classModel2 = [YMCollectionModel new];
    classModel2.imgName = @"financial_1-2";
    classModel1.nextVC = @"定期理财";
    
    YMCollectionModel * classModel3 = [YMCollectionModel new];
    classModel3.imgName = @"financial_1-3";
    classModel1.nextVC = @"活期理财";
    
    YMCollectionModel * classModel4 = [YMCollectionModel new];
    classModel4.imgName = @"financial_1-4";
    classModel1.nextVC = @"基金理财";
    
    NSArray * modelList = [YMColumnModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"][@"LIST"]];
    
    
    NSMutableArray * colummArr = [NSMutableArray new];
    for (YMColumnModel * model in modelList) {
        for (YMColumnImageModel * imgModel in model.C_IMAGE ) {
            YMCollectionModel * collectionModel = [YMCollectionModel new];
            collectionModel.webUrl = imgModel.url;
            collectionModel.imgUrl = imgModel.image;
            [colummArr addObject:collectionModel];
        }
    }
    
    
    [self collectionViewTool].allArr = @[
                                         @{
                                             @"itemCell":@"YMFinancialBannerCell",
                                             @"column":@"1",
                                             @"title":@"",
                                             @"multipliedBy":@"0.27",
                                             @"sectionHeader":@"",
                                             @"sectionFooter":@"YMSpecReusableView",
                                             @"sizeForHeader":@"0",
                                             @"sizeForFooter":@"6",
                                             @"function":@[[YMCollectionModel new]]
                                             
                                             },
                                         
                                         @{
                                             @"itemCell":@"YMFinancialClassCell",
                                             @"column":@"2",
                                             @"title":@"",
                                             @"multipliedBy":@"0.4",
                                             @"sectionHeader":@"",
                                             @"sectionFooter":@"YMSpecReusableView",
                                             @"sizeForHeader":@"0",
                                             @"sizeForFooter":@"6",
                                             @"function":@[classModel1,classModel2,classModel3,classModel4]
                                             
                                             },
                                         
                                         @{
                                             @"itemCell":@"YMFinancialListCell",
                                             @"column":@"1",
                                             @"title":[[modelList firstObject] C_TITLE],
                                             @"multipliedBy":@"0.2",
                                             @"sectionHeader":@"YMFinancialListHeaderView",
                                             @"sectionFooter":@"",
                                             @"sizeForHeader":@"42",
                                             @"sizeForFooter":@"0",
                                             @"function":colummArr
                                             
                                             }
                                         
                                         ];
    

}
- (void)tableViewHeaderRefresh
{
    //    栏目类型 1首页 2理财 3发现
    NSDictionary * paramDic = @{
//                                @"token":user.token,
                                @"C_TYPE":@"2",
                                @"tranCode":COLUMNCODE
                                
                                };
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        
        [[self collectionView].mj_header endRefreshing];
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        if (resCode == 1) {
            
            [self setData:responseObject];
        }else
        {
            [MBProgressHUD showText:resMsg];
        }
        
        
    } failure:^(NSError *error) {
        [[self collectionView].mj_header endRefreshing];
    }];
    

    
    
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectBannerMethodWithIndex:(NSString *)h5Url
{
    
    if (h5Url.length > 0) {
        YMHomeH5VC * webVC = [[YMHomeH5VC alloc] init];
        webVC.loadUrl = h5Url;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
    [MBProgressHUD showText:MSG0];
}
- (void)selectItemWithModel:(YMCollectionModel *)model
{

    
    if (model.webUrl.length > 0) {
        YMHomeH5VC * webVC = [[YMHomeH5VC alloc] init];
        webVC.loadUrl = model.webUrl;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
//    if (model.nextVC.length > 0) {
//        
//        Class clas = NSClassFromString(model.nextVC);
//        UIViewController * nextVC = [clas new];
//        [self.navigationController pushViewController:nextVC animated:YES];
//        return;
//    }
    [MBProgressHUD showText:MSG0];
}

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (UICollectionView *) collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) collectionViewLayout:layout];
        _collectionView.dataSource = [self collectionViewTool];
        _collectionView.delegate = [self collectionViewTool];
        _collectionView.scrollEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:VIEWGRAYCOLOR];
        
        _collectionView.mj_header = [YMCustomHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefresh)];
    }
    return _collectionView;
}

- (FinancialTool *)collectionViewTool
{
    if (!_collectionViewTool) {
        _collectionViewTool = [[FinancialTool alloc] initWithCollectionViewFrame:self.collectionView.frame];
        _collectionViewTool.collectionView = [self collectionView];
        _collectionViewTool.delegate = self;
    }
    return _collectionViewTool;
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
