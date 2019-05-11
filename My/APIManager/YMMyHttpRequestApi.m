//
//  YMMyHttpRequestApi.m
//  WSYMPay
//
//  Created by pzj on 2017/3/10.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMMyHttpRequestApi.h"
#import "YMResponseModel.h"
#import "YMUserInfoTool.h"
#import "YMPrepaidCardModel.h"

#import "YMBillBaseModel.h"
#import "YMBillDataModel.h"
#import "YMBillDetailsModel.h"
#import "YMBillDetailsListModel.h"

#import "YMBankCardModel.h"
#import "YMBaseResponseModel.h"
#import <MJExtension.h>

#import "YMBankCardBaseModel.h"
#import "YMBankCardDataModel.h"
#import "NSString+AES.h"

#import "YMReChargeDetailsModel.h"//收支明细-充值详情查询model
#import "YMCashDetailsModel.h"//收支明细-提现详情查询model
#import "YMPrepaidCardDetailsModel.h"//收支明细-预付费卡充值查询model
#import "YMBillDetailResultModel.h"//最终想要的model
#import "YMTransferDetailsModel.h"
#import "YMMonthModel.h"

#import "YMTransferCheckAccountModel.h"//转账到余额（核验用户信息model）
#import "YMTransferCheckAccountDataModel.h"//转账到余额（核验用户信息model中data）
#import "YMTransferCreatOrderDataModel.h"//转账到余额(创建转账订单)
#import "YMTransferRecentRecodeModel.h"//转账---最近转账记录 总model
#import "YMTransferRecentRecodeDataModel.h"//转账---最近转账记录 dataModel
#import "YMTransferCheckPayPwdModel.h"//转账到余额---校验支付密码 总model
#import "YMTransferCheckPayPwdDataModel.h"//转账到余额---校验支付密码 dataModel
#import "YMTransferDetailsModel.h"
#import "YMTransferToBankCheckBankModel.h"//转账到银行卡---验证银行model
#import "YMTransferToBankCheckBankDataModel.h"//转账到银行卡---验证银行 dataModel
#import "YMTransferToBankSearchReqFeeModel.h"//转账到银行卡---查询转账手续费model
#import "YMTransferToBankSearchFeeDataModel.h"//转账到银行卡---查询转账手续费dataModel
#import "YMTransferToBankLimitModel.h"//转账到银行卡---限额说明
#import "YMTransferToBankLimitDataModel.h"//转账到银行卡---限额说明 dataModel

//扫码
#import "YMScanModel.h"
#import "YMScanDetailsModel.h"

//订单列表
#import "YMAllBillListModel.h"
#import "YMAllBillListDataModel.h"
#import "YMAllBillListDataListModel.h"
//订单详情
#import "YMAllBillDetailModel.h"
#import "YMAllBillDetailDataModel.h"

#import "YMRevokeOrConfirmModel.h"
#import "YMRevokeOrConfirmDataModel.h"

@implementation YMMyHttpRequestApi

#pragma mark - 点击注销账户，用户状态校验接口
+ (void)loadHttpRequestWithCheckLogoffSuccess:(void (^)(YMResponseModel *model))success failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showMessage:@"正在检测账户状态..."];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token = currentInfo.token;
    params.tranCode = CHECKLOGOFFCODE;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *model = [YMResponseModel loadModelFromDic:responseObject];
        [MBProgressHUD hideHUD];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 校验验证码/支付密码，注销账户
 */
+ (void)loadHttpRequestWithCheckPayPwdOrValidateCode:(NSString *)codeString success:(void (^)(YMResponseModel *model))success failure:(void (^)(NSError *error))failure
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token = currentInfo.token;
    params.tranCode = PAYPWDORVALIDATECODE;
    if (currentInfo.usrStatus == -1) {//未实名
        params.validateCode = codeString;
    }else{
        params.payPwd = codeString;
    }
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *model = [YMResponseModel loadModelFromDic:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 发送注销验证码
 
 @param success 成功
 */
+ (void)loadHttpRequestWithSendValidateCodeSuccess:(void (^)(YMResponseModel *model))success
{
    [MBProgressHUD showMessage:@"正在获取验证码..."];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token = currentInfo.token;
    params.tranCode = SENDCHECKLOGOFFCODE;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *model = [YMResponseModel loadModelFromDic:responseObject];
        if (model.resCode == 1) {
            [MBProgressHUD hideHUD];
            if (success) {
                success(model);
            }
        }else{
            [MBProgressHUD showText:model.resMsg];
        }
    } failure:^(NSError *error) {
    }];
}
/**
 保存注销原因
 
 @param reasonStr 注销原因
 @param NSString 随机串
 @param success 成功
 */
+ (void)loadHttpRequestWithSaveReason:(NSString *)reasonStr Success:(void (^)(YMResponseModel *model))success
{
    [MBProgressHUD showMessage:@"感谢您的反馈..."];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token         = currentInfo.token;
    params.tranCode      = CHECKLOGOFFREASONCODE;
    params.randomCode    = [YMUserInfoTool shareInstance].randomCode;
    params.logoutReason  = reasonStr;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 收支明细接口
/**
 收支明细查询接口
 */
+ (void)loadHttpRequestWithPaymentDetailsType:(NSInteger)type pageNum:(NSInteger)pageNum Success:(void (^)(NSMutableArray *dataArray,YMBillBaseModel *model))success failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token    = currentInfo.token;
    params.tranCode = PAYMENTDETAILSCODE;
    params.numPerPag = @"20";//分页默认20
    params.pageNum = [NSString stringWithFormat:@"%ld",(long)pageNum];
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        @try {
            
            [MBProgressHUD hideHUD];
            /**新修改**/
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)responseObject;

                YMBillBaseModel *model = [YMBillBaseModel mj_objectWithKeyValues:dict];
                YMBillDataModel *dataModel = model.data;
                NSMutableArray *resultArray = [dataModel getListArray];
                
                if (!(resultArray.count>0)) {
                    [MBProgressHUD showText:model.resMsg];
                }
                success(resultArray,model);
            }else{
                if (failure) {
                    NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
                    [MBProgressHUD showText:er.domain];
                    failure(er);
                }
            }
            /****/
        } @catch (NSException *exception) {
            if (failure) {
                NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
                [MBProgressHUD showText:er.domain];
                failure(er);
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD]; 
        failure(error);
    }];
}

/**
 收支明细 --- 充值详情查询接口
 */
+ (void)loadHttpRequestWithReChargeDetailsModel:(YMBillDetailsModel *)paramsModel Success:(void (^)(YMBillDetailResultModel *model))success failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token = currentInfo.token;
    params.tranCode = RECHARGEDETAILCODE;
    params.prdOrdNo = paramsModel.prdOrdNo;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"充值详情查询 responseObject = %@",responseObject);
        @try {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dict = (NSDictionary *)responseObject;
                //通过jsonModel从新写
                if ([dict.allKeys containsObject:@"data"]&&[dict.allKeys containsObject:@"resCode"]&&[dict.allKeys containsObject:@"resMsg"])
                {
                    NSString *resMsgStr = dict[@"resMsg"];
                    NSInteger resCode = [dict[@"resCode"] integerValue];
                    NSDictionary *dataDict = dict[@"data"];
                    
                    YMReChargeDetailsModel *model = [YMReChargeDetailsModel mj_objectWithKeyValues:dataDict];
                    model.inOrOut = paramsModel.inOrOut;
                    //处理成自己想要的数据模型
                    YMBillDetailResultModel *resultModel = [YMBillDetailResultModel getReChangeDetailsModelWithModel:model];
                    if (resCode == 1) {
                        if (success) {
                            success(resultModel);
                        }
                    }else{
                        [MBProgressHUD showText:resMsgStr];
                    }
                }else{
                    [MBProgressHUD showText:@"失败"];
                }
            }else{
                [MBProgressHUD showText:@"失败"];
            }
            
        } @catch (NSException *exception) {
            [MBProgressHUD showText:@"失败"];
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 收支明细 --- 提现详情查询接口
 */
+ (void)loadHttpRequestWithCashDetailModel:(YMBillDetailsModel *)paramsModel Success:(void (^)(YMBillDetailResultModel *model))success failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token = currentInfo.token;
    params.tranCode = CASHDETAILCODE;
    params.prdOrdNo = paramsModel.prdOrdNo;
    params.orderType = [paramsModel getOrderTypeNum];//新增交易类型字段
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        YMLog(@"提现详情查询 responseObject = %@",responseObject);
        
        @try {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dict = (NSDictionary *)responseObject;
                //通过jsonModel从新写
                if ([dict.allKeys containsObject:@"data"]&&[dict.allKeys containsObject:@"resCode"]&&[dict.allKeys containsObject:@"resMsg"])
                {
                    NSString *resMsgStr = dict[@"resMsg"];
                    NSInteger resCode = [dict[@"resCode"] integerValue];
                    NSDictionary *dataDict = dict[@"data"];
                    
                    YMCashDetailsModel *model = [YMCashDetailsModel mj_objectWithKeyValues:dataDict];
                    
                    model.inOrOut = paramsModel.inOrOut;
                    //处理成自己想要的数据模型
                    YMBillDetailResultModel *resultModel = [YMBillDetailResultModel getCashDetailsModelWithModel:model];
                    
                    [MBProgressHUD hideHUD];
                    if (resCode == 1) {
                        if (success) {
                            success(resultModel);
                        }
                    }else{
                        [MBProgressHUD showText:resMsgStr];
                    }
                }else{
                    NSString *msg = @"失败";
                    if ([dict.allKeys containsObject:@"resMsg"]) {
                        msg = dict[@"resMsg"];
                    }
                    [MBProgressHUD showText:msg];
                }
            }else{
                [MBProgressHUD showText:@"失败"];
            }
            
        } @catch (NSException *exception) {
            [MBProgressHUD showText:@"失败"];
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/**
 收支明细 --- 预付费卡充值查询接口
 */
+ (void)loadHttpRequestWithPrepaidCardDetailModel:(YMBillDetailsModel *)paramsModel Success:(void (^)(YMBillDetailResultModel *model))success failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *params = [[RequestModel alloc] init];
    params.token = currentInfo.token;
    params.tranCode = PREPAIDCARDDETAILCODE;
    params.prdOrdNo = paramsModel.prdOrdNo;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        @try {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                YMLog(@"预付费卡充值查询 responseObject = %@",responseObject);
                
                NSDictionary *dict = (NSDictionary *)responseObject;
                //通过jsonModel从新写
                if ([dict.allKeys containsObject:@"data"]&&[dict.allKeys containsObject:@"resCode"]&&[dict.allKeys containsObject:@"resMsg"])
                {
                    NSString *resMsgStr = dict[@"resMsg"];
                    NSInteger resCode = [dict[@"resCode"] integerValue];
                    NSDictionary *dataDict = dict[@"data"];
                    
                    YMPrepaidCardDetailsModel *model = [YMPrepaidCardDetailsModel mj_objectWithKeyValues:dataDict];
                    
                    model.inOrOut = paramsModel.inOrOut;
                    //处理成自己想要的数据模型
                    YMBillDetailResultModel *resultModel = [YMBillDetailResultModel getPrepaidCardDetailsModelWithModel:model];
                    
                    [MBProgressHUD hideHUD];
                    if (resCode == 1) {
                        if (success) {
                            success(resultModel);
                        }
                    }else{
                        [MBProgressHUD showText:resMsgStr];
                    }
                }else{
                    [MBProgressHUD showText:@"失败"];
                }
            }else{
                [MBProgressHUD showText:@"失败"];
                if (failure) {
                    NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
                    failure(er);
                }
            }
        } @catch (NSException *exception) {
            [MBProgressHUD showText:@"失败"];
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 绑定预付费卡 校验 与 发送手机验证码
 
 creat by pzj
 @param parames 参数（卡号，手机号）
 @param success 成功
 @param failure 失败
 */
+ (void)loadHttpRequestWithAddPrepaidCardRequestModel:(RequestModel *)parames success:(void(^)(YMResponseModel *model))success
{
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parames.tranCode = ADDPREPAIDCODE;
    parames.token = currentInfo.token;
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:parames success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (success) {
            success(m);
        }
        if ([m getResCode] != 1) {//添加失败文案提示
            [MBProgressHUD showText:[m getResMsg]];
        }
       
    } failure:^(NSError *error) {
       [MBProgressHUD hideHUD];
    }];
}

/**
 绑定预付费卡 --- 验证手机验证码
 
 creat by pzj
 @param parames 参数（卡号、手机号、验证码 等）
 @param success 成功
 */
+ (void)loadHttpRequestWithCheckPrepaidCardValidateCode:(RequestModel *)parames success:(void(^)(YMResponseModel *model))success
{
    [MBProgressHUD showMessage:@"正在验证"];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parames.tranCode = CHECKPREPAIDVALIDATECODE;
    parames.token = currentInfo.token;
    [[super shareInstance] POST:BASEURL parameters:parames success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (m.resCode == 1) {
            [MBProgressHUD showText:@"预付卡添加成功"];
            if (success) {
                success(m);
            }
        }else{
            [MBProgressHUD showText:m.resMsg];
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 银行卡相关
//获取银行卡列表
+(void)loadHttpRequestWithCheckBankListsuccess:(void (^)(NSArray<YMBankCardModel *> *))success{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters    = [[RequestModel alloc]init];
    parameters.tranCode         = @"900240";
    parameters.token            = currentInfo.token;
    
    [MBProgressHUD show];
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        YMLog(@"获取银行卡列表 responseObject = %@",responseObject);
        NSInteger resCode = [responseObject[@"resCode"] integerValue];
        
        [MBProgressHUD hideHUD];
        if (resCode == 1) {
            NSArray * m = [YMBankCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            
            for (__strong YMBankCardModel *bm in m) {
                
                bm = bm.getDecryptAESModel;
                
            }
            
            currentInfo.bankCardArray = m;
            
            [currentInfo saveUserInfoToSanbox];
            if (success) {
                success(m);
            }
        } else {
            [MBProgressHUD showText:responseObject[@"resMsg"]];
        }
    } failure:^(NSError *error) {
        if (error.code == AFNetworkErrorType_NoNetwork || error.code == AFNetworkErrorType_ConnectToHost) {
            success([YMUserInfoTool shareInstance].bankCardArray);
        }
    }];
}
// 添加银行卡 获取银行卡信息
+(void)loadHttpRequestWithGetBankType:(NSString *)bankNo success:(void (^)(YMBankCardModel *))success
{
    [MBProgressHUD show];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.bankAcNo      = bankNo;
    params.tranCode      = GETBANKCARDBINFO;
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            YMBankCardModel *bankCard = [YMBankCardModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) {
                success(bankCard);
            }
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
        
    } failure:^(NSError *error) {}];
}
//获取添加银行卡时验证码
+(void)loadHttpRequestWithGetBankVCode:(RequestModel *)params success:(void (^)(NSInteger, NSString *, NSDictionary *))success
{
    [MBProgressHUD show];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.tranCode      = @"900250";
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1 || m.resCode == 36 || m.resCode == 37) {
            if (success) {
                success(m.resCode,m.resMsg, m.data);
            }
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }
        
    } failure:^(NSError *error) {
        
    }];

}
//绑定银行卡最后一步
+(void)loadHttRequestWithAttachBankCard:(RequestModel *)params success:(void (^)(YMResponseModel *m))success
{
    [MBProgressHUD show];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.tranCode      = @"900251";
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1) {
            if (success) {
                success(m);
            }
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

+(void)loadHttpRequestWithVerifyBankVCode:(YMBankCardModel *)bankCard validateCode:(NSString *)validateCode success:(void (^)(YMResponseModel *m))success
{
    [MBProgressHUD show];
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.bankPreMobile = bankCard.bankPreMobile;
    params.validateCode  = validateCode;
    params.tranCode      = @"900275";
    params.paySign       = bankCard.paySign;
    params.randomCode    = [YMUserInfoTool shareInstance].randomCode;
    params.cardDeadline  = bankCard.cardDeadline;
    params.safetyCode    = bankCard.safetyCode;
    params.cardType      = [NSString stringWithFormat:@"0%ld",(long)bankCard.cardType];
    
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1){
            if (success) {
                success(m);
            }
        } else {
            [MBProgressHUD showText:m.resMsg];
        }
        
    } failure:^(NSError *error) {}];
}

#pragma mark - 充值相关
//充值验证支付密码
+(NSURLSessionTask *)loadHttpRequestWithCheckPayPWD:(RequestModel *)params success:(void (^)(NSInteger, NSString *))success
{
    params.token         = [YMUserInfoTool shareInstance].token;
    params.tranCode      = @"900242";
   return [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
       
        if (success) {
            success(m.resCode,m.resMsg);
        }
    } failure:^(NSError *error) {
        if (success) {
            success(0,nil);
        }
    }];
    
}
//充值获取单号，以及支付token
+(void)loadHttpRequestWithRechargeMoney:(NSString *)money paySing:(NSString *)paySign flag:(NSString *)flag success:(void (^)(NSString *, NSInteger, NSString *))success
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = @"900241";
    parameters.token    = currentInfo.token;
    parameters.txAmt    = money;
    parameters.flag     = flag;
    parameters.paySign  = paySign;
    [MBProgressHUD show];
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        NSString *prdOrdNo = responseObject[@"data"][@"prdOrdNo"];
        NSInteger resCode = [responseObject[@"resCode"] integerValue];
        [MBProgressHUD hideHUD];
        if (success) {
            success(responseObject[@"resMsg"],resCode,prdOrdNo);
        }
    } failure:^(NSError *error) {
    
    }];
}
#pragma mark - 预付卡相关
//获取预付卡列表
+(void)loadHttpRequestWithGetPrepaidCardListSuccess:(void (^)(NSArray<YMPrepaidCardModel *> *))success
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = @"900233";
    parameters.token    = currentInfo.token;

    [MBProgressHUD show];
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        NSInteger resCode = [responseObject[@"resCode"] integerValue];
        [MBProgressHUD hideHUD];
        
        @try {
            if (resCode == 1) {
                NSArray *array = [YMPrepaidCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                for (__strong YMPrepaidCardModel *preCard in array) {
                    preCard = [preCard getDecryptAESModel];
                }
                currentInfo.prepaidCardArray = array;
                [currentInfo saveUserInfoToSanbox];
                if (success) {
                    success(array);
                }
                
            } else {
                [MBProgressHUD showText:responseObject[@"resMsg"]];
            }
        } @catch (NSException *exception) {
            [MBProgressHUD hideHUD];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (error.code == AFNetworkErrorType_NoNetwork || error.code == AFNetworkErrorType_ConnectToHost) {
            success([YMUserInfoTool shareInstance].prepaidCardArray);
        }
    }];

}

/**
 预付卡充值—建立预付卡商品订单

 changed by pzj
 @param parameters 参数
 @param success 成功
 */
+(void)loadHttpRequestWithRechargePrepaidParameters:(RequestModel *)parameters Success:(void (^)(YMBankCardBaseModel *bankCardBaseModel))success
{
    [MBProgressHUD show];
    
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parameters.tranCode  = @"900262";
    parameters.token     = currentInfo.token;
    
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            YMBankCardBaseModel *bankCardBaseModel = [YMBankCardBaseModel mj_objectWithKeyValues:resultDict];
            for (YMBankCardModel *m in bankCardBaseModel.data.list) {
                m.bankAcNo = m.bankAcNo.decryptAES;
                m.paySign = m.paySign.decryptAES;
            }
            if ([bankCardBaseModel getResCodeNum] == 1) {
                if (success) {
                    success(bankCardBaseModel);
                }
            }else{
                [MBProgressHUD showText:[bankCardBaseModel getResMsgStr]];
            }
        }
    } failure:^(NSError *error) {
        
    }];

}

// 预付卡充值—使用银行卡校验支付密码完成充值
+(NSURLSessionTask *)loadHttpRequestWithPrepaidCardRechargeCheckPayPWD:(RequestModel *)params success:(void (^)(NSInteger, NSString *))success
{
    params.token         = [YMUserInfoTool shareInstance].token;
    params.tranCode      = @"900269";
    return [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (success) {
            success(m.resCode,m.resMsg);
        }
        
    } failure:^(NSError *error) {}];
}

/**
 预付卡充值—使用虚拟账户校验支付密码完成充值
 
 created by pzj 2017-3-22
 @param params 参数参考接口文档
 @param success 成功
 */
+ (NSURLSessionTask *)loadHttpRequestWithPayByBlanceParams:(RequestModel *)params success:(void (^)(YMResponseModel *model))success
{
    params.token         = [YMUserInfoTool shareInstance].token;
    params.tranCode      = PAYBALANCECODE;
   return [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (success) {
            success(m);
        }
    } failure:^(NSError *error) {}];
}
#pragma mark - 提现相关
//校验提现金额
+(void)loadHttpRequestWithCheckWithdrawalsMoney:(RequestModel *)parames success:(void (^)(NSInteger, NSString *, NSString *))success
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parames.tranCode = @"900244";
    parames.token    = currentInfo.token;
    
    [MBProgressHUD show];
    [[super shareInstance] POST:BASEURL parameters:parames success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSInteger resCode  = [responseObject[@"resCode"] integerValue];
        NSString *resMsg   = responseObject[@"resMsg"];
        NSString *casordNo = responseObject[@"data"][@"casordNo"];
        if (success) {
            success(resCode,resMsg,casordNo);
        }
    } failure:^(NSError *error) {
        
    }];

}
//提现验证支付密码
+(NSURLSessionTask *)loadHttpRequestWithCheckWithdrawalsPWD:(RequestModel *)params success:(void (^)(NSInteger, NSString *))success
{
    params.token         = [YMUserInfoTool shareInstance].token;
    params.tranCode      = @"900245";
    return [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (success) {
            success(m.resCode,m.resMsg);
        }
    } failure:^(NSError *error) {}];

}

#pragma mark - 删除预付费卡和银行卡
//删除银行卡
+(NSURLSessionTask *)loadHttpRequestWithDeleteBankCard:(NSString *)paySign payPwd:(NSString *)payPwd success:(void (^)(NSInteger, NSString *))success{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = @"900253";
    parameters.token    = currentInfo.token;
    parameters.payPwd   = payPwd;
    parameters.paySign  = paySign;
    return [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
    YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
    if (success) {
        success(m.resCode,m.resMsg);
        }
    } failure:^(NSError *error) {
        
    }];
}
//删除预付费卡
+(NSURLSessionTask *)loadHttpRequestWithDeletePrepaidCard:(NSString *)prepaidNo payPwd:(NSString *)payPwd success:(void (^)(NSInteger, NSString *))success
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = @"900237";
    parameters.token    = currentInfo.token;
    parameters.payPwd   = payPwd;
    parameters.prepaidNo  = prepaidNo;
   return [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
    YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
     if (success) {
        success(m.resCode,m.resMsg);
       }
    } failure:^(NSError *error) {
        
    }];
}

+(void)loadHttpRequestWithCheckAccountsuccess:(void (^)(NSInteger, NSString *))success
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = @"900273";
    parameters.token    = currentInfo.token;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        if (success) {
            success(m.resCode,m.threeAcLogin);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 交易    -----  app3期新增加
#pragma mark - 转账到余额
/**
 转账到余额--校验转入方账户、转出方余额限额信息
 
 creat by pzj 2017-5-4
 creat by pzj 2017-7-28 app4期新增加参数
 @param account 对方手机号
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBalanceCheckAccount:(RequestModel *)parameters success:(void(^)(YMTransferCheckAccountDataModel *model))success failure:(void (^)(NSString *resMsg))failure
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parameters.tranCode = TRANSFERBALANCECHECKACCOUNT;
    parameters.token = currentInfo.token;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {

        [MBProgressHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMTransferCheckAccountModel *model = [YMTransferCheckAccountModel mj_objectWithKeyValues:dict];
            NSString *resCode = [model getResCodeStr];
            NSString *resMsg = [model getResMsgStr];
            YMTransferCheckAccountDataModel *dataModel = [model getDtatModel];
            if ([resCode isEqualToString:@"1"]) {
                if (success) {
                    success(dataModel);
                }
            }else{
                if (failure) {
                    failure(resMsg);
                }
                [MBProgressHUD showText:resMsg];
            }
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error.domain);
        }
        [MBProgressHUD hideHUD];
    }];
}

/**
 转账到余额--发送注册邀请
 
 creat by pzj 2017-5-4
 @param account 对方手机号
 */
+ (void)loadHttpRequestWithTransferToBalanceInviteAccount:(NSString *)account{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = TRANSFERBALANCEINVITE;
    parameters.token = currentInfo.token;
    parameters.usrMp = account;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        NSString *msg = [m getResMsg];
        [MBProgressHUD showText:msg];
    } failure:^(NSError *error) {
        
    }];
}


/**
 转账到余额--创建转账订单
 
 creat by pzj 2017-5-5
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBalanceCreatOrderParameters:(RequestModel *)parameters success:(void(^)(YMTransferCreatOrderDataModel *model,NSString *resCode,NSString *resMsg))success
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parameters.token    = currentInfo.token;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"转账到余额--创建转账订单 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict.allKeys containsObject:@"resCode"]&&[dict.allKeys containsObject:@"resMsg"]){
                NSString *resMsgStr = dict[@"resMsg"];
                NSString *resCodeStr = dict[@"resCode"];
                if ([resCodeStr isEqualToString:@"1"]) {
                    if ([dict.allKeys containsObject:@"data"]) {
                        NSDictionary *dataDict = dict[@"data"];
                        YMTransferCreatOrderDataModel*dataModel = [YMTransferCreatOrderDataModel mj_objectWithKeyValues:dataDict];
                        if (success) {
                            success(dataModel,resCodeStr,resMsgStr);
                        }
                    }else{
                        [MBProgressHUD showText:resMsgStr];
                    }
                }else{
                    if (success) {
                        success(nil,resCodeStr,resMsgStr);
                    }
                    if ([resCodeStr intValue] != CardInfoChange_CODE) {
                       [MBProgressHUD showText:resMsgStr];
                    }
                }
            }else{
                [MBProgressHUD showText:@"失败"];
            }
        }else{
            [MBProgressHUD showText:@"失败"];
        }
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
    }];
}

/**
 转账到余额--校验支付密码

 creat by pzj 2017-5-5
 @param parameters 参数
 @param success 成功
 */
+ (NSURLSessionTask *)loadHttpRequestWithTransferToBalanceCheckPayPwdParameters:(RequestModel *)parameters success:(void(^)(YMTransferCheckPayPwdModel *model))success{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parameters.token    = currentInfo.token;
    return [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMTransferCheckPayPwdModel *resultModel = [YMTransferCheckPayPwdModel mj_objectWithKeyValues:dict];
            YMTransferCheckPayPwdDataModel *dataModel = [resultModel getDtatModel];
            dataModel.traordNo = parameters.traordNo;
            resultModel.data = dataModel;
            
            if (success) {
                success(resultModel);
            }
        }
        
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
    }];
}

/**
 转账----查询最近转账记录

 creat by pzj 2017-5-5
 @param succes 成功
 */
+ (void)loadHttpRequestWithTransferRecentRecordSucess:(void(^)(NSMutableArray *array))success failure:(void (^)())failure
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = TRANSFERRECENTRECODE;
    parameters.token    = currentInfo.token;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            //转账---最近转账记录
            YMTransferRecentRecodeModel *model = [YMTransferRecentRecodeModel mj_objectWithKeyValues:dict];
            
            YMTransferRecentRecodeDataModel * dataModel = [model getDataModel];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            dataArray = [dataModel getListArray];
            if ([[model getResCodeStr]isEqualToString:@"1"]) {//成功
                if (success) {
                    success(dataArray);
                }
            }else{
                if (failure) {
                    failure();
                }
            }
        }else{
            if (failure) {
                failure();
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure();
        }
    }];
}
#pragma mark - 转账到银行卡
/**
 转账到银行卡---验证银行卡
 
 creat by pzj 2017-5-9
 @param bankAcNo 银行卡号
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankCheckBankCard:(NSString *)bankAcNo success:(void(^)(YMTransferToBankCheckBankDataModel *model))success
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = TRANSFERBANKCHECKCARDCODE;
    parameters.token    = currentInfo.token;
    parameters.bankAcNo = bankAcNo;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMTransferToBankCheckBankModel *resultModel = [YMTransferToBankCheckBankModel mj_objectWithKeyValues:dict];
            YMTransferToBankCheckBankDataModel *dataModel = [resultModel getDtatModel];
            NSString *resMsg = [resultModel getResMsgStr];
            NSString *resCode = [resultModel getResCodeStr];
            if (![resCode isEqualToString:@"1"]) {
               [MBProgressHUD showText:resMsg];
            }else{
                if (![[dataModel getCardTypeStr]isEqualToString:@"01"]) {//银行卡类型，不支持信用卡转账
                    [MBProgressHUD showText:MSG16];
                }
            }
            if (success) {
                success(dataModel);
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

/**
 转账到银行卡---查询转账手续费
 
 creat by pzj 2017-5-9
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankSearchReqFeeParameters:(RequestModel *)parameters success:(void(^)(YMTransferToBankSearchFeeDataModel *model))success
{
    [MBProgressHUD show];
    parameters.token = [YMUserInfoTool shareInstance].token;
    parameters.tranCode = TRANSFERBANKSEARCHREQFEECODE;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMTransferToBankSearchReqFeeModel *resultModel = [YMTransferToBankSearchReqFeeModel mj_objectWithKeyValues:dict];
            YMTransferToBankSearchFeeDataModel *dataModel = [resultModel getDtatModel];
            NSString *resMsg = [resultModel getResMsgStr];
            NSString *resCode = [resultModel getResCodeStr];
            if (success) {
                success(dataModel);
            }
            if ([resCode isEqualToString:@"1"]) {
                
            }else{
                [MBProgressHUD showText:resMsg];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

/**
 转账到银行卡---生成转账订单
 
 creat by pzj 2017-5-9
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankCreatOrderParameters:(RequestModel *)parameters success:(void(^)(YMTransferCreatOrderDataModel *model))success
{
    [MBProgressHUD show];
    parameters.token = [YMUserInfoTool shareInstance].token;
    parameters.tranCode = TRANSFERBANKCREATORDERCODE;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict.allKeys containsObject:@"resCode"]&&[dict.allKeys containsObject:@"resMsg"]){
                NSString *resMsgStr = dict[@"resMsg"];
                NSString *resCodeStr = dict[@"resCode"];
                if ([resCodeStr isEqualToString:@"1"]) {
                    if ([dict.allKeys containsObject:@"data"]) {
                        NSDictionary *dataDict = dict[@"data"];
                        YMTransferCreatOrderDataModel *dataModel = [YMTransferCreatOrderDataModel mj_objectWithKeyValues:dataDict];
                        if (success) {
                            success(dataModel);
                        }
                    }else{
                        [MBProgressHUD showText:resMsgStr];
                    }
                }else{
                    [MBProgressHUD showText:resMsgStr];
                }
            }else{
                [MBProgressHUD showText:@"失败"];
            }
        }else{
            [MBProgressHUD showText:@"失败"];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
}

/**
 转账到银行卡---转账发起代付
 
 creat by pzj 2017-5-10
 @param parameters 参数
 @param success 成功
 */
+ (NSURLSessionTask *)loadHttpRequestWithTransferToBankPayPwdParameters:(RequestModel *)parameters success:(void(^)(YMTransferCheckPayPwdModel *model))success
{
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    parameters.tranCode = TRANSFERBANKPAYPWDCODE;
    parameters.token    = currentInfo.token;
    return [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMTransferCheckPayPwdModel *resultModel = [YMTransferCheckPayPwdModel mj_objectWithKeyValues:dict];
            YMTransferCheckPayPwdDataModel *dataModel = [resultModel getDtatModel];
            dataModel.traordNo = parameters.traordNo;
            dataModel.backError = [resultModel getResMsgStr];
            resultModel.data = dataModel;
            if (success) {
                success(resultModel);
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

/**
 转账到银行卡---限额说明
 creat by pzj 2017-5-10
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankMoneyLimitSuccess:(void(^)(YMTransferToBankLimitDataModel *model))success
{
    [MBProgressHUD show];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    RequestModel *parameters  = [[RequestModel alloc]init];
    parameters.tranCode = TRANSFERBANKLIMITCODE;
    parameters.token    = currentInfo.token;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            YMTransferToBankLimitModel *limitModel = [YMTransferToBankLimitModel mj_objectWithKeyValues:dict];
            YMTransferToBankLimitDataModel *dataModel = limitModel.data;
            if ([[limitModel getResCodeStr]isEqualToString:@"1"]) {//成功
                if (success) {
                    success(dataModel);
                }
            }else{
                [MBProgressHUD showText:[limitModel getResMsgStr]];
            }
 
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

/**
 查询账单列表

 change by pzj app4期 2017-7-25
 @param params 参数
 @param success 成功
 @param failure 失败
 */
+(void)loadHttpRequestWithBillList:(RequestModel *)params success:(void(^)(NSMutableArray *array,YMAllBillListModel *model))success failure:(void (^)(NSError *error))failure
{
    params.token = [YMUserInfoTool shareInstance].token;
    params.tranCode = BILLLISTCODE;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",responseObject);
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMAllBillListModel *resultModel = [YMAllBillListModel mj_objectWithKeyValues:dict];
            NSString *resCodeStr = [resultModel getResCodeStr];
            NSString *resMsgStr = [resultModel getResMsgStr];
            if ([resCodeStr isEqualToString:@"1"]) {
                
                YMAllBillListDataModel *dataModel = [resultModel getDataModel];
                NSMutableArray *listArray = [dataModel getListArray];
                if (success) {
                    success(listArray,resultModel);
                }
                
            }else{
                if (failure) {
                    NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
                    failure(er);
                }
                [MBProgressHUD showText:resMsgStr];
            }
            
        }else{
            if (failure) {
                NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
                [MBProgressHUD showText:er.domain];
                failure(er);
            }
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 查询账单详情

 change by pzj app4期 2017-7-25
 @param params 参数
 @param success 成功
 */
+(void)loadHttpRequestWithBillDetailsParams:(RequestModel *)params success:(void(^)(YMAllBillDetailDataModel *detailDataModel))success
{
    [MBProgressHUD show];
    params.tranCode = BILLDETAILCODE;
    params.token = [YMUserInfoTool shareInstance].token;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"查询账单详情 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMAllBillDetailModel *resultModel = [YMAllBillDetailModel mj_objectWithKeyValues:dict];
            NSString *resCodeStr = [resultModel getResCodeStr];
            NSString *resMsgStr = [resultModel getResMsgStr];
            if ([resCodeStr isEqualToString:@"1"]) {
                YMAllBillDetailDataModel *dataModel = [resultModel getDataModel];
                if (success) {
                    success(dataModel);
                }
            }else{
                [MBProgressHUD showText:resMsgStr];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - 扫码相关

+(void)loadHttpRequestWithScanCreatOrderParameters:(NSString *)prdOrdNo merNo:(NSString *)merNo success:(void (^)(id, NSInteger, NSString *))success
{
    RequestModel *params = [[RequestModel alloc]init];
    params.tranCode      = @"900301";
    params.prdOrdNo      = prdOrdNo;
    params.merNo         = merNo;
    params.token         = [YMUserInfoTool shareInstance].token;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        NSString *resMsg  = responseObject[@"resMsg"];
        NSInteger resCode = [responseObject[@"resCode"] integerValue];
        YMScanModel *m    = [YMScanModel mj_objectWithKeyValues:responseObject[@"data"]];

            for (YMBankCardModel * m2 in m.list) {
                [m2 getDecryptAESModel];
            }
            
            if (success) {
                success(m,resCode,resMsg);
            }
        
    } failure:^(NSError *error) {
        
    }];
}


/**
 扫pc端二维码，校验支付密码接口

 @param params 参数
 @param success 成功
 @return
 */
+(NSURLSessionTask *)loadHttpRequestWithScanToPay:(RequestModel *)params success:(void (^)(NSInteger,NSString *))success
{
    
    params.tranCode = @"900302";
    params.token = [YMUserInfoTool shareInstance].token;
   return [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        NSString *resMsg  = responseObject[@"resMsg"];
        NSInteger resCode = [responseObject[@"resCode"] integerValue];
        if (success) {
            success(resCode,resMsg);
        }
    } failure:^(NSError *error) {
        if (success) {
            success(0,nil);
        }
    }];
}

+(void)loadHttpRequestWithGetScanDetailsParameters:(NSString *)prdOrdNo success:(void (^)(id))success
{
    RequestModel *params = [[RequestModel alloc]init];
    params.tranCode = @"900303";
    params.prdOrdNo = prdOrdNo;
    params.token = [YMUserInfoTool shareInstance].token;
    [MBProgressHUD show];
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *resMsg  = responseObject[@"resMsg"];
        NSInteger resCode = [responseObject[@"resCode"] integerValue];
        
        if (resCode == 1) {
            YMScanDetailsModel *m = [YMScanDetailsModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (success) {
                success(m);
            }
        } else {
            [MBProgressHUD showText:resMsg];
        }
    } failure:^(NSError *error) {
        
    }];
}


/**
 获取查询支付方式（充值/扫一扫）
 creat by pzj
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithGetPayTypeParameters:(RequestModel *)parameters success:(void (^)(YMBankCardBaseModel *baseModel))success
{
    [MBProgressHUD show];
    parameters.tranCode = GETPAYTYPECODE;
    parameters.token = [YMUserInfoTool shareInstance].token;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"查询支付方式 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            YMBankCardBaseModel *bankCardBaseModel = [YMBankCardBaseModel mj_objectWithKeyValues:resultDict];
            for (YMBankCardModel *m in bankCardBaseModel.data.list) {
                m.bankAcNo = m.bankAcNo.decryptAES;
                m.paySign = m.paySign.decryptAES;
            }
            if ([bankCardBaseModel getResCodeNum] == 1) {
                if (success) {
                    success(bankCardBaseModel);
                }
            }else{
                [MBProgressHUD showText:[bankCardBaseModel getResMsgStr]];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

+(void)loadHttpRequestWithGetAutoPayTypeParameters:(RequestModel *)parameters success:(void (^)(id))success
{
    [MBProgressHUD show];
    parameters.tranCode = AUTOPAYTYPECODE;
    parameters.token = [YMUserInfoTool shareInstance].token;
    [[super shareInstance] POST:BASEURL parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDict = (NSDictionary *)responseObject;
            YMBankCardBaseModel *bankCardBaseModel = [YMBankCardBaseModel mj_objectWithKeyValues:resultDict];
            for (YMBankCardModel *m in bankCardBaseModel.data.list) {
                m.bankAcNo = m.bankAcNo.decryptAES;
                m.paySign = m.paySign.decryptAES;
            }
            if ([bankCardBaseModel getResCodeNum] == 1) {
                if (success) {
                    success(bankCardBaseModel);
                }
            }else{
                [MBProgressHUD showText:[bankCardBaseModel getResMsgStr]];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark - app4期新增投诉相关
/**
 投诉申请
 
 creat by pzj
 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithApplyComplaintParams:(RequestModel *)params success:(void (^)())success
{
    [MBProgressHUD show];
    params.tranCode = APPLYCOMPLAINTCODE;
    params.token = [YMUserInfoTool shareInstance].token;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMResponseModel *m = [YMResponseModel loadModelFromDic:dict];
            NSInteger resCode = [m getResCode];
            NSString *resMsg  =[m getResMsg];
            if (resCode == 1) {
                if (success) {
                    success();
                }
            }
            [MBProgressHUD showText:resMsg];
        }else{
            NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
            [MBProgressHUD showText:er.domain];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}


/**
 投诉-

 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithRevokeOrConfirmParams:(RequestModel *)params success:(void (^)(NSString *acceptState))success{

    [MBProgressHUD show];
    params.tranCode = REVOKEORCONFIRMCODE;
    params.token = [YMUserInfoTool shareInstance].token;
    [[super  shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"投诉-撤销或者确认 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMRevokeOrConfirmModel *resultModel = [YMRevokeOrConfirmModel mj_objectWithKeyValues:dict];
            NSString *resCode = [resultModel getResCodeStr];
            NSString *resMsg  =[resultModel getResMsgStr];
            YMRevokeOrConfirmDataModel *dataModel = [resultModel getDataModel];
            NSString *acceptState = [dataModel getStateStr];
            if ([resCode isEqualToString:@"1"]) {
                if (success) {
                    success(acceptState);
                }
            }
            [MBProgressHUD showText:resMsg];
        }else{
            NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
            [MBProgressHUD showText:er.domain];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

/**
cx
 
 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithRevokeOrConfirmParamsONE:(RequestModel *)params success:(void (^)(NSString *acceptState))success{
    
    [MBProgressHUD show];
    params.tranCode = REVOKEORCONFIRMCODEONE;
    params.token = [YMUserInfoTool shareInstance].token;
    [[super  shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"投诉-撤销或者确认 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMRevokeOrConfirmModel *resultModel = [YMRevokeOrConfirmModel mj_objectWithKeyValues:dict];
            NSString *resCode = [resultModel getResCodeStr];
            NSString *resMsg  =[resultModel getResMsgStr];
            YMRevokeOrConfirmDataModel *dataModel = [resultModel getDataModel];
            NSString *acceptState = [dataModel getStateStr];
            if ([resCode isEqualToString:@"1"]) {
                if (success) {
                    success(acceptState);
                }
            }
            [MBProgressHUD showText:resMsg];
        }else{
            NSError * er = [NSError errorWithDomain:@"失败" code:CUSTOM_CODE userInfo:nil];
            [MBProgressHUD showText:er.domain];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - tx

/**
 校验银行卡是否是否可用
 
 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithCheckBankCardCanUse:(RequestModel *)params success:(void (^)())success faile:(void(^)())faile
{
    params.tranCode = CheckBankCardCanUseCODE;
    params.token = [YMUserInfoTool shareInstance].token;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict.allKeys containsObject:@"resCode"]&&[dict.allKeys containsObject:@"resMsg"]){
                NSString *resMsgStr = dict[@"resMsg"];
                NSString *resCodeStr = dict[@"resCode"];
                if ([resCodeStr isEqualToString:@"1"]) {
                    if (success) {
                        success();
                    }
                }else{
                    if (faile) {
                        faile();
                    }
                }
                [MBProgressHUD showText:resMsgStr];
            }
        }else{
            if (faile) {
                faile();
            }
        }
    } failure:^(NSError *error) {
        if (faile) {
            faile();
        }
        [MBProgressHUD hideHUD];
    }];
}

/**
 tx 创建商品订单
 
 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTXCreatOrderParams:(RequestModel *)params success:(void(^)(YMTransferCreatOrderDataModel *model,NSString *resCode,NSString *resMsg))success
{
    [MBProgressHUD show];
    params.tranCode = TXCreatOrderCODE;
    params.token = [YMUserInfoTool shareInstance].token;
    [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        YMLog(@"转账到余额--创建转账订单 responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            if ([dict.allKeys containsObject:@"resCode"]&&[dict.allKeys containsObject:@"resMsg"]){
                NSString *resMsgStr = dict[@"resMsg"];
                NSString *resCodeStr = dict[@"resCode"];
                if ([resCodeStr isEqualToString:@"1"]) {
                    if ([dict.allKeys containsObject:@"data"]) {
                        NSDictionary *dataDict = dict[@"data"];
                        YMTransferCreatOrderDataModel*dataModel = [YMTransferCreatOrderDataModel mj_objectWithKeyValues:dataDict];
                        if (success) {
                            success(dataModel,resCodeStr,resMsgStr);
                        }
                    }else{
                        [MBProgressHUD showText:resMsgStr];
                    }
                }else{
                    if (success) {
                        success(nil,resCodeStr,resMsgStr);
                    }
                    if ([resCodeStr intValue] != CardInfoChange_CODE) {
                        [MBProgressHUD showText:resMsgStr];
                    }
                }
            }else{
                [MBProgressHUD showText:@"失败"];
            }
        }else{
            [MBProgressHUD showText:@"失败"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}
/**
 tx 校验支付密码完成支付
 
 @param params 参数
 @param success 成功
 @return
 */
+ (NSURLSessionTask *)loadHttpRequestWithTXCheckPwdParams:(RequestModel *)params success:(void(^)(YMTransferCheckPayPwdModel *model))success
{
    params.tranCode = TXCheckPwdCODE;
    params.token = [YMUserInfoTool shareInstance].token;
    return [[super shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        YMLog(@"responseObject = %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            YMTransferCheckPayPwdModel *resultModel = [YMTransferCheckPayPwdModel mj_objectWithKeyValues:dict];

            if (success) {
                success(resultModel);
            }
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];

    }];
}


@end
