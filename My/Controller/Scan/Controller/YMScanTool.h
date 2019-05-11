//
//  YMScanTool.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ScanFinish)(NSString *result,NSString *error);

@interface YMScanTool : NSObject

@property (nonatomic, copy) ScanFinish scanFinish;

-(void)beginScanningToView:(UIView *)view;
-(void)startRunning;
-(void)stopRunning;
-(void)turnTorchOn:(BOOL)on;
-(void)scanFormImage:(UIImage *)image withBlock:(ScanFinish)finish;
@end
