//
//  CXDetailsTableViewCell.m
//  WSYMPay
//
//  Created by zhangwenjia on 2019/5/11.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "CXDetailsTableViewCell.h"

@implementation CXDetailsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initview];
        
    }
    
    return self;
}
- (void)initview
{
    self.namela = [[UILabel alloc]initWithFrame:CGRectMake(LEFTSPACE, 0, SCALEZOOM(100), 30)];
    [self.contentView addSubview:self.namela];
    self.namela.textColor = FONTCOLOR;
    self.namela.font = [UIFont systemFontOfSize:14];
    self.namela.text = @"";
    
    
    self.nametwola = [[UILabel alloc]initWithFrame:CGRectMake(self.namela.right, 0, SCREENWIDTH-SCALEZOOM(100), 30)];
    [self.contentView addSubview:self.nametwola];
    self.nametwola.textColor = FONTCOLOR;
    self.nametwola.font = [UIFont systemFontOfSize:14];
    
    self.nametwola.text = @"";

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
