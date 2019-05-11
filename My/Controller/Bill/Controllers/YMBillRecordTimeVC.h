//
//  YMBillRecordTimeVC.h
//  WSYMPay
//
//  Created by junchiNB on 2019/4/25.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickMonthBlock) (NSString * _Nullable month);
NS_ASSUME_NONNULL_BEGIN

@interface YMBillRecordTimeVC : UIViewController
@property(nonatomic, copy) clickMonthBlock clickMonthblock;
@end

NS_ASSUME_NONNULL_END
