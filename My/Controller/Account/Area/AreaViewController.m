//
//  ProvinceViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "AreaViewController.h"
#import "CityesViewController.h"
#import "ProvinceModel.h"
#import <MJExtension.h>
#import "YMLocationTool.h"
#define LOCATIONMSG  @"正在定位中..."

#define LOCATIONERRORMSG1 @"定位失败"

#define LOCATIONERRORMSG2 @"网络故障"
@interface AreaViewController ()

@property (nonatomic, strong)  NSArray           *titleArray;

@property (nonatomic, strong)  NSDictionary      *cityesDict;

@property (nonatomic, weak)    UITableViewCell   *locationCell;

@property (nonatomic, copy)    NSString          *currentCity;
@end

@implementation AreaViewController

- (instancetype)init
{
  
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setLocationStatus:LOCATIONMSG];
    [[YMLocationTool sharedInstance]startLocationWithCurrentLocation:^(NSString *location, NSString *latitude, NSString *longitude) {
        [self setLocationStatus:location];
    } locationError:^(NSString *error) {
        [self setLocationStatus:error];
    }];
    
}

-(void)setupTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"地区";
    self.tableView.backgroundColor =VIEWGRAYCOLOR;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _titleArray = [ProvinceModel mj_objectArrayWithFilename:@"provinces.plist"];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"address" ofType:@"plist"];
        _cityesDict =[[NSDictionary alloc]initWithContentsOfFile:path];
        [self.tableView reloadData];
    });
    
}

//设置定位cell的显示状态
-(void)setLocationStatus:(NSString *)status
{
    self.locationCell.textLabel.text = status;
    self.currentCity = status;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  HEADERSECTION_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cityName    = cell.textLabel.text;
    
    CityesViewController *cityesVC = [[CityesViewController alloc]init];
    cityesVC.cityesArray = [self getCityesArray:cityName];
    cityesVC.provinceName = cityName;
    
    if (cityesVC.cityesArray.count == 0) {
        
        if ([cityName isEqualToString:LOCATIONMSG] || [cityName isEqualToString:LOCATIONERRORMSG1] || [cityName isEqualToString:LOCATIONERRORMSG2]) {
            self.locationCell.textLabel.text = LOCATIONMSG;
            [[YMLocationTool sharedInstance]startLocationWithCurrentLocation:^(NSString *location, NSString *latitude, NSString *longitude) {
                [self setLocationStatus:location];
            } locationError:^(NSString *error) {
                [self setLocationStatus:error];
            }];

            return;
        }
        
        NSMutableDictionary *cityInfo = [NSMutableDictionary dictionary];
        cityInfo[WSYMSelectedCityName] = cityName;
        [WSYMNSNotification postNotificationName:WSYMSelectedCityNotification object:nil userInfo:cityInfo];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
    
        [self.navigationController pushViewController:cityesVC animated:YES];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return (self.titleArray.count +1);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return nil;
    }
    
    ProvinceModel *provinceModel = _titleArray[section -1];
    
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = RGBColor(242, 242, 242);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE, 0, SCREENWIDTH, HEADERSECTION_HEIGHT)];
    titleLabel.textColor=RGBColor(157, 157, 157);
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text=provinceModel.title;
    [myView addSubview:titleLabel];
    return myView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
        
    } else {
    
    
        ProvinceModel *provinceModel = _titleArray[section -1];
    
        return provinceModel.cityes.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *ID = @"cell";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfMutableSize:15];
        cell.textLabel.textColor = RGBColor(132, 132, 132);
    }
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"location"];
        cell.textLabel.text = self.currentCity?self.currentCity:LOCATIONMSG;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.locationCell = cell;
        return cell;
    } else {
    
        
        ProvinceModel *provinceModel = _titleArray[indexPath.section -1];
        NSString *areaStr = provinceModel.cityes[indexPath.row];
        NSArray *cityesArray = [self getCityesArray:areaStr];
        cell.textLabel.text = areaStr;
        cell.imageView.image = nil;
        if (cityesArray.count == 0) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
    
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH * ROWProportion);
}

//获取城市
-(NSArray *)getCityesArray:(NSString *)name
{

    NSString *keyName = [self transform:name];
   
    return [self.cityesDict objectForKey:keyName];

}

//将字体转换为拼音
-(NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [[pinyin stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
}

@end
