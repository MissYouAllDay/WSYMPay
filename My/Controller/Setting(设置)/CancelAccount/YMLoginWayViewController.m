//
//  YMLoginWayViewController.m
//  WSYMPay
//
//  Created by jey on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMLoginWayViewController.h"
#import "YMLoginWayViewCell.h"
@interface YMLoginWayViewController ()
/** 选中的位置 */
@property (nonatomic, copy) NSString *index;

@end

@implementation YMLoginWayViewController

- (instancetype)init
{
    
    return [self initWithStyle:UITableViewStylePlain];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
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
    return 2;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMLoginWayViewCell *cell = [[YMLoginWayViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.value = @[@"指纹",@"手势"][indexPath.row];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        
        NSString * rightswitchOne = [USER_DEFAULT objectForKey:@"rightswitchOne"];

        if ([rightswitchOne isEqualToString:@"1"]) {
            
            cell.rightswitch.on = YES;

        }else{
            cell.rightswitch.on = NO;

        }
        
    }else if (indexPath.row == 1){
        
        NSString * rightswitchOne = [USER_DEFAULT objectForKey:@"rightswitchTwo"];
        
        if ([rightswitchOne isEqualToString:@"1"]) {
            
            cell.rightswitch.on = YES;
            
        }else{
            cell.rightswitch.on = NO;
            
        }

    }
    cell.tag = 1020+indexPath.row;
    cell.rightswitch.tag = 1020+indexPath.row;
    [cell.rightswitch addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];

    
    return cell;
    
    
}
-(void)valueChanged:(UISwitch*)sender
{
    NSString * taginter = [NSString stringWithFormat:@"%ld",sender.tag-1020];
    
    if ([taginter isEqualToString:@"0"]) {
        NSString * rightswitchOne = [USER_DEFAULT objectForKey:@"rightswitchOne"];
        if ([rightswitchOne isEqualToString:@"1"]) {
            [USER_DEFAULT setObject:@"2" forKey:@"rightswitchOne"];

        }else{
            [USER_DEFAULT setObject:@"1" forKey:@"rightswitchOne"];
            [USER_DEFAULT setObject:@"2" forKey:@"rightswitchTwo"];
        }
    }else if ([taginter isEqualToString:@"1"]){
        NSString * rightswitchOne = [USER_DEFAULT objectForKey:@"rightswitchTwo"];
        if ([rightswitchOne isEqualToString:@"1"]) {
            [USER_DEFAULT setObject:@"2" forKey:@"rightswitchTwo"];
            
        }else{
            [USER_DEFAULT setObject:@"1" forKey:@"rightswitchTwo"];
            [USER_DEFAULT setObject:@"2" forKey:@"rightswitchOne"];
        }
    }
    [self.tableView reloadData];
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
