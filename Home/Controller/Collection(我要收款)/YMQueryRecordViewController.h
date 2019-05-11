//
//  YMQueryRecordViewController.h
//  WSYMPay
//
//  Created by PengCheng on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMQueryRecordViewController : UIViewController
@property (copy, nonatomic) void(^queryDateBlock)(NSString *startDate,NSString *endDate);
@end

NS_ASSUME_NONNULL_END
