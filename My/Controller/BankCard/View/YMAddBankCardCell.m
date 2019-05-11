//
//  YMAddBankCardCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/11/30.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAddBankCardCell.h"
#import "UIView+Extension.h"

@interface YMAddBankCardCell ()

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation YMAddBankCardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor     = VIEWGRAYCOLOR;
        self.contentView.layer.cornerRadius  = CORNERRADIUS;
        self.contentView.layer.masksToBounds = YES;
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = RGBColor(209, 209, 209).CGColor;
        self.textLabel.textColor = RGBColor(135, 135, 135);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = VIEWGRAYCOLOR;
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.x      = LEFTSPACE;
    self.contentView.y      = 0;
    self.contentView.width  = self.width - LEFTSPACE * 2;
    self.contentView.height = self.height;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.textLabel.text = _titleStr;
}

@end
