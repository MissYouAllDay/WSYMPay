//
//  YMRecordHeaderView.m
//  WSYMPay
//
//  Created by PengCheng on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMRecordHeaderView.h"

@implementation YMRecordHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH, 20)];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.dateLabel];
//        
//        self.totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, SCREENWIDTH/2, 20)];
//        self.totalCountLabel.textColor = [UIColor grayColor];
//        self.totalCountLabel.font = [UIFont systemFontOfSize:14];
//        [self addSubview:self.totalCountLabel];
//        
//        self.totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 30, SCREENWIDTH/2-10, 20)];
//        self.totalMoneyLabel.textColor = [UIColor grayColor];
//        self.totalMoneyLabel.font = [UIFont systemFontOfSize:14];
//        [self addSubview:self.totalMoneyLabel];
    }
    return self;
}

@end
