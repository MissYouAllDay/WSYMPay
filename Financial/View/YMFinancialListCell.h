//
//  YMFinancialListCell.h
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 理财界面 list列表 cell
 */

#import <UIKit/UIKit.h>
#import "YMCollectionModel.h"

@interface YMFinancialListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (weak, nonatomic) YMCollectionModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
