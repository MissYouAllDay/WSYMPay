//
//  FristSettionPayPasswordViewController.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/23.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FristSettingPayPasswordViewController;

@protocol FristSettingPayPasswordViewControllerDelegate <NSObject>

@optional
-(void)fristSettingPayPasswordViewControllerSettingPayPasswordSuccess:(FristSettingPayPasswordViewController*)vc password:(NSString *)pwd;

-(void)fristSettingPayPasswordViewControllerSettingPayPasswordFail:(FristSettingPayPasswordViewController*)vc;
@end

@interface FristSettingPayPasswordViewController : UIView

@property (nonatomic, weak) id<FristSettingPayPasswordViewControllerDelegate> delegate;

-(void)show;
@end
