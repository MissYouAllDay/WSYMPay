//
//  CityesViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/21.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "CityesViewController.h"

@interface CityesViewController ()

@end

@implementation CityesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

-(instancetype)init
{

    return [self initWithStyle:UITableViewStyleGrouped];

}

-(void)setupTableView
{
    
    self.view.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"地区";
//    self.tableView.ed
    
    self.tableView.tableFooterView =[[UIView alloc] init];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return SCREENWIDTH * ROWProportion ;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  HEADERSECTION_HEIGHT;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.cityesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"cityesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfMutableSize:14];
        cell.textLabel.textColor = RGBColor(132, 132, 132);
    }
    
    cell.textLabel.text = self.cityesArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary *cityInfo = [NSMutableDictionary dictionary];
    cityInfo[WSYMSelectedCityName] = [NSString stringWithFormat:@"%@ %@",self.provinceName,cell.textLabel.text];
    
    [WSYMNSNotification postNotificationName:WSYMSelectedCityNotification object:nil userInfo:cityInfo];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
}
@end
