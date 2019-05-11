//
//  IDVerificationViewController.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/26.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{    
    IDVerificationStatusNotStart = -2,//没有开始（请先上传身份证进行实名认证）
    IDVerificationStatusStarting = 1,//审核中（身份证认证审核中）
    IDVerificationStatusFail = 3,//失败（身份证认证未通过，请重新上传认证）
    IDVerificationStatusSuccess = 2,//成功
    
    
}IDVerificationStatus;

@interface IDVerificationViewController : UIViewController


@property (nonatomic, weak) NSString *name;

@property (nonatomic, weak) NSString *IDNumber;

@property (nonatomic, assign)IDVerificationStatus verificationStatus;
@end
