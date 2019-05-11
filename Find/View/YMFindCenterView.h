//
//  YMFindCenterView.h
//  WSYMPay
//
//  Created by MaKuiying on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMFindCenterViewDelegate <NSObject>

@optional
- (void)selectCenterBannerItemAtIndex:(NSString *)h5Url;

@end


@interface YMFindCenterView : UITableViewCell
@property (nonatomic, weak) id<YMFindCenterViewDelegate>delegate;
-(void)requestBannerData;
@end
