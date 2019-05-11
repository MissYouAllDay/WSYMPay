//
//  YMEasyPaymentVC.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/8.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMEasyPaymentVC.h"
#import "YMEasyPayTableViewCell.h"

@interface YMEasyPaymentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * gtableView;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, retain) UIView * headerV;

@end

@implementation YMEasyPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"便民缴费";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    [self.gtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets=UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}
-(NSArray *)titleArray
{
    _titleArray = @[@{@"icon":@"电费",
                      @"title":@"电费",
                      @"detail":@"可添加"
                      },
                    @{@"icon":@"水费",
                      @"title":@"水费",
                      @"detail":@"可添加"
                      },
                    @{@"icon":@"燃气费",
                      @"title":@"燃气费",
                      @"detail":@"可添加"
                      },
                    @{@"icon":@"固话",
                      @"title":@"固话",
                      @"detail":@"可添加"
                      },
                    @{@"icon":@"宽带",
                      @"title":@"宽带",
                      @"detail":@"可添加"
                      },
                    @{@"icon":@"暖气费",
                      @"title":@"暖气费",
                      @"detail":@"可添加"
                      },
                    
                    ];
    return _titleArray;
}

-(UITableView *)gtableView
{
    if (!_gtableView) {
        _gtableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _gtableView.delegate = self;
        _gtableView.dataSource = self;
        _gtableView.scrollEnabled = YES;
        _gtableView.tableFooterView = [UIView new];
        [self.view addSubview:_gtableView];
    }
    
    return _gtableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier = @"Cell";
    
    YMEasyPayTableViewCell * oneCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!oneCell) {
        oneCell = [[YMEasyPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    oneCell.titleL.text = self.titleArray[indexPath.row][@"title"];
    oneCell.detailL.text = self.titleArray[indexPath.row][@"detail"];
    oneCell.iconImg.image = [UIImage imageNamed:self.titleArray[indexPath.row][@"icon"]];
    
    return oneCell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
       return self.headerV;
}
-(UIView *)headerV
{
    if (!_headerV) {
        
        _headerV = [UIView new];
        _headerV.backgroundColor = [UIColor whiteColor];
        _headerV.x = _headerV.y = 0;
        _headerV.width = SCREENWIDTH;
        _headerV.height = SCREENWIDTH*ROWProportion*0.8;
        
        UIImageView * imgV = [UIImageView new];
        imgV.image = [UIImage imageNamed:@"home_标题色块1"];
        [_headerV addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.width.mas_equalTo(2);
            make.centerY.mas_equalTo(_headerV.mas_centerY);
            make.height.mas_equalTo(_headerV.mas_height).multipliedBy(0.4);
            
        }];
        
        UILabel * titleL = [UILabel new];
        [_headerV addSubview:titleL];
        titleL.font = [UIFont systemFontOfMutableSize:13];\
        titleL.text = @"缴费账户";
        [titleL sizeToFit];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgV.mas_right).offset(4);
            make.centerY.mas_equalTo(_headerV.mas_centerY);
            make.height.mas_equalTo(_headerV.mas_height);
        }];
        
        UIImageView * bottomLine = [UIImageView new];
        [_headerV addSubview:bottomLine];
        bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(_headerV.mas_bottom);
        }];
        
    }
    return _headerV;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SCREENWIDTH*ROWProportion*0.8;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  SCREENWIDTH*ROWProportion;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showText:MSG0];
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
