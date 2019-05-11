//
//  YMBillDetailResultModel.m
//  WSYMPay
//
//  Created by pzj on 2017/3/27.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBillDetailResultModel.h"

#import "YMReChargeDetailsModel.h"
#import "YMCashDetailsModel.h"
#import "YMPrepaidCardDetailsModel.h"

#import "YMBillDetailKeyValueModel.h"

@implementation YMBillDetailResultModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"keyValueArray":@"YMReChargeDetailsModel",
             @"cashDetailkeyValueArray":@"YMCashDetailsModel",
             @"prepaidDetailkeyValueArray":@"YMPrepaidCardDetailsModel"};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

/**
 充值详情查询
 
 @param model 充值详情查询model
 @return 最终想要的model
 */
+ (YMBillDetailResultModel *)getReChangeDetailsModelWithModel:(YMReChargeDetailsModel *)model
{
    YMBillDetailResultModel *billDetailDescModel = [[YMBillDetailResultModel alloc] init];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];

    if (![[model getPrdNameStr]isEmptyStr]) {//交易类型名称
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易名称";
        keyValueModel.valueStr = [model getPrdNameStr];
        keyValueModel.sortNum = 1;
        billDetailDescModel.headTitle = [model getHeadTitleStr];
        [resultArray addObject:keyValueModel];
    }
    
    if (![[model getOrderDateStr]isEmptyStr]) {//交易时间
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易时间";
        keyValueModel.valueStr = [model getOrderDateStr];
        keyValueModel.sortNum = 2;
        [resultArray addObject:keyValueModel];
    }

    if (![[model getOrdStatusStr]isEmptyStr]) {//交易状态
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易状态";
        keyValueModel.valueStr = [model getOrdStatusStr];
        keyValueModel.sortNum = 3;
        [resultArray addObject:keyValueModel];
    }

    if (![[model getPayordnoStr]isEmptyStr]) {//交易单号
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易单号";
        keyValueModel.valueStr = [model getPayordnoStr];
        keyValueModel.sortNum = 4;
        [resultArray addObject:keyValueModel];
    }

    if (![[model getPaytypeStr]isEmptyStr]) {//交易方式
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易方式";
        //判断有无银行卡名跟卡号，有则显示名称与卡号，否则显示交易方式对应的值
        //逻辑判断在YMReChargeDetailsModel的getPayTypeValueStr这个方法中处理
        keyValueModel.valueStr = [model getPayTypeValueStr];
        keyValueModel.sortNum = 5;
        [resultArray addObject:keyValueModel];
    }

    if (![[model getTxAmtStr]isEmptyStr]) {//金额
        billDetailDescModel.txAmt = [model getTxAmtStr];
    }
    billDetailDescModel.keyValueArray = [self getSortDataArray:resultArray];
    return billDetailDescModel;
}


/**
 提现详情查询
 
 @param model 体现详情model
 @return 最终想要的model
 */
+ (YMBillDetailResultModel *)getCashDetailsModelWithModel:(YMCashDetailsModel *)model
{
    YMBillDetailResultModel *resultModel = [[YMBillDetailResultModel alloc] init];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    if (![[model getPrdNameStr] isEmptyStr]) {//交易类型名称
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易名称";
        keyValueModel.valueStr = [model getPrdNameStr];
        keyValueModel.sortNum = 1;
        resultModel.headTitle = [model getHeadTitleStr];
        [resultArray addObject:keyValueModel];
    }
    if (![[model getActdatStr]isEmptyStr]) {//申请时间 ；提现失败时是：交易时间
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = [model getActdatKeyStr];
        keyValueModel.valueStr = [model getActdatStr];
        keyValueModel.sortNum = 2;
        [resultArray addObject:keyValueModel];
    }
    if ([model isShowSucdatKey]) {//到账时间
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"到账时间";
        keyValueModel.valueStr = [model getSucdatStr];
        keyValueModel.sortNum = 3;
        [resultArray addObject:keyValueModel];
    }
    if (![[model getOrdStatusStr]isEmptyStr]) {//交易状态
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易状态";
        keyValueModel.valueStr = [model getOrdStatusStr];
        keyValueModel.sortNum = 5;
        [resultArray addObject:keyValueModel];
    }
    
    if (![[model getCasordNoStr]isEmptyStr]) {//交易单号
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易单号";
        keyValueModel.valueStr = [model getCasordNoStr];
        keyValueModel.sortNum = 6;
        [resultArray addObject:keyValueModel];
    }

    if ([model isShowBankMsgKey]) {//转出至（提现失败时，不显示这一行，
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
//        keyValueModel.keyStr = @"转出至　 ";
        keyValueModel.keyStr = @"转出至　";
        keyValueModel.valueStr = [model getBankMsgStr];
        keyValueModel.sortNum = 7;
        [resultArray addObject:keyValueModel];
    }
    
    if (![[model getTxAmtStr]isEmptyStr]) {//金额
        resultModel.txAmt = [model getTxAmtStr];
    }
    resultModel.cashDetailkeyValueArray = [self getSortDataArray:resultArray];
    return resultModel;
}

/**
 预付费卡充值查询详情
 
 @param model 预付费卡充值查询详情model
 @return 最终想要的model
 */
+ (YMBillDetailResultModel *)getPrepaidCardDetailsModelWithModel:(YMPrepaidCardDetailsModel *)model
{
    YMBillDetailResultModel *resultModel = [[YMBillDetailResultModel alloc] init]
    ;
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];

    if (![[model getPrdNameStr] isEmptyStr]) {//交易名称
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易名称";
        keyValueModel.valueStr = [model getPrdNameStr];
        keyValueModel.sortNum = 1;
        resultModel.headTitle = [model getHeadTitleStr];
        [resultArray addObject:keyValueModel];
    }
    
    if (![[model getOrderDateKeyStr]isEmptyStr]) {//申请时间、交易时间
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = [model getOrderDateKeyStr];
        keyValueModel.valueStr = [model getOrderDateStr];
        keyValueModel.sortNum = 2;
        [resultArray addObject:keyValueModel];
    }
    
    if ([model isShowEndTimeKey]) {//受理时间
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"受理时间";
        keyValueModel.valueStr = [model getEndTimeStr];
        keyValueModel.sortNum = 3;
        [resultArray addObject:keyValueModel];
    }

    if (![[model getOrdStatusStr]isEmptyStr]) {//交易状态
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易状态";
        keyValueModel.valueStr = [model getOrdStatusStr];
        keyValueModel.sortNum = 4;
        [resultArray addObject:keyValueModel];
    }
    
    if (![[model getPrdOrdNoStr]isEmptyStr]) {//交易单号
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"交易单号";
        keyValueModel.valueStr = [model getPrdOrdNoStr];
        keyValueModel.sortNum = 5;
        [resultArray addObject:keyValueModel];
    }

    if ([model isShowPrepaidCard]) {//不是退款时，显示预付卡这一行，否则不显示
        YMBillDetailKeyValueModel *keyValueModel = [[YMBillDetailKeyValueModel alloc] init];
        keyValueModel.keyStr = @"预付卡号";
        keyValueModel.valueStr = [model getPrepaidCardMsgStr];
        keyValueModel.sortNum = 6;
        [resultArray addObject:keyValueModel];
    }
    
    if (![[model getTxAmtStr] isEmptyStr]) {
        resultModel.txAmt = [model getTxAmtStr];
    }
    
    resultModel.prepaidDetailkeyValueArray = [self getSortDataArray:resultArray];
    
    return resultModel;
}

#pragma mark - 排序
/**
 排序
 
 @param array 未排序的array
 @return 排序完的array
 */
+ (NSMutableArray *)getSortDataArray:(NSMutableArray *)array
{
    //按sortNum大小排序
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        YMBillDetailKeyValueModel *model1 = obj1;
        YMBillDetailKeyValueModel *model2 = obj2;
        if (model1.sortNum > model2.sortNum)
        {
            return NSOrderedDescending;
        }
        if (model2.sortNum < model1.sortNum)
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:sortedArray];
    return arr;
}

- (NSString *)getHeadTitleStr
{
    NSString *str = @"";
    if (![_headTitle isEmptyStr]) {
        str = _headTitle;
    }
    return str;
}
- (NSString *)getTxAmtStr
{
    NSString *str = @"";
    if (![_txAmt isEmptyStr]) {
        str = _txAmt;
    }
    return str;
}
- (NSMutableArray *)getDataArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (_keyValueArray && _keyValueArray.count>0) {
        array = _keyValueArray;
    }
    return array;
}
- (NSMutableArray *)getCashDataArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (_cashDetailkeyValueArray && _cashDetailkeyValueArray.count>0) {
        array = _cashDetailkeyValueArray;
    }
    return array;
}
- (NSMutableArray *)getPrepaidDataArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (_prepaidDetailkeyValueArray && _prepaidDetailkeyValueArray.count>0) {
        array = _prepaidDetailkeyValueArray;
    }
    return array;
}

- (NSInteger )getArrayCount
{
    NSInteger count = [self getDataArray].count;
    return count;
}
    
@end
