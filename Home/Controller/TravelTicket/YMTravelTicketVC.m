//
//  YMTravelTicketVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTravelTicketVC.h"
#import "YMBannerViewCell.h"
#import "YMTravelTicketTableViewCell.h"

@interface YMTravelTicketVC ()<UITableViewDelegate,UITableViewDataSource,YMBannerViewCellDelegate,TicketFunctionDelegate>
@property (nonatomic, strong) UITableView * gtableView;
@property (nonatomic, strong) NSArray * allFunction;

@end

@implementation YMTravelTicketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"旅游票务";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    [self.gtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets=UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}
-(NSArray *)allFunction
{
    if (!_allFunction) {
        _allFunction = @[
                         @[
                             @{@"imgName":@"酒店",@"h5Url":@""},
                             @{@"imgName":@"特价酒店",@"h5Url":@""},
                             @{@"imgName":@"小猪短租",@"h5Url":@""},
                             @{@"imgName":@"国际酒店",@"h5Url":@""},
                             @{@"imgName":@"会议中心",@"h5Url":@""},
                             
                           ],
                         @[
                             @{@"imgName":@"出行",@"h5Url":@""},
                             @{@"imgName":@"机票",@"h5Url":@""},
                             @{@"imgName":@"火车票",@"h5Url":@""},
                             @{@"imgName":@"汽车票",@"h5Url":@""},
                             @{@"imgName":@"打车",@"h5Url":@""},
                             
                             ],
                         @[
                             @{@"imgName":@"旅行",@"h5Url":@""},
                             @{@"imgName":@"景点公园",@"h5Url":@""},
                             @{@"imgName":@"自由行",@"h5Url":@""},
                             @{@"imgName":@"旅游团购",@"h5Url":@""},
                             @{@"imgName":@"周边短途",@"h5Url":@""},
                             ],
                         ];
    }
    return _allFunction;
}
-(UITableView *)gtableView
{
    if (!_gtableView) {
        _gtableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _gtableView.delegate = self;
        _gtableView.dataSource = self;
        _gtableView.scrollEnabled = NO;
        _gtableView.tableFooterView = [UIView new];
        _gtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _gtableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_gtableView];
    }
    
    return _gtableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.allFunction.count;
            break;
        default:
            return 0;
            break;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        static NSString * identifier = @"cell";
//
        YMTravelTicketTableViewCell * oneCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!oneCell) {
            oneCell = [[YMTravelTicketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        oneCell.dicArr = self.allFunction[indexPath.row];
        oneCell.delegate = self;
        return oneCell;
        
        
    }else if (indexPath.section == 0)
    {
        YMBannerViewCell * cell = [YMBannerViewCell configCell:tableView withBannerPosition:@"04"];
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return  SCREENWIDTH*ROWProportion*2;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)didSelectTicketFunctionItem:(NSDictionary *)dic
{
    [MBProgressHUD showText:MSG0];
    YMLog(@"%@", dic);
}
-(void)bannerViewCell:(YMBannerViewCell *)cell bannerButtonDidClick:(NSString *)h5url
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
