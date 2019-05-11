//
//  YMPayPrepaidCardListView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/16.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMPayPrepaidCardListView.h"
#import "YMPayPrepaidCardCell.h"
#import "YMPrepaidCardModel.h"
@interface YMPayPrepaidCardListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIButton *quitButton;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) UITableView *bankCardTableView;

@end

@implementation YMPayPrepaidCardListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
        
    }
    return self;
}

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
    
    UILabel *titleLabel      = [[UILabel alloc]init];
    titleLabel.font          = COMMON_FONT;
    titleLabel.textColor     = FONTDARKCOLOR;
    titleLabel.text          = @"选择预付卡";
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
        
        make.height.equalTo(self.mas_height).multipliedBy(.56);
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.prepaidCardArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *ID  = @"cell";
    YMPayPrepaidCardCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[YMPayPrepaidCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    if (indexPath.row == 0) {
        
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payment_selected"]];
        
    } else {
        
        cell.accessoryView = nil;
    }
    
    YMPrepaidCardModel *prepaidCardModel = self.prepaidCardArray[indexPath.row];
    
    cell.prepaidCardNO = prepaidCardModel.prepaidNo;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YMPayPrepaidCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YMPrepaidCardModel *prepaidCardModel = self.prepaidCardArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(payPrepaidCardListView:didSelectedPrepaidCard:)]) {
        
        [self.delegate payPrepaidCardListView:self didSelectedPrepaidCard:cell.prepaidCardNO];
    }
    
    [self.prepaidCardArray exchangeObjectAtIndex:[self.prepaidCardArray indexOfObject:prepaidCardModel] withObjectAtIndex:0];
    
    [self removeFromSuperview];
    
}
    


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.contentView.bounds.size.height * 0.21;
}

-(void)quitButtonClick
{
    [self removeFromSuperview];
}

-(void)setPrepaidCardArray:(NSMutableArray *)prepaidCardArray
{
    _prepaidCardArray = prepaidCardArray;
    [self.bankCardTableView reloadData];
}


@end
