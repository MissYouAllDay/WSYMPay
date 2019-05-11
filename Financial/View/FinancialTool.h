//
//  FinancialTool.h
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

/*
 * 理财 界面Tool
 * by pzj 2016-6-6
 */
#import <Foundation/Foundation.h>
//拓展
#import "YMCollectionModel.h"

@protocol FinancialToolDelegate <NSObject>

@optional
- (void)selectBannerMethodWithIndex:(NSString *)h5Url;
- (void)selectItemWithModel:(YMCollectionModel *)model;
- (void)presentContactViewController;
- (void)requestMobileApi:(NSString *)phoneNum;

@end

@interface FinancialTool : NSObject<UICollectionViewDelegate,UICollectionViewDataSource,FinancialToolDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, weak) id<FinancialToolDelegate>delegate;
- (instancetype)initWithCollectionViewFrame:(CGRect)collectionViewFrame;

//拓展
//YMCollectionModel

@property (nonatomic, copy) NSArray * registerCellArr;
@property (nonatomic, copy) NSArray * registerSectionHeaderArr;
@property (nonatomic, copy) NSArray * registerSectionFooterArr;


/**
 对象数组
 column    int      列数
 function  nsarray  数组  YMCollectionModel
 title     nsstring 头
 itemCell  nsstring cellForItem的名字
 multipliedBy   nsstring 宽高比
 sectionHeader  nsstring sectionHeader 名字
 sectionFooter  nsstring sectionFooter 名字
 sizeForHeader  nsstring sizeForHeader 高度
 sizeForFooter  nsstring sizeForFooter 高度
 */
@property (nonatomic, copy) NSArray * allArr;

@end
