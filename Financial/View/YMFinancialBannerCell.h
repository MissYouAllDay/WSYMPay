//
//  YMFinancialBannerCell.h
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 理财界面 banner
 */
#import <UIKit/UIKit.h>

@protocol YMFinancialBannerCellDelegate <NSObject>

@optional
- (void)selectBannerItemAtIndex:(NSString *)h5Url;

@end
@interface YMFinancialBannerCell : UICollectionViewCell<YMFinancialBannerCellDelegate>

@property (nonatomic, weak) id<YMFinancialBannerCellDelegate>delegate;

-(void)reloadBannerData;
@end
