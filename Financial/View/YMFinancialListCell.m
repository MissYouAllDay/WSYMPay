//
//  YMFinancialListCell.m
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMFinancialListCell.h"
#import <UIImageView+AFNetworking.h>

@implementation YMFinancialListCell

-(void)setModel:(YMCollectionModel *)model
{
    _model = model;
    NSString * imgUrl = [NSString stringWithFormat:@"%@%@",IP,model.imgUrl];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:PLACEHOLDERIMAGE]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

@end
