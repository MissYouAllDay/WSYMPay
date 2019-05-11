//
//  YMPaymentChangeTableViewController.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/20.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMPaymentChangeTableViewController.h"
#import "YMRedBackgroundButton.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
#import "YMBankCardModel.h"
#import "NSString+AES.h"

@interface YMPaymentChangeTableViewController ()

@property (nonatomic) NSInteger selectRow;

@property (nonatomic)NSInteger defaultPayment;
@property (nonatomic,strong)NSMutableArray * payArr;

@end

@implementation YMPaymentChangeTableViewController
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"默认付款方式";
    
    
    [self setupTableView];
    
    [self loadRequestData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setupTableView
{
    
    self.view.backgroundColor = VIEWGRAYCOLOR;
  
    
    UIView * footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*ROWProportion*2)];
    footerV.backgroundColor = VIEWGRAYCOLOR;
    UIButton * but = [[YMRedBackgroundButton alloc] init];
   
    [but setTitle:@"确    定" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(sureChange) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:but];
    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.bottom.mas_equalTo(footerV.mas_bottom);
    }];
    
    self.tableView.tableFooterView =footerV;
}

-(void)loadRequestData
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = currentInfo.token;
    params.tranCode      = AUTOPAYTYPECODE;
    __weak typeof(self) weakSelf = self;
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        if (resCode == 1) {
            self.defaultPayment = [responseObject[@"data"][@"defaultPayment"] intValue];
            YMBankCardModel * firstModel = [YMBankCardModel new];
            firstModel.bankName = @"账户余额";
            firstModel.bankAcNo = @"";
            firstModel.paySign = @"";
            if (self.defaultPayment == 0) {
                firstModel.defaultCard = YES;
            }
            [self.payArr addObject:firstModel];
            [self.payArr addObjectsFromArray:[YMBankCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]]];
            [self.tableView reloadData];
        } else {
            NSString * resMsg = responseObject[@"resMsg"];
            [MBProgressHUD showText:resMsg];
        }
        
    } failure:^(NSError *error) {
    }];
}

-(NSMutableArray *)payArr
{
    if (!_payArr) {
        _payArr = [NSMutableArray new];
    }
    return _payArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.payArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    YMBankCardModel * model =  self.payArr[indexPath.row];
    NSString * cardType = @"";
    switch (model.cardType) {
        case 1:
            cardType = @"储蓄卡";
            break;
        case 2:
            cardType = @"信用卡";
            break;
            
        default:
            break;
    }
    
    NSMutableString * title = [NSMutableString stringWithFormat:@"%@ %@",model.bankName,cardType];
    if (model.bankAcNo.length>0) {
         [title appendString:[NSString stringWithFormat:@"(%@)",[model.bankAcNo decryptAES]]];
    }
   
    cell.textLabel.text = title;

    
    cell.textLabel.font = COMMON_FONT;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tintColor = NAVIGATIONBARCOLOR;
    
    if (model.defaultCard) {
        self.selectRow = indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YMBankCardModel * modelOld =  self.payArr[self.selectRow];
    modelOld.defaultCard = NO;
    
    YMBankCardModel * modelNew =  self.payArr[indexPath.row];
    modelNew.defaultCard = YES;
    
    [self.tableView reloadData];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREENWIDTH*ROWProportion;
}
/**
 确认 按钮
 */
-(void)sureChange
{
    [self changeRequestData];
}

-(void)changeRequestData
{
     [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    NSString * defaultPayment = @"1";
    
    if (self.selectRow == 0) {
        defaultPayment = @"0";
    }
    YMBankCardModel * model = self.payArr[self.selectRow];
    NSString * paySign = model.paySign;
    NSDictionary * paramDic = @{
                                    @"token":currentInfo.token,
                                    @"tranCode":CHANGEPAYTYPECODE,
                                    @"defaultPayment":defaultPayment,
                                    @"paySign":paySign
                                    
                                    };
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:paramDic success:^(id responseObject) {
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        [MBProgressHUD showText:resMsg];
        if (resCode == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
