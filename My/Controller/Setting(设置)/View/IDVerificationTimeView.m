//
//  IDTimeView.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "IDVerificationTimeView.h"
#import "IDTimeButton.h"
@interface IDVerificationTimeView ()

@property (nonatomic, weak) IDTimeButton *startTimeButton;

@property (nonatomic, weak) IDTimeButton *endTimeButton;


@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *lineView;


@end


@implementation IDVerificationTimeView

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
    self.backgroundColor = [UIColor whiteColor];
    
    IDTimeButton *startTimeButton = [[IDTimeButton alloc]init];
    [startTimeButton setImage:[UIImage imageNamed:@"date_available"] forState:UIControlStateNormal];
    [startTimeButton setTitle:@"开始时间" forState:UIControlStateNormal];
    [startTimeButton setTitleColor:RGBColor(214, 214, 214) forState:UIControlStateNormal];
    [startTimeButton addTarget:self action:@selector(startTimeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startTimeButton];
    self.startTimeButton = startTimeButton;
    
    IDTimeButton *endTimeButton = [[IDTimeButton alloc]init];
    [endTimeButton setImage:[UIImage imageNamed:@"date_available"] forState:UIControlStateNormal];
    [endTimeButton setTitle:@"结束时间" forState:UIControlStateNormal];
    [endTimeButton setTitleColor:RGBColor(214, 214, 214) forState:UIControlStateNormal];
    [endTimeButton addTarget:self action:@selector(endTimeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endTimeButton];
    self.endTimeButton = endTimeButton;
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"证件有效期";
    titleLabel.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:15]];
    titleLabel.textColor = FONTCOLOR;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];
    self.lineView = lineView;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat interval = 10;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo((SCREENWIDTH -interval *6)/3);
        make.height.equalTo(self.mas_height).offset(-10);
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(interval);
        
    }];
    
        [self.startTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.width.equalTo(self.titleLabel.mas_width);
            make.height.equalTo(self.titleLabel.mas_height);
            make.top.equalTo(self.titleLabel.mas_top);
            make.left.equalTo(self.titleLabel.mas_right).offset(interval);
    
        }];
    
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.width.mas_equalTo(interval);
            make.height.mas_equalTo(1);
            make.centerY.equalTo(self.startTimeButton.mas_centerY);
            make.left.equalTo(self.startTimeButton.mas_right).offset(interval);
    
        }];
    
        [self.endTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.width.equalTo(self.titleLabel.mas_width);
            make.height.equalTo(self.titleLabel.mas_height);
            make.top.equalTo(self.titleLabel.mas_top);
            make.left.equalTo(self.lineView.mas_right).offset(interval);
            
        }];

}

#pragma mark - 开始按钮点击
-(void)startTimeButtonClick
{
    
    if ([self.delegate respondsToSelector:@selector(idVerificationTimeViewStartButtonDidClick:)]) {
        
        [self.delegate idVerificationTimeViewStartButtonDidClick:self];
    }

}

#pragma mark - 结束按钮点击
-(void)endTimeButtonClick
{
    if ([self.delegate respondsToSelector:@selector(idVerificationTimeViewEndButtonDidClick:)]) {
        
        [self.delegate idVerificationTimeViewEndButtonDidClick:self];
    }

}

-(void)setStartDate:(NSString *)startDate
{
    _startDate = [startDate copy];
    [self.startTimeButton setTitle:_startDate forState:UIControlStateNormal];
    [self.startTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)setEndDate:(NSString *)endDate
{
    _endDate = [endDate copy];
    
    [self.endTimeButton setTitle:_endDate forState:UIControlStateNormal];
    [self.endTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

@end
