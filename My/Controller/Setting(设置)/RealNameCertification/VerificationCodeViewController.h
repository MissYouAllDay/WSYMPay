//
//  VerificationCodeViewController.h
//  WSYMPay
//
//  Created by MaKuiying on 16/9/23.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMBankCardModel;
@interface VerificationCodeViewController : UIViewController

//手机号
@property(nonatomic,strong)NSString* bankPreMobil;
//身份证号
@property(nonatomic,strong)NSString* idCardNum;
//持卡人姓名
@property(nonatomic,strong)NSString* cardName;
//有效期
@property(nonatomic,strong)NSString* cardDeadline;
//安全码
@property(nonatomic,strong)NSString* safetyCode;

//实名认证请求参数1
@property(nonatomic,strong)NSString* chaneel_short;
//安全码
@property(nonatomic,strong)NSString* trxId;
//安全码
@property(nonatomic,strong)NSString* trxDtTm;
//安全码
@property(nonatomic,strong)NSString* smskey;
//安全码
@property(nonatomic,strong)NSString* wl_url;



@property (nonatomic, assign)BOOL   isDebitCard;
//是否是发送验证码
@property (nonatomic, assign)BOOL   isSendVCode;

@property (nonatomic, assign)NSInteger resCode;

@property (nonatomic, strong) YMBankCardModel *bankCardInfo;
@end
