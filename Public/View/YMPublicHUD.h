//
//  YMPublicHUD.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallBackBlock)(NSInteger btnIndex);

@interface YMPublicHUD : NSObject

/**
 单个按钮的AlertView

 @param title 标题
 @param message 提示信息
 @param cancelTitle 取消按钮标题
 @param handler 按钮点击回调
 */
+(void)showAlertView:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle handler:(void(^)())handler;
/**
 显示两个按钮的AlertView

 @param title 标题
 @param message 提示信息
 @param cancelTitle 取消按钮标题
 @param confirmTitle 确定按钮标题
 @param cancel 取消按钮取消回调
 @param confirm 确定按钮确定回调
 */
+(void)showAlertView:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle cancel:(void(^)())cancel confirm:(void(^)())confirm;
/**
 alert 弹框 UIAlertView和UIAlertController
 
 @param title 标题
 @param message 详细信息
 @param block 执行方法的回调
 @param cancelBtnTitle 取消按钮
 @param otherButtonTitles 其他按钮
 iOS8以前UIAlertView，
 以后UIAlertController
 */
+(void)showAlertTitle:(NSString *)title
              message:(NSString *)message
        callbackBlock:(CallBackBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
    otherButtonTitles:(NSString *)otherButtonTitles,...NS_REQUIRES_NIL_TERMINATION;

+(void)showActionSheetTitle:(NSString *)title message:(NSString *)message destructiveBtn:(NSString *)destructiveTitle cancelBtn:(NSString *)btnTitle destrusctive:(void(^)())destrusctive cancel:(void(^)())cancel;
@end
