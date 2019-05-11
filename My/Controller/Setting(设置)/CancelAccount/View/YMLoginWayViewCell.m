//
//  YMLoginWayViewCell.m
//  WSYMPay
//
//  Created by jey on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMLoginWayViewCell.h"

@interface YMLoginWayViewCell()
@property (nonatomic,strong) UILabel *vlaueLbl;

@end
@implementation YMLoginWayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _vlaueLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        _vlaueLbl.textColor = UIColorFromHex(0x000000);
        _vlaueLbl.textAlignment = NSTextAlignmentLeft;
        _vlaueLbl.font = [UIFont systemFontOfSize:15];
        [self addSubview:_vlaueLbl];
        
        _rightswitch = [[UISwitch alloc]initWithFrame:CGRectZero];
        [self addSubview:_rightswitch];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _vlaueLbl.frame = CGRectMake(12, 0, 100, self.height);
    _rightswitch.frame = CGRectMake(self.width-18-62, 8, 62, 18);
}
- (void)setValue:(NSString *)value {
    _value = value;
    _vlaueLbl.text = value;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
