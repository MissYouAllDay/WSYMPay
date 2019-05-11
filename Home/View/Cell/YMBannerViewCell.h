//
//  YMBannerViewCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>


@class YMBannerViewCell;
@protocol YMBannerViewCellDelegate <NSObject>

-(void)bannerViewCell:(YMBannerViewCell *)cell bannerButtonDidClick:(NSString *)h5url;

@end

@interface YMBannerViewCell : UITableViewCell
/**
 cell的初始化方法
 */
+(instancetype)configCell:(UITableView *)tableView withBannerPosition:(NSString *)position;

@property (nonatomic, weak) id <YMBannerViewCellDelegate> delegate;

@property (nonatomic, retain) SDCycleScrollView * cycleScrollView;

/**
 图片数组，只能加载统一格式图片
 */
@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, strong) NSMutableArray *bannerherfArray;

/**
 标题
 */
@property (nonatomic, strong) NSArray * titleArray;

@property (nonatomic)BOOL isOnlyShowText;


@end
