//
//  YMAllCollectionViewCell.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCollectionModel.h"

@interface YMAllCollectionViewCell : UICollectionViewCell
@property (strong ,nonatomic) NSString * title;
@property (strong ,nonatomic) NSString * imgName;

@property (strong ,nonatomic) YMCollectionModel * model;

@end
