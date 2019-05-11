//
//  IDVerificationDatePicker.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDVerificationDatePicker;
@protocol IDVerificationDatePickerDelegate <NSObject>

- (void)idVerificationDatePickerDidEndEditing:(IDVerificationDatePicker *)idve;
@end

typedef void(^StrYMBlock)(NSString *strTM);

@interface IDVerificationDatePicker : UIButton

@property (nonatomic, copy) NSString  *minimumDate;

@property (nonatomic, copy) NSString *maximumDate;

@property (nonatomic, assign) BOOL longTimeButtonHiden;

@property(nonatomic,copy)StrYMBlock strBlock;

@property (nonatomic, weak) id <IDVerificationDatePickerDelegate> delegate;
@end
