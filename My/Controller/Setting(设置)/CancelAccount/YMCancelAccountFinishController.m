//
//  YMCancelAccountFinishController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCancelAccountFinishController.h"
#import "YMCancelReasonCell.h"
#import "YMRedBackgroundButton.h"
#import "YMUserInfoTool.h"
#import "YMSelectModel.h"//互斥选择model
#import "YMMyHttpRequestApi.h"
#import "YMResponseModel.h"

@interface YMCancelAccountFinishController ()

@property (nonatomic, strong) NSArray *reasonArray;
@property (nonatomic, assign) BOOL selectedOtherReason;
@property (nonatomic, weak) YMCancelReasonCell *selectedCell;
@property (nonatomic, weak) YMRedBackgroundButton *determineBtn;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, copy) NSString *reasonStr;

@end

@implementation YMCancelAccountFinishController
#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{

    return [self initWithStyle:UITableViewStyleGrouped];
}
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.view.tag = 500;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}
#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.tableView.delaysContentTouches = NO;
    self.navigationItem.title = @"注销账户";
    self.navigationItem.hidesBackButton = YES;
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame           = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*ROWProportion * 2);
    
    UILabel *titleLabel      = [[UILabel alloc]init];
    titleLabel.text          = @"注销账户成功,感谢您的使用!";
    titleLabel.textColor     = FONTDARKCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font          = [UIFont systemFontOfMutableSize:17];
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(topView.mas_centerX);
        make.centerY.equalTo(topView.mas_centerY);
        
    }];
    self.tableView.tableHeaderView = topView;
    
    //确定按钮
    YMRedBackgroundButton*determineBtn = [[YMRedBackgroundButton alloc]init];
    [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [determineBtn addTarget:self action:@selector(determineBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:determineBtn];
    self.determineBtn = determineBtn;

    self.reasonArray = @[@"觉得网上有名支付不安全,卡里的钱有风险",@"能支付的地方太少,不能满足我的需求",@"名下账户太多,注销不常用的账号",@"其他原因,二十字以内"];
}

#pragma mark - eventResponse                - Method -
-(void)determineBtnClick
{
    if (self.selectedOtherReason == YES) {
        self.reasonStr = self.selectedCell.inputText;
    }
    WEAK_SELF;
    [YMMyHttpRequestApi loadHttpRequestWithSaveReason:weakSelf.reasonStr Success:^(YMResponseModel *model) {
        STRONG_SELF;
        [[YMUserInfoTool shareInstance] removeUserInfoFromSanbox];
        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return self.reasonArray.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView* myView         = [[UIView alloc] init];
        myView.backgroundColor = RGBColor(242, 242, 242);
        CGFloat y = ((SCREENWIDTH * ROWProportion) - HEADERSECTION_HEIGHT)/2;
        UILabel *titleLabel    = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE / 2, y, SCREENWIDTH, HEADERSECTION_HEIGHT)];
        titleLabel.textColor   = FONTDARKCOLOR;
        titleLabel.font        = COMMON_FONT;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text=@"请选择注销原因:";
        [myView addSubview:titleLabel];
        return myView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"cell";
    
    YMCancelReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMCancelReasonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
     cell.title = self.reasonArray[indexPath.row];
    
    if (indexPath.row == (self.reasonArray.count - 1)) {
        
        CGRect  rect = [tableView rectForRowAtIndexPath:indexPath];
    
        CGFloat w = SCREENWIDTH * 0.9;
        CGFloat h = SCREENWIDTH * ROWProportion;
        CGFloat x = (SCREENWIDTH - w) /2;
        CGFloat y = CGRectGetMaxY(rect) + (SCREENWIDTH * ROWProportion) * 0.5;
        
        self.determineBtn.frame = CGRectMake(x, y, w, h);
    }
    //互斥选择实现（通过改变model）:
    /*********/
    YMSelectModel *selectModel = self.selectArray[indexPath.row];
    cell.selectedButton = selectModel.isSelect;
    /*********/
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //互斥选择实现（通过改变model）:
    /*********/
    if (self.reasonArray.count>0) {
        self.selectArray  = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<self.reasonArray.count; i++) {
            YMSelectModel *selectModel = [[YMSelectModel alloc] init];
            selectModel.isSelect = NO;
            [self.selectArray addObject:selectModel];
        }
        YMSelectModel *selectModel = self.selectArray[indexPath.row];
        selectModel.isSelect = !selectModel.isSelect;
    }
    
    YMCancelReasonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedCell = cell;
    
    if (indexPath.row == 3) {
        self.selectedOtherReason =  YES;
        self.reasonStr = self.selectedCell.inputText;
    } else {
        self.selectedOtherReason = NO;
        self.reasonStr = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    }
    YMLog(@"self.reasonStr = %@",self.reasonStr);
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedOtherReason && indexPath.row == 3) {
        return (SCREENWIDTH * ROWProportion) * 3;
    }
    return (SCREENWIDTH * ROWProportion);

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SCREENWIDTH * ROWProportion;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.01;
}

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - getters and setters          - Method -
- (void)setModel:(YMResponseModel *)model
{
    _model = model;
    if (_model == nil) {
        return;
    }
    [self.tableView reloadData];
}

@end
