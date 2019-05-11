//
//  YMCardPackageVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCardPackageVC.h"
#import "YMBannerViewCell.h"
#import "YMMyBankCardController.h"

@interface YMCardPackageVC ()<UITableViewDelegate,UITableViewDataSource,YMBannerViewCellDelegate>
@property (nonatomic, strong) UITableView * gtableView;
@property (nonatomic, strong) NSArray * titleArray;

@end

@implementation YMCardPackageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"卡卷包";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    [self.gtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets=UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}
-(NSArray *)titleArray
{
    _titleArray = @[@"我的银行卡"];
    return _titleArray;
}

-(UITableView *)gtableView
{
    if (!_gtableView) {
        _gtableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _gtableView.delegate = self;
        _gtableView.dataSource = self;
        _gtableView.scrollEnabled = NO;
        _gtableView.tableFooterView = [UIView new];
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
            return self.titleArray.count;
            break;
        case 1:
            return 1;
            break;
            
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString * identifier = @"oneCell";
        
        UITableViewCell * oneCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!oneCell) {
            oneCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        oneCell.textLabel.text = self.titleArray[indexPath.row];
        oneCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        oneCell.textLabel.font = COMMON_FONT;
        return oneCell;
        
        
    }else if (indexPath.section == 1)
    {
        YMBannerViewCell * cell = [YMBannerViewCell configCell:tableView withBannerPosition:@"05"];
        cell.delegate = self;
//        cell.isOnlyShowText = YES;
        return cell;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return  SCREENWIDTH*ROWProportion;
            break;
        case 1:
            return  SCREENWIDTH*ROWProportion*2;
            break;
            
        default:
            break;
    }
    return  0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            YMMyBankCardController *myBankCardVC = [[YMMyBankCardController alloc]init];
            [self.navigationController pushViewController:myBankCardVC animated:YES];
            return;
        }
        [MBProgressHUD showText:MSG0];
    }
    
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
