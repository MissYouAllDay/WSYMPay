//
//  YMScanPayTool.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YMScanModel;
typedef void(^PayResultBlock)(BOOL status,NSString *error);
@interface YMScanPayTool : NSObject
@property (nonatomic, copy) PayResultBlock payResultBlock;
@property (nonatomic, strong) YMScanModel *dataModel;

-(void)showCashierDeskView;
-(void)setNavigationVC:(UINavigationController *)navVC;
@end
