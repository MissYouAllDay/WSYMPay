//
//  FeedbackViewController.h
//  WSYMPay
//
//  Created by jey on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackModel : NSObject

@property (nonatomic, copy) NSString *backType;
//返回信息
@property (nonatomic, copy) NSString *backTypeDes;

@end

@interface FeedbackViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
