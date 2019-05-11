//
//  YMMyHttpRequestApi.h
//  WSYMPay
//
//  Created by pzj on 2017/3/10.
//  Copyright © 2017年 赢联. All rights reserved.
//


/**
 我的模块---api---请求类
 */
#import <Foundation/Foundation.h>

@class YMUserInfoTool;
@class YMResponseModel;
@class YMBillDetailsDescModel;
@class RequestModel;
@class YMUserInfoTool,YMBankCardModel,YMPrepaidCardModel;
@class YMBankCardBaseModel;
@class YMBillBaseModel;
@class YMBillDetailResultModel;
@class YMBillDetailsModel;
@class YMTransferCheckAccountDataModel,YMTransferCreatOrderDataModel,YMTransferRecentRecodeDataModel,YMTransferCheckPayPwdModel,YMTransferCheckPayPwdDataModel;
@class YMTransferDetailsModel;
@class YMTransferToBankCheckBankDataModel;
@class YMTransferToBankSearchFeeDataModel;
@class YMTransferToBankLimitDataModel;

@class YMAllBillListModel;
@class YMAllBillDetailModel;
@class YMAllBillDetailDataModel;

@interface YMMyHttpRequestApi : YMHTTPRequestTool

#pragma mark - 点击注销账户，用户状态校验接口
/**
 点击注销账户，用户状态校验接口
 creat by pzj
 
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)loadHttpRequestWithCheckLogoffSuccess:(void (^)(YMResponseModel *model))success failure:(void (^)(NSError *error))failure;
/**
 校验验证码/支付密码，注销账户
 creat by pzj
 
 @param codeString 实名用户：支付密码 / 未实名用户：验证码
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)loadHttpRequestWithCheckPayPwdOrValidateCode:(NSString *)codeString success:(void (^)(YMResponseModel *model))success failure:(void (^)(NSError *error))failure;

/**
 发送注销验证码
 creat by pzj
 
 @param success 成功
 */
+ (void)loadHttpRequestWithSendValidateCodeSuccess:(void (^)(YMResponseModel *model))success;

/**
 保存注销原因
 creat by pzj
 
 @param reasonStr 注销原因
 @param NSString 随机串
 @param success
 */
+ (void)loadHttpRequestWithSaveReason:(NSString *)reasonStr Success:(void (^)(YMResponseModel *model))success;

#pragma mark - 收支明细接口
/**
 收支明细查询接口
 creat by pzj
 */
+ (void)loadHttpRequestWithPaymentDetailsType:(NSInteger)type  pageNum:(NSInteger)pageNum Success:(void (^)(NSMutableArray *dataArray,YMBillBaseModel *model))success failure:(void (^)(NSError *error))failure;

/**
 收支明细 --- 充值详情查询接口
 creat by pzj
 */
+ (void)loadHttpRequestWithReChargeDetailsModel:(YMBillDetailsModel *)paramsModel Success:(void (^)(YMBillDetailResultModel *model))success failure:(void (^)(NSError *error))failure;

/**
 收支明细 --- 提现详情查询接口
 creat by pzj
 */
+ (void)loadHttpRequestWithCashDetailModel:(YMBillDetailsModel *)paramsModel Success:(void (^)(YMBillDetailResultModel *model))success failure:(void (^)(NSError *error))failure;
/**
 收支明细 --- 预付费卡充值查询接口
 creat by pzj
 */
+ (void)loadHttpRequestWithPrepaidCardDetailModel:(YMBillDetailsModel *)paramsModel Success:(void (^)(YMBillDetailResultModel *model))success failure:(void (^)(NSError *error))failure;

#pragma mark - 银行卡相关
/**
 获取银行卡列表
 
 @param success 成功
 @param failure 失败
 */
+(void)loadHttpRequestWithCheckBankListsuccess:(void(^)(NSArray<YMBankCardModel*>*response))success;

/**
 充值

 @param money 金额
 @param success 成功
 */
+ (void)loadHttpRequestWithRechargeMoney:(NSString *)money paySing:(NSString *)paySign flag:(NSString *)flag success:(void(^)(NSString *resMsg,NSInteger resCode,NSString *prdOrdNo))success;
/**
 绑定银行卡-获取银行卡信息

 @param bankNo 银行卡号
 @param success 成功返回银行卡模型
 */
+ (void)loadHttpRequestWithGetBankType:(NSString *)bankNo success:(void(^)(YMBankCardModel *bankCard))success;

/**
 绑定银行卡，获取验证码

 @param params 银行卡信息
 @param success 成功返回随机码
 */
+(void)loadHttpRequestWithGetBankVCode:(RequestModel *)params success:(void(^)(NSInteger resCode,NSString *resMsg, NSDictionary *data))success;

/**
 删除银行卡
 
 @param paySign 支付标记
 @param payPwd 支付密码
 @param success 成功回调
 */
+(NSURLSessionTask *)loadHttpRequestWithDeleteBankCard:(NSString *)paySign payPwd:(NSString *)payPwd success:(void(^)(NSInteger resCode,NSString *resMsg))success;

/**
 绑定银行卡最后一步

 @param params 银行卡数据
 @param success 成功回调
 */
+(void)loadHttRequestWithAttachBankCard:(RequestModel *)params success:(void (^)(YMResponseModel *m))success;
/**
 重新验证银行卡信息-验证验证码

 @param bankCard 银行卡模型
 @param validateCode 验证码
 @param success 成功
 */
+(void)loadHttpRequestWithVerifyBankVCode:(YMBankCardModel *)bankCard validateCode:(NSString *)validateCode success:(void(^)(YMResponseModel *m))success;

#pragma mark - 账户余额充值、提现
/**
 充值订单，验证支付密码

 @param params 充值所需银行卡数据
 @param success 成功回调
 @return 返回网络管理任务
 */
+(NSURLSessionTask *)loadHttpRequestWithCheckPayPWD:(RequestModel *)params success:(void(^)(NSInteger resCode,NSString *resMsg))success;

/**
 提现获取提现订单号以及随机码

 @param parames 提现信息
 @param success 成功回调
 */
+(void)loadHttpRequestWithCheckWithdrawalsMoney:(RequestModel *)parames success:(void(^)(NSInteger resCode,NSString *resMsg,NSString *casordNo))success;

/**
 提现验证支付密码
 @param params 提现信息
 @param success 成功回调
 @return 返回网络任务
 */
+(NSURLSessionTask *)loadHttpRequestWithCheckWithdrawalsPWD:(RequestModel *)params success:(void(^)(NSInteger resCode,NSString *resMsg))success;

#pragma mark 预付卡相关
/**
 获取预付卡列表
 
 @param success 成功回调
 */
+(void)loadHttpRequestWithGetPrepaidCardListSuccess:(void(^)(NSArray<YMPrepaidCardModel*>* prepaidCardList))success;

/**
 预付卡充值—建立预付卡商品订单
 
 changed by pzj
 @param parameters 参数
 @param success 成功
 */
+(void)loadHttpRequestWithRechargePrepaidParameters:(RequestModel *)parameters Success:(void (^)(YMBankCardBaseModel *bankCardBaseModel))success;

/**
 预付卡充值—使用银行卡校验支付密码完成充值

 @param params 请求参数
 @param success 成功回调
 */
+(NSURLSessionTask *)loadHttpRequestWithPrepaidCardRechargeCheckPayPWD:(RequestModel *)params success:(void(^)(NSInteger resCode,NSString *resMsg))success;

/**
 预付卡充值—使用虚拟账户校验支付密码完成充值
 
 created by pzj 2017-3-22
 @param params 参数参考接口文档
 @param success 成功
 */
+ (NSURLSessionTask *)loadHttpRequestWithPayByBlanceParams:(RequestModel *)params success:(void (^)(YMResponseModel *model))success;
/**
 删除预付卡

 @param prepaidNo 卡号
 @param payPwd 支付密码
 @param success 成功回调
 */
+(NSURLSessionTask *)loadHttpRequestWithDeletePrepaidCard:(NSString *)prepaidNo payPwd:(NSString *)payPwd success:(void(^)(NSInteger resCode,NSString *resMsg))success;

/**
 绑定预付费卡 校验 与 发送手机验证码
 
 creat by pzj
 @param parames 参数（卡号，手机号）
 @param success 成功
 @param failure 失败
 */
+ (void)loadHttpRequestWithAddPrepaidCardRequestModel:(RequestModel *)parames success:(void(^)(YMResponseModel *model))success;

/**
 绑定预付费卡 --- 验证手机验证码
 
 creat by pzj
 @param parames 参数（卡号、手机号、验证码 等）
 @param success 成功
 */
+ (void)loadHttpRequestWithCheckPrepaidCardValidateCode:(RequestModel *)parames success:(void(^)(YMResponseModel *model))success;

/**
 升级手机账户验证
 @param success 成功回调
 */
+(void)loadHttpRequestWithCheckAccountsuccess:(void(^)(NSInteger resCode,NSString *threeAcLogin))success;

#pragma mark - 交易    -----  app3期新增加
#pragma mark - 转账到余额
/**
 转账到余额--校验转入方账户、转出方余额限额信息
 
 creat by pzj 2017-5-4
 creat by pzj 2017-7-28 app4期新增加参数
 @param account 对方手机号
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBalanceCheckAccount:(RequestModel *)parameters success:(void(^)(YMTransferCheckAccountDataModel *model))success failure:(void (^)(NSString *resMsg))failure;

/**
 转账到余额--发送注册邀请

 creat by pzj 2017-5-4
 @param account 对方手机号
 */
+(void)loadHttpRequestWithTransferToBalanceInviteAccount:(NSString *)account;

/**
 查询账单列表
 
 change by pzj app4期 2017-7-25
 @param params 参数
 @param success 成功
 @param failure 失败
 */
+(void)loadHttpRequestWithBillList:(RequestModel *)params success:(void(^)(NSMutableArray *array,YMAllBillListModel *model))success failure:(void (^)(NSError *error))failure;

/**
 查询账单详情
 
 change by pzj app4期 2017-7-25
 @param params 参数
 @param success 成功
 */
+(void)loadHttpRequestWithBillDetailsParams:(RequestModel *)params success:(void(^)(YMAllBillDetailDataModel *detailDataModel))success;

/**
 转账到余额--创建转账订单

 creat by pzj 2017-5-5
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBalanceCreatOrderParameters:(RequestModel *)parameters success:(void(^)(YMTransferCreatOrderDataModel *model,NSString *resCode,NSString *resMsg))success;

/**
 转账到余额--校验支付密码
 
 creat by pzj 2017-5-5
 @param parameters 参数
 @param success 成功
 */
+ (NSURLSessionTask *)loadHttpRequestWithTransferToBalanceCheckPayPwdParameters:(RequestModel *)parameters success:(void(^)(YMTransferCheckPayPwdModel *model))success;
/**
 转账----查询最近转账记录
 
 creat by pzj 2017-5-5
 @param succes 成功
 */
+ (void)loadHttpRequestWithTransferRecentRecordSucess:(void(^)(NSMutableArray *array))succes failure:(void (^)())failure;

#pragma mark - 转账到银行卡

/**
 转账到银行卡---验证银行卡
 
 creat by pzj 2017-5-9
 @param bankAcNo 银行卡号
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankCheckBankCard:(NSString *)bankAcNo success:(void(^)(YMTransferToBankCheckBankDataModel *model))success;

/**
 转账到银行卡---查询转账手续费

 creat by pzj 2017-5-9
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankSearchReqFeeParameters:(RequestModel *)parameters success:(void(^)(YMTransferToBankSearchFeeDataModel *model))success;

/**
 转账到银行卡---生成转战订单

 creat by pzj 2017-5-9
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankCreatOrderParameters:(RequestModel *)parameters success:(void(^)(YMTransferCreatOrderDataModel *model))success;

#pragma mark - 扫码

/**
 扫码创建订单

 @param prdOrdNo 订单号 和 商户号
 @param success 成功
 */
+(void)loadHttpRequestWithScanCreatOrderParameters:(NSString *)prdOrdNo merNo:(NSString *)merNo success:(void(^)(id model,NSInteger resCode,NSString *resMsg))success;

/**
 获取网购订单详情

 @param prdOrdNo 订单号
 @param success 成功
 */
+(void)loadHttpRequestWithGetScanDetailsParameters:(NSString *)prdOrdNo success:(void(^)(id model))success;

/**
 扫pc端二维码，校验支付密码接口
 
 @param params 参数
 @param success 成功
 @return
 */+(NSURLSessionTask *)loadHttpRequestWithScanToPay:(RequestModel *)params success:(void(^)(NSInteger resCode, NSString *resMsg))success;

/**
 转账到银行卡---转账发起代付

 creat by pzj 2017-5-10
 @param parameters 参数
 @param success 成功
 */
+ (NSURLSessionTask *)loadHttpRequestWithTransferToBankPayPwdParameters:(RequestModel *)parameters success:(void(^)(YMTransferCheckPayPwdModel *model))success;

/**
 转账到银行卡---限额说明
 creat by pzj 2017-5-10
 @param success 成功
 */
+ (void)loadHttpRequestWithTransferToBankMoneyLimitSuccess:(void(^)(YMTransferToBankLimitDataModel *model))success;

/**
 获取查询支付方式（充值/扫一扫）
 creat by pzj
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithGetPayTypeParameters:(RequestModel *)parameters success:(void (^)(YMBankCardBaseModel *baseModel))success;

/**
 获取查询支付方式（充值/扫一扫）
 creat by pzj
 @param parameters 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithGetAutoPayTypeParameters:(RequestModel *)parameters success:(void (^)(id))success;

#pragma mark - app4期新增投诉相关
/**
 投诉申请

 creat by pzj
 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithApplyComplaintParams:(RequestModel *)params success:(void (^)())success;

/**
 投诉
 
 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithRevokeOrConfirmParams:(RequestModel *)params success:(void (^)(NSString *acceptState))success;
/**
 撤销
 
 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithRevokeOrConfirmParamsONE:(RequestModel *)params success:(void (^)(NSString *acceptState))success;

#pragma mark - tx相关
/**
 校验银行卡是否是否可用

 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithCheckBankCardCanUse:(RequestModel *)params success:(void (^)())success faile:(void(^)())faile;

/**
 tx 创建商品订单

 @param params 参数
 @param success 成功
 */
+ (void)loadHttpRequestWithTXCreatOrderParams:(RequestModel *)params success:(void(^)(YMTransferCreatOrderDataModel *model,NSString *resCode,NSString *resMsg))success;

/**
 tx 校验支付密码完成支付

 @param params 参数
 @param success 成功
 @return
 */
+ (NSURLSessionTask *)loadHttpRequestWithTXCheckPwdParams:(RequestModel *)params success:(void(^)(YMTransferCheckPayPwdModel *model))success;

@end
