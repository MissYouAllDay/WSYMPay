//
//  YMBankCardNoneCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/2.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMBankCardNoneCell.h"
#import "UIView+Extension.h"

@implementation YMBankCardNoneCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = VIEWGRAYCOLOR;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.backgroundView.x      = LEFTSPACE;
    self.backgroundView.y      = 0;
    self.backgroundView.width  = self.width - (LEFTSPACE * 2);
    self.backgroundView.height = self.height;
    
}

@end
