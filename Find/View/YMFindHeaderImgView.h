//
//  YMFindHeaderImgView.h
//  WSYMPay
//
//  Created by MaKuiying on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMFinancialBannerCellDelegate <NSObject>

- (void)selectBannerItemAtIndex:(NSString *)h5Url;

@end

@interface YMFindHeaderImgView : UIView<YMFinancialBannerCellDelegate>


@property (nonatomic, weak) id<YMFinancialBannerCellDelegate>delegate;
-(void)reloadBannerData;
@end
