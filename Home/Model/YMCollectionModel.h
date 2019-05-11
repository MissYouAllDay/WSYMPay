//
//  YMCollectionModel.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMCollectionModel : NSObject

@property (nonatomic, strong)  NSString * title;

@property (nonatomic, strong)  NSString * detailTitle;

@property (nonatomic, strong) NSString * imgName;

@property (nonatomic, strong) NSString * imgUrl;

@property (nonatomic, strong) NSString * webUrl;

@property (nonatomic, strong) NSString * nextVC;

//--------手机 充值的时候用到 ------
@property (nonatomic, strong) NSString * prodId;

@property (nonatomic) BOOL canRech;
//--------------------------------
@end
