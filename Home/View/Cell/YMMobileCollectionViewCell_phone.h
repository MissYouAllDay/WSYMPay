//
//  YMMobileCollectionViewCell_phone.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/24.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCollectionModel.h"
@class YMMobileCollectionViewCell_phone;
@protocol YMMobileCollectionPhoneDelegate <NSObject>

-(void)startRequestMobileApi:(NSString *)phoneNum;
-(void)toSystemContactVC;

@end


@interface YMMobileCollectionViewCell_phone : UICollectionViewCell
@property (nonatomic, weak) id<YMMobileCollectionPhoneDelegate> delegate;
@property (strong ,nonatomic) YMCollectionModel * model;
@end
