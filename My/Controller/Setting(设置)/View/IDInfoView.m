//
//  IDMessageView.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/26.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "IDInfoView.h"

@interface IDInfoView ()

@property (nonatomic, weak)UILabel *nameTitleLabel;
@property (nonatomic, weak)UILabel *nameLabel;
@property (nonatomic, weak)UILabel *IDNumberTitleLabel;
@property (nonatomic, weak)UILabel *IDNumberLabel;
@property (nonatomic,weak)UILabel *IDBankTitleLable;
@property (nonatomic,weak)UILabel *IDBankNumLable;
@property (nonatomic, weak)UIView *lineView;
@property (nonatomic, weak)UIView *lineView1;

@end

@implementation IDInfoView

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
    self.backgroundColor   = [UIColor whiteColor];
    self.layer.borderColor = LAYERCOLOR.CGColor;
    self.layer.borderWidth = 1;
    
    UIFont *font =[UIFont systemFontOfSize:[VUtilsTool fontWithString:15.0]];
    
    UILabel *nameTitleLabel  = [[UILabel alloc]init];
    nameTitleLabel.textColor = FONTCOLOR;
    nameTitleLabel.font      = font;
    nameTitleLabel.text      = @"姓名";
    nameTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameTitleLabel];
    self.nameTitleLabel = nameTitleLabel;
    
    UILabel *nameLabel  = [[UILabel alloc]init];
    nameLabel.textColor = FONTCOLOR;
    nameLabel.font      = font;
    nameLabel.text      = @"*有名";
    nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *IDNumberTitleLabel  = [[UILabel alloc]init];
    IDNumberTitleLabel.textColor = FONTCOLOR;
    IDNumberTitleLabel.textColor = FONTCOLOR;
    IDNumberTitleLabel.font      = font;
    IDNumberTitleLabel.text      = @"身份证号码";
    IDNumberTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:IDNumberTitleLabel];
    self.IDNumberTitleLabel = IDNumberTitleLabel;
    
    UILabel *IDNumberLabel  = [[UILabel alloc]init];
    IDNumberLabel.textColor = FONTCOLOR;
    IDNumberLabel.textColor = FONTCOLOR;
    IDNumberLabel.textColor = FONTCOLOR;
    IDNumberLabel.font      = font;
    IDNumberLabel.text      = @"3702************12";
    IDNumberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:IDNumberLabel];
    self.IDNumberLabel = IDNumberLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = LAYERCOLOR;
    [self addSubview:lineView];
    self.lineView = lineView;
    
    
    UILabel *IDBankTitleLabel  = [[UILabel alloc]init];
    IDBankTitleLabel.textColor = FONTCOLOR;
    IDBankTitleLabel.textColor = FONTCOLOR;
    IDBankTitleLabel.font      = font;
    IDBankTitleLabel.text      = @"身份证号码";
    IDBankTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:IDBankTitleLabel];
    self.IDBankTitleLable = IDBankTitleLabel;
    
    UILabel *IDBankNumberLabel  = [[UILabel alloc]init];
    IDBankNumberLabel.textColor = FONTCOLOR;
    IDBankNumberLabel.textColor = FONTCOLOR;
    IDBankNumberLabel.textColor = FONTCOLOR;
    IDBankNumberLabel.font      = font;
    IDBankNumberLabel.text      = @"3702************12";
    IDBankNumberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:IDBankNumberLabel];
    self.IDBankNumLable = IDBankNumberLabel;
    
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = LAYERCOLOR;
    [self addSubview:lineView1];
    self.lineView1 = lineView1;
}

-(void)setName:(NSString *)name
{
    _name = [name copy];
    
    self.nameLabel.text = _name;

}

-(void)setIDNumber:(NSString *)IDNumber
{
    _IDNumber = [IDNumber copy];
    
    self.IDNumberLabel.text = _IDNumber;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(self.mas_width).multipliedBy(.5).offset(-10);
        make.height.equalTo(self.mas_height).multipliedBy(.5).offset(-1);
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width).multipliedBy(.5).offset(-10);
        make.height.equalTo(self.mas_height).multipliedBy(.5).offset(-1);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top);
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width).multipliedBy(.97);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.nameLabel.mas_bottom);
        
    }];
    
    [self.IDNumberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width).multipliedBy(.5).offset(-10);
        make.height.equalTo(self.mas_height).multipliedBy(.5);
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.lineView.mas_bottom);
        
    }];
    
    [self.IDNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width).multipliedBy(.5).offset(-10);
        make.height.equalTo(self.mas_height).multipliedBy(.5);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.lineView.mas_bottom);
        
    }];
    [self.IDBankTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}
@end
