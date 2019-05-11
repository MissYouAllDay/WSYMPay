//
//  IDCardView.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDCardView;
@protocol IDCardViewDelegate <NSObject>

@optional

-(void)idCardViewFrontPhotoButtonDidClick:(IDCardView *)idcv;

-(void)idCardViewBackPhotoButtonDidClick:(IDCardView *)idcv;

@end

@interface IDCardView : UIView

@property (nonatomic, strong)UIImage *frontImage;

@property (nonatomic, strong)UIImage *backImage;

@property (nonatomic, weak) id <IDCardViewDelegate> delegate;
@end
