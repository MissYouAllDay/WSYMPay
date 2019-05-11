//
//  YMFinancialClassCell.h
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 理财界面 左右样式的cell
 */
#import <UIKit/UIKit.h>

@interface YMFinancialClassCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *classImage;

@property (nonatomic, copy) NSString *classImageStr;

@end
