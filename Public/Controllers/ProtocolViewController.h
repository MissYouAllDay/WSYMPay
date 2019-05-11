//
//  ProtocolViewController.h
//  WSYMPay
//
//  Created by MaKuiying on 16/9/23.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^agreeBlock)();
@interface ProtocolViewController : UIViewController
@property (nonatomic, copy) agreeBlock block;
@end
