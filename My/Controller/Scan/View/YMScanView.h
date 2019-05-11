//
//  YMScanView.h
//  二维码OC
//
//  Created by W-Duxin on 2017/4/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMScanView : UIView
@property (nonatomic, assign) CGFloat scanBoxWH;
-(void)stopAnimation;
-(void)startAnimation;
-(void)showMessage:(NSString *)str;
-(void)hideHUD;
@end
