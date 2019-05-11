//
//  YMHomeColumnCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMHomeColumnCell.h"
#import "YMHomeColumnModel.h"
#import "YMHomeColumnButton.h"
#import "YMColumnImageModel.h"
@interface YMHomeColumnCell ()

@property (nonatomic, weak) UIImageView      *topBackIV;
@property (nonatomic, weak) UIImageView      *lineIV;
@property (nonatomic, weak) UILabel          *titleLabel;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIImageView    *lastIV;
@end

@implementation YMHomeColumnCell

+(instancetype)configCell:(UITableView *)tableView withColumns:(YMHomeColumnModel *)columns
{
    static NSString *ID    = @"YMHomeColumnCellID";
    YMHomeColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMHomeColumnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.columns = columns;
    return cell;
}

-(UIImageView *)lastIV
{
    if (!_lastIV) {
        _lastIV        = [[UIImageView alloc]init];
        _lastIV.image  = [UIImage imageNamed:@"home_white"];
        [self.contentView addSubview:_lastIV];
        _lastIV.hidden = YES;
    }
    return _lastIV;
}

-(NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

-(void)setupSubviews
{
    self.contentView.backgroundColor = RGBColor(224, 224, 224);
    self.selectionStyle              = UITableViewCellSeparatorStyleNone;
    
    UIImageView *topBackIV = [[UIImageView alloc]init];
    topBackIV.image        = [UIImage imageNamed:@"mineback"];
    [self.contentView addSubview:topBackIV];
    self.topBackIV         = topBackIV;
    
    UIImageView *lineIV     = [[UIImageView alloc]init];
    lineIV.backgroundColor = NAVIGATIONBARCOLOR;
    [self.contentView addSubview:lineIV];
    self.lineIV             = lineIV;
    
    UILabel     *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor    = RGBColor(51, 51, 51);
    titleLabel.font         = [UIFont systemFontOfMutableSize:13];
    titleLabel.text         = @"精品推荐";
    [titleLabel sizeToFit];
    [self.contentView addSubview:titleLabel];
    self.titleLabel         = titleLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topBackIV.x      = self.topBackIV.y = 0;
    self.topBackIV.width  = SCREENWIDTH;
    self.topBackIV.height = SCALEZOOM(38);
    
    self.lineIV.height  = SCALEZOOM(15);
    self.lineIV.width   = 2;
    self.lineIV.x       = LEFTSPACE;
    self.lineIV.centerY = self.topBackIV.height/2;
    
    self.titleLabel.x       = self.lineIV.right + LEFTSPACE/2;
    self.titleLabel.centerY = self.topBackIV.height/2;
    
    CGFloat btnH = COLUMNHEIGHT;
    CGFloat btnW = self.contentView.width / 2;
    
    for (int i = 0; i<self.columns.imageArray.count; i++) {
        UIButton *columenBtn = self.buttonArray[i];
        columenBtn.width     = btnW - 0.5;
        columenBtn.height    = btnH - 0.5;
        columenBtn.x         = (i % 2) * btnW;
        columenBtn.y         = (i / 2) * btnH + self.topBackIV.bottom+0.5;
    }
    
    if (self.columns.imageArray.count % 2 != 0) {
        UIButton *btn      = self.buttonArray[self.columns.imageArray.count - 1];
        self.lastIV.hidden = NO;
        self.lastIV.width  = btnW - 0.5;
        self.lastIV.height = btnH - 0.5;
        self.lastIV.x      = btnW;
        self.lastIV.y      = btn.y;
    } else {
        _lastIV.hidden     = YES;
    }
    
}

-(void)setColumns:(YMHomeColumnModel *)columns
{
    _columns = columns;
    
    self.titleLabel.text  = _columns.title;
//    self.lineIV.image     = [UIImage imageNamed:_columns.titleColorStr];
    NSInteger columnCount = _columns.imageArray.count;
    
    
    while (self.buttonArray.count < columnCount) {
        YMHomeColumnButton  *columenBtn = [[YMHomeColumnButton alloc]init];
        [columenBtn addTarget:self action:@selector(columenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:columenBtn];
        [self.buttonArray addObject:columenBtn];
    }
    
    for (int i = 0; i<self.buttonArray.count; i++) {
        YMHomeColumnButton *btn = self.buttonArray[i];
        if (i<columnCount) {
            btn.hidden   = NO;
            YMColumnImageModel * imageModel = _columns.imageArray[i];
            NSString * url = [IP stringByAppendingString:imageModel.image];
            btn.imageUrl = url;
            btn.h5url    = imageModel.url;
            
        } else {
            btn.hidden = YES;
        }
    }
}

-(void)columenBtnClick:(YMHomeColumnButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(homeColumnCell:columnsDidClick:)]) {
        [self.delegate homeColumnCell:self columnsDidClick:btn.h5url];
    }
}

@end
