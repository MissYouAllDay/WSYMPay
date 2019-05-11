//
//  YMPayBankCarListView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/15.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPayBankCardListView.h"
#import "YMPayBankCardCell.h"
#import "YMBankCardModel.h"
#import "YMSelectModel.h"//互斥选择model
#import "YMBankCardDataModel.h"

@interface YMPayBankCardListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView   *contentView;

@property (nonatomic, weak) UIButton *quitButton;

@property (nonatomic, weak) UILabel  *titleLabel;

@property (nonatomic, weak) UIView   *lineView;

@property (nonatomic, weak) UITableView *bankCardTableView;

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, strong) NSMutableArray *canPayDataArray;

@property (nonatomic, strong) NSMutableArray *noCanPayDataArray;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) YMBankCardModel *selectBankModel;

@property (nonatomic, assign) BOOL yuESelected;

@end

@implementation YMPayBankCardListView
#pragma mark - lifeCycle                    - Method -
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
        self.fromFlag = 1;
        self.yuESelected = NO;
    }
    return self;
}
#pragma mark - privateMethods               - Method -
-(void)setupSubviews
{
    
    self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.5);
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *quitButton = [[UIButton alloc]init];
    [quitButton setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:quitButton];
    self.quitButton = quitButton;
    
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.font          = COMMON_FONT;
    titleLabel.textColor     = FONTDARKCOLOR;
    titleLabel.text          = @"选择支付方式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *lineView         = [[UIView alloc]init];
    lineView.backgroundColor = LAYERCOLOR;
    [contentView addSubview:lineView];
    self.lineView = lineView;
    
    UITableView *bankCardTableView    = [[UITableView alloc]init];
    bankCardTableView.delegate        = self;
    bankCardTableView.dataSource      = self;
    bankCardTableView.tableFooterView = [[UIView alloc]init];
    [contentView addSubview:bankCardTableView];
    self.bankCardTableView = bankCardTableView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(SCREENHEIGHT * 0.3 + 216);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
    }];
    
    CGFloat H = SCREENWIDTH*ROWProportion;
    
    CGFloat interVal = (H - self.titleLabel.bounds.size.height) / 2;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(interVal);
    }];

    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(H);
        make.height.mas_equalTo(H);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.contentView.mas_left);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(interVal);
    }];
    
    [self.bankCardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

-(void)show
{
    self.frame = KEYWINDOW.bounds;
    [KEYWINDOW addSubview:self];
}

/**
 每个section中测 cell 对应的个数
 */
- (NSInteger)getItemCountWithSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0) {
        count = [self canPayDataArray].count;
    }else if (section == 1){
        count = self.fromFlag==2?1:0;
    }else if (section == 2){
        count = 1;
    }else{
        count = [self noCanPayDataArray].count;
    }
    return count;
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;//(可支付银行卡，余额，使用其他银行卡，不可支付的卡)
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getItemCountWithSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {//余额 当fromFlag=2时才显示 临时先用这个代替
        
        static NSString *cellId = @"YMPayBankCardCell";
        YMPayBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[YMPayBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        [cell sendSelectYuEWithBankCardDataModel:self.bankCardDataModel yuEIsSelected:self.yuESelected];
        return cell;
        
    }else if (indexPath.section == 2){//使用其他银行卡
        
        NSString *OTHERID = @"otherCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OTHERID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OTHERID];
            cell.textLabel.text      = @"使用其他银行卡";
            cell.textLabel.textColor = FONTDARKCOLOR;
            cell.textLabel.font      = [UIFont systemFontOfMutableSize:16];
            cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }else{//可使用银行卡、不可使用银行卡cell(通过cardType判断是否可选即可)
        
        static NSString *cellId = @"YMPayBankCardCell";
        YMPayBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[YMPayBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (indexPath.section == 0) {
            
            //互斥选择实现（通过改变model）:
            /*********/
            if (self.selectArray.count>0) {
                YMSelectModel *selectModel = self.selectArray[indexPath.row];
                cell.isSelected = selectModel.isSelect;
            }
            /*********/

            if ([self canPayDataArray].count>0) {
                YMBankCardModel *model = [self canPayDataArray][indexPath.row];
                cell.bankCardModel = model;
            }

        }else if (indexPath.section == 3){
            if ([self noCanPayDataArray].count>0) {
                YMBankCardModel *model = [self noCanPayDataArray][indexPath.row];
                cell.bankCardModel = model;
            }
        }
        return cell;
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//选择银行卡
        self.yuESelected = NO;
        //互斥选择实现（通过改变model）:
        /*********/
        if ([self canPayDataArray].count>0) {
            self.selectArray  = [[NSMutableArray alloc] init];
            for (int i = 0; i < [self canPayDataArray].count; i++) {
                YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                selectModel.isSelect = NO;
                [self.selectArray addObject:selectModel];
            }
            YMSelectModel *selectModel = self.selectArray[indexPath.row];
            selectModel.isSelect = !selectModel.isSelect;
        }
        [self.bankCardTableView reloadData];
        /*********/
        //选择银行卡对应的model
        if ([self canPayDataArray].count>0) {
            YMBankCardModel *model = [self canPayDataArray][indexPath.row];
            self.selectBankModel = model;
            if ([self.delegate respondsToSelector:@selector(payBankCardListViewCellDidSelected:bankCardInfo:)]) {
                [self.delegate payBankCardListViewCellDidSelected:self bankCardInfo:model];
                [self removeFromSuperview];
            }
        }
        
    }else if (indexPath.section == 1){//选择余额支付
        YMLog(@"选择余额支付");
        if ([self.bankCardDataModel isAcbalUsed]) {//可选余额 否则不能选余额
            self.selectBankModel = nil;
            if ([self canPayDataArray].count>0) {
                self.selectArray  = [[NSMutableArray alloc] init];
                for (int i = 0; i < [self canPayDataArray].count; i++) {
                    YMSelectModel *selectModel = [[YMSelectModel alloc] init];
                    selectModel.isSelect = NO;
                    [self.selectArray addObject:selectModel];
                }
            }
            self.yuESelected = YES;
            [self.bankCardTableView reloadData];
            
            if ([self.delegate respondsToSelector:@selector(payBalanceViewCellDidSelected:bankCardInfo:)]) {
                [self.delegate payBalanceViewCellDidSelected:self bankCardInfo:nil];
                [self removeFromSuperview];
            }
        }
        
    }else if (indexPath.section == 2){//使用其他银行卡
        YMLog(@"使用其他银行卡");
        self.yuESelected = NO;
        if ([self.delegate respondsToSelector:@selector(payBankCardListViewOherCellDidSelected:)]) {
            [self.delegate payBankCardListViewOherCellDidSelected:self];
        }
        [self removeFromSuperview];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentView.bounds.size.height * 0.21;
}

-(void)quitButtonClick
{
    if ([self.delegate respondsToSelector:@selector(payBankCardListViewQuickButtonDidClick:bankCardInfo:yuE:)]) {
        NSString *yuE = @"";
        if (self.yuESelected) {
            yuE = @"余额";
        }else{
            yuE = @"未选余额";
        }
        [self.delegate payBankCardListViewQuickButtonDidClick:self bankCardInfo:self.selectBankModel yuE:yuE];
    }
    
    [self removeFromSuperview];

}
#pragma mark - getters and setters          - Method -
- (void)setBankCardDaraModel:(YMBankCardDataModel *)bankCardDataModel
{
    _bankCardDataModel = bankCardDataModel;
    if (_bankCardDataModel == nil) {
        return;
    }
    [self.bankCardTableView reloadData];
}

- (void)sendSelectBankModel:(YMBankCardModel *)selectBankModel bankCardArray:(NSMutableArray *)bankCardArray
{
    self.bankCardArray = bankCardArray;
    self.selectBankModel = selectBankModel;
    
    NSString *moRenStr = [self.bankCardDataModel getBindingBankStr];
    if ((self.selectBankModel == nil)&&[self.bankCardDataModel isAcbalUsed]) {
        
        if ([moRenStr isEqualToString:@"选择支付方式"]) {
            self.yuESelected = NO;
        }else{
            self.yuESelected = YES;
        }
    }else{
        self.yuESelected = NO;
    }
    
    
    if ([self canPayDataArray].count>0) {
        [[self canPayDataArray] removeAllObjects];
    }
    if ([self noCanPayDataArray].count>0) {
        [[self noCanPayDataArray] removeAllObjects];
    }
    if (self.selectArray.count>0) {
        [self.selectArray removeAllObjects];
    }
    
    for (YMBankCardModel *m in _bankCardArray) {
        if ([m getCardTypeNum] == 1) {
            [self.canPayDataArray addObject:m];
        }else if ([m getCardTypeNum] == 2){
            [self.noCanPayDataArray addObject:m];
        }
    }
    
    if ([self canPayDataArray].count>0) {
        self.selectArray  = [[NSMutableArray alloc] init];
        for (YMBankCardModel *model in [self canPayDataArray]) {
            YMSelectModel *selectModel = [[YMSelectModel alloc] init];
            if (model == _selectBankModel) {
                selectModel.isSelect = YES;
            }else{
                selectModel.isSelect = NO;
            }
            [self.selectArray addObject:selectModel];
        }
    }
    [self.bankCardTableView reloadData];
}

- (void)setFromFlag:(NSInteger)fromFlag
{
    _fromFlag = fromFlag;
    [self.bankCardTableView reloadData];
}


- (NSMutableArray *)canPayDataArray
{
    if (!_canPayDataArray) {
        _canPayDataArray = [[NSMutableArray alloc] init];
    }
    return _canPayDataArray;
}
- (NSMutableArray *)noCanPayDataArray
{
    if (!_noCanPayDataArray) {
        _noCanPayDataArray = [[NSMutableArray alloc] init];
    }
    return _noCanPayDataArray;
}


@end
