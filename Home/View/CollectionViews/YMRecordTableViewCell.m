//
//  YMRecordTableViewCell.m
//  WSYMPay
//
//  Created by PengCheng on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMRecordTableViewCell.h"

@implementation YMRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.textColor = [UIColor blackColor];
        self.descLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.descLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.timeLabel];
        
        self.moneyLabel = [[UILabel alloc] init];
        self.moneyLabel.textColor = [UIColor blackColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:14];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.moneyLabel];
        
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {// 取消船讯
            make.top.mas_equalTo(self).offset(10);
            make.right.mas_equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {// 取消船讯
            make.top.mas_equalTo(self).offset(10);
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self.moneyLabel.mas_left).offset(-10);
            make.height.mas_equalTo(20);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {// 取消船讯
            make.top.mas_equalTo(self.descLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self.moneyLabel.mas_left).offset(-10);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
