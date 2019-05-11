//
//  YMServiceCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMServiceCell.h"
#import "YMLeftTitltButton.h"

@interface YMServiceCell ()

@property (nonatomic, weak) YMLeftTitltButton *leftButton;
@property (nonatomic, weak) YMLeftTitltButton *rightButton;
@property (nonatomic, weak) UIImageView *backgroundImageView1;
@property (nonatomic, weak) UIImageView *backgroundImageView2;
@end

@implementation YMServiceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return self;
}

-(void)setupSubViews
{
    UIImageView *backgroundImageView1 = [[UIImageView alloc]init];
    backgroundImageView1.image = [UIImage imageNamed:@"mineback"];
    backgroundImageView1.userInteractionEnabled = YES;
    [backgroundImageView1 addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonDidClick:)]];
    [self.contentView addSubview:backgroundImageView1];
    self.backgroundImageView1 = backgroundImageView1;
    
    UIImageView *backgroundImageView2 = [[UIImageView alloc]init];
    backgroundImageView2.image = [UIImage imageNamed:@"mineback"];
    backgroundImageView2.userInteractionEnabled = YES;
    [backgroundImageView2 addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonDidClick:)]];
    [self.contentView addSubview:backgroundImageView2];
    self.backgroundImageView2 = backgroundImageView2;
    
    YMLeftTitltButton *leftButton = [[YMLeftTitltButton alloc]init];
    leftButton.subTitle = @"话费充值";
    leftButton.userInteractionEnabled = NO;
    [leftButton setTitle:@"手机充值" forState:UIControlStateNormal];
    [leftButton setTitleColor:FONTDARKCOLOR forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"手机充值"] forState:UIControlStateNormal];
    [self.backgroundImageView1 addSubview:leftButton];
    self.leftButton = leftButton;
    
    YMLeftTitltButton *rightButton = [[YMLeftTitltButton alloc]init];
    rightButton.subTitle = @"借记卡到借记卡";
    rightButton.userInteractionEnabled = NO;
    [rightButton setTitleColor:FONTDARKCOLOR forState:UIControlStateNormal];
    [rightButton setTitle:@"转账服务" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"转账"] forState:UIControlStateNormal];
    [self.backgroundImageView2 addSubview:rightButton];
    self.rightButton = rightButton;
    
}

-(void)buttonDidClick:(UITapGestureRecognizer *)btn
{
    if (self.buttonDidClick) {
        if (self.backgroundImageView1 == btn.view) {
            self.buttonDidClick(YMServiceReplenishing);
        } else{
            self.buttonDidClick(YMServiceTransferAccounts);
        }
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView1.x = self.backgroundImageView1.y = 0;
    self.backgroundImageView1.width  = self.contentView.width / 2;
    self.backgroundImageView1.height = self.contentView.height;
    
    self.backgroundImageView2.x = self.backgroundImageView1.width;
    self.backgroundImageView2.y = 0;
    self.backgroundImageView2.width = self.backgroundImageView1.width;
    self.backgroundImageView2.height = self.contentView.height;
    
    
    
    CGFloat btnW = self.contentView.width / 2 - (LEFTSPACE * 2);
    CGFloat btnH = self.contentView.height / 2;
    
    self.leftButton.x = LEFTSPACE;
    self.leftButton.centerY = self.height / 2;
    self.leftButton.width  = btnW;
    self.leftButton.height = btnH;
    
    self.rightButton.x =  LEFTSPACE;
    self.rightButton.centerY = self.height / 2;
    self.rightButton.width  = btnW;
    self.rightButton.height = btnH;
}



@end
