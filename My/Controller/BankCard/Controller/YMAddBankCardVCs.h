//
//  YMAddBankCardVCs.h
//  WSYMPay
//
//  Created by junchiNB on 2019/4/24.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum{
    IDVerificationStatusNotStart = -2,//没有开始（请先上传身份证进行实名认证）
    IDVerificationStatusStarting = 1,//审核中（身份证认证审核中）
    IDVerificationStatusFail = 3,//失败（身份证认证未通过，请重新上传认证）
    IDVerificationStatusSuccess = 2,//成功
    
    
}IDVerificationStatus;
@interface YMAddBankCardVCs : UIViewController
@property (nonatomic, weak) NSString *name;

@property (nonatomic, weak) NSString *IDNumber;

@property (nonatomic, assign)IDVerificationStatus verificationStatus;
@end

NS_ASSUME_NONNULL_END
