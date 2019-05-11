//
//  YMRevokeOrConfirmModel.h
//  WSYMPay
//
//  Created by pzj on 2017/7/25.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMRevokeOrConfirmDataModel;

@interface YMRevokeOrConfirmModel : NSObject

//返回状态码
@property (nonatomic, copy) NSString *resCode;
//返回信息
@property (nonatomic, copy) NSString *resMsg;
//数据
@property (nonatomic, strong) YMRevokeOrConfirmDataModel *data;

- (NSString *)getResCodeStr;
- (NSString *)getResMsgStr;
- (YMRevokeOrConfirmDataModel *)getDataModel;


@end
