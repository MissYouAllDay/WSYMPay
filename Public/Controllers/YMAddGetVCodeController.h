//
//  YMAddGetVCodeController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/5.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerificationView,YMRedBackgroundButton;

@interface YMAddGetVCodeController : UITableViewController

@property (nonatomic, strong) VerificationView *verificationView;

@property (nonatomic, weak) YMRedBackgroundButton *nextBtn;

@property (nonatomic, assign, getter=isNotFirstLoad) BOOL  NotFirstLoad;

@property (nonatomic, copy) NSString *textFieldStr;

-(void)loadCerCode;

-(void)nextBtnClick;
@end
