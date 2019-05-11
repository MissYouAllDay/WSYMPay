//
//  YMCollectionView.h
//  WSYMPay
//
//  Created by pzj on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 我要收款 --- view
 */
#import <UIKit/UIKit.h>

@class YMCollectionBaseListModel;

@protocol YMCollectionViewDelegate <NSObject>

- (void)selectRecordBtn:(YMCollectionBaseListModel *)model;
- (void)didsetAmountAction;
- (void)selectRecordBtn;
@end

@interface YMCollectionView : UIView<YMCollectionViewDelegate>

@property (nonatomic, copy) NSString *userIdStr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id<YMCollectionViewDelegate>delegate;
@property (nonatomic,strong) UILabel *lblA;
@end
