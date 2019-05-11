//
//  VersionNotesViewController.m
//  WSYMPay
//
//  Created by jey on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "VersionNotesViewController.h"
#import "ProtocolViewController.h"
@implementation versionModel
@end
@interface VersionNotesViewController ()
@property (nonatomic,strong) versionModel *model;
@end

@implementation VersionNotesViewController
- (instancetype)init
{
    
    return [self initWithStyle:UITableViewStylePlain];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadData];
}
-(void)setupTableView
{
    
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"设置";
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
    //    if (section == 0) {
    //        return 5;
    //    }else {
    //        return 2;
    //    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
        cell.accessoryType             = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle            = UITableViewCellSelectionStyleNone;
        cell.backgroundColor           = [UIColor whiteColor];
        cell.textLabel.font            = COMMON_FONT;
        cell.detailTextLabel.font      = COMMON_FONT;
        cell.textLabel.textColor       = RGBColor(0, 0, 0);
        cell.detailTextLabel.textColor = RGBColor(115, 115, 115);
        
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"版本号";
                
                break;
            case 1:
                cell.textLabel.text=@"检查更新";
                
                break;
            case 2:
            {
                cell.textLabel.text=@"版权信息";
        
                break;
            }
            case 3:
                cell.textLabel.text=@"服务协议";
                cell.tag=3;
                
                break;
            
            default:
                break;
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
         [MBProgressHUD showText:[NSString stringWithFormat:@"当前版本是：%@",self.model.ymqb_ver_ios]];
    }
    else if (indexPath.row == 1) {
        if ([self.model.ymqbVerStatus isEqualToString: @"1"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"立即更新" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.ymqb_ver_ios]];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [self presentViewController:alertController animated:YES completion:nil];

        }
        else {
            [MBProgressHUD showText:[NSString stringWithFormat:@"当前已经是最新版本"]];
        }
    }
    else if (indexPath.row == 3) {
        ProtocolViewController *vc = [[ProtocolViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)loadData {
    RequestModel *params = [[RequestModel alloc] init];
    params.tranCode = @"900277";
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        self.model = [versionModel mj_objectWithKeyValues:responseObject[@"data"]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
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
