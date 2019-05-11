//
//  IDTimeView.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDVerificationTimeView;
@protocol IDVerificationTimeViewDelegate <NSObject>

@optional

-(void)idVerificationTimeViewStartButtonDidClick:(IDVerificationTimeView *)idV;
-(void)idVerificationTimeViewEndButtonDidClick:(IDVerificationTimeView *)idV;
@end

@interface IDVerificationTimeView : UIView

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, weak) id <IDVerificationTimeViewDelegate> delegate;
@end
