//
//  YMPublicInterface.h
//  WSYMPay
//
//  Created by W-Duxin on 16/11/11.
//  Copyright © 2016年 赢联. All rights reserved.
//

#ifndef YMPublicInterface_h
#define YMPublicInterface_h


#define ISTESTURL 1//1开发 0生产


#if ISTESTURL
#define IP @"http://27.223.91.242:23456"
#define UPLOADURL   IP@"/user/servlet/IdSubmitAuditServlet"
#else

//#define IP @"http://www.cbapay.com"
//#define UPLOADURL   @"https://www.cbapay.com/user/servlet/IdSubmitAuditServlet"
/*
 * 2017-8-21 app 4 期修改
 */
#define IP @"https://www.cbapay.com"
#define UPLOADURL   @"https://www.cbapay.com/pay/user/servlet/IdSubmitAuditServlet"
/*
 * 2019-4-21 app n 期修改http://27.223.91.242:23456
 */

#define IP @"http://27.223.91.242:23456"
#define UPLOADURL   @"http://27.223.91.242:23456/pay/user/servlet/IdSubmitAuditServlet"
#endif


#define BASEURL IP"/user/servlet/appUser" // 请求地址

#define FINDACCOUNTNEWESTINFO    @"900200" //查询账户信息

#define REGISTERGETVCODE         @"900201" // 注册获取验证码

#define REGISTERUPLOADINFO       @"900202" //注册提交用户信息

#define FORGETPWDGETVCODE        @"900204" //忘记密码获取验证码

#define LOGIN                    @"900203" //用户登录

#define FORGETPWDVVCODE          @"900205" //忘记密码验证验证码

#define FORGETPWDSETNEWPWD       @"900206" //忘记密码设置新密码

#define CHANGEMOBILEGETCODE      @"900208" //获取手机号验证码

#define CHANGEMOBILEVVCODE       @"900209" //验证码效验

#define CHANGEE_MAILGETCODE      @"900292" //更改邮箱获取验证码
#define CHANGEEMAIL              @"900293" //更改邮箱
#define CHANGEE_MGETNEWMCODE     @"900290" //更改手机号 获取新验证码

#define CHANGEMOBILEVVNEWCODE    @"900291" //更改手机号新手机号验证码校验

#define CHANGEMOBILEVIDCARD      @"900225" //更改手机号验证身份证号

#define CHANGEMOBILEVPWD         @"900213" //更改手机号未实名时验证支付密码
#define CHANGMOBILEV_NEWCODE     @"900291" //更改手机号
#define CHANGEADDRESS            @"900216" //修改地区

#define GETOCCUPATIONINFO        @"900217" //获取职业信息

#define CHANGEOCCUPATION         @"900218" //更改职业

#define GETBANKCARDBINFO         @"900219" //获取卡bin验证银行卡是否已绑定

#define JUDEMENTSETPAYPWD        @"900220" //判断是否设置支付密码和发送验证码

#define SETPAYPWD                @"900221" //设置支付密码

#define VERIFICATIONATTACHTOBANK @"900222" //校验验证码并绑定银行卡

#define UPLOADIDCARD             @"900223" //上传身份证信息

#define SETTINGINFO              @"900224" //设置首页要显示的各种状态

#define SETTINGNEWPAYPWD         @"900226" //设置新支付密码

#define SETTINGLOGINPWD          @"900227" //设置新登录密码

#define CHECKLOGOFFCODE          @"900246" //注销--用户状态校验

#define SENDCHECKLOGOFFCODE      @"900247" //发送注销验证码

#define PAYPWDORVALIDATECODE     @"900248" //校验验证码/支付密码，注销账户

#define CHECKLOGOFFREASONCODE    @"900249" //保存注销原因

#define PAYMENTDETAILSCODE       @"900239" //收支明细查询

#define ADDPREPAIDCODE           @"900234" //绑定预付费卡

#define SENDPREPAIDCODE          @"900208" //绑定预付费卡 -- 6.发送手机验证码

#define CHECKPREPAIDVALIDATECODE @"900235" //绑定预付费卡 -- 7.验证手机验证码

#define RECHARGEDETAILCODE       @"900230" //充值详情查询

#define CASHDETAILCODE           @"900231" //提现详情查询

#define PREPAIDCARDDETAILCODE    @"900232" //预付费卡充值详情查询

#define PAYBALANCECODE           @"900268" //预付卡充值—使用虚拟账户校验支付密码完成充值

#define TRANSFERBALANCECHECKACCOUNT   @"900281" //转账到余额 ---- 校验转入方账户、转出方余额限额信息

#define TRANSFERBALANCEINVITE         @"900286" //转账到余额 ---- 发送注册邀请

#define TRANSFERBALANCECREATORDER     @"900283" //转账到余额 ---- 创建转账订单(余额付)

#define TRANSFERBALANCECHECKPAYPWD    @"900284" //转账到余额 ---- 校验支付密码(余额付)

#define TRANSFERRECENTRECODE          @"900285" //转账---- 查询最近转账记录

#define TRANSFERBANKCHECKCARDCODE     @"900219" //转账到银行卡---- 验证银行卡

#define TRANSFERBANKSEARCHREQFEECODE  @"900297" //转账到银行卡---- 查询转账手续费

#define TRANSFERBANKCREATORDERCODE    @"900298" //转账到银行卡---- 生成转账订单

#define TRANSFERBANKPAYPWDCODE        @"900299" //转账到银行卡---- 转账发起代付（检验支付密码）

#define TRANSFERBANKLIMITCODE         @"900300" //转账到银行卡---- 限额说明

#define GETPAYTYPECODE                @"900295" //查询支付方式---- 充值/扫一扫选择支付方式

#define AUTOPAYTYPECODE               @"900310" //默认支付方式----

#define CHANGEPAYTYPECODE             @"900311" //设置默认支付方式----

#define MOBILERECHARGEVERIFYCODE      @"900316" //手机号校验----

#define MOBILERECHARGEORDERCODE       @"900319" //手机号充值 下订单----

#define MOBILERECHARGEPAYCODE         @"900320"   //手机号充值  支付----


#define BILLLISTCODE                  @"900288" //3期修改----账单列表

#define BILLDETAILCODE                @"900287" //3期修改----账单详情

#define APPLYCOMPLAINTCODE            @"601035" //4期投诉----投诉申请

#define REVOKEORCONFIRMCODE           @"601038" //4期投诉----投诉

#define REVOKEORCONFIRMCODEONE           @"900381" //4期----撤销或者确认


#define TransBankToBalanceCreatOrder     @"900308" //4期 银行卡转账到余额 ---- 创建转账订单(银行卡付)

#define TransBankToBalanceCheckPayPwd    @"900309" //4期 银行卡转账到余额 ---- 校验支付密码(银行卡付)

#define CheckBankCardCanUseCODE          @"900312" //4期tx----校验银行卡是否是否可用

#define TXCreatOrderCODE                 @"900313" //4期tx----创建商品订单

#define TXCheckPwdCODE                   @"900314" //4期tx----校验支付密码完成支付

#define MyCollectionCODE                 @"900323" //4期----我要收款-两条数据

#define COLUMNCODE                      @"900330"  //.查询栏目

#define ADCODE                          @"900318"  //广告

#define BPUSHCODE                       @"900324"  //百度云推送绑定设备号

#define FEEDBACK                        @"910110"    // 意见反馈

#define FIGERSETTING                    @"910111"   // 支付支付上传g公钥


// 259   299 有问题

#endif
