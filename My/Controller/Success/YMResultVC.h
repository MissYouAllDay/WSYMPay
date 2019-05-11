//
//  YMResultVCViewController.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMResultVC : UIViewController

@property (nonatomic, weak) UIImageView *statusImageView;

@property (nonatomic, weak) UILabel *mainTitleLabel;

@property (nonatomic, weak) UILabel *subTitleLabel;

@property (nonatomic, weak) UIButton *finishBtn;

-(void)updateSubviewsUI;
-(void)finishBtnClick;
@end
