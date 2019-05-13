//
//  YMBillRecordScreenVC.h
//  WSYMPay
//
//  Created by junchiNB on 2019/4/24.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickValueBlock) (NSString * _Nullable value,NSString *minMoney,NSString *maxMoney);
NS_ASSUME_NONNULL_BEGIN

@interface YMBillRecordScreenVC : UIViewController
@property (nonatomic,copy) clickValueBlock clickValueblock;
@end

NS_ASSUME_NONNULL_END
