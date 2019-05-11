//
//  ProfessionViewController.h
//  WSYMPay
//
//  Created by 赢联 on 16/9/19.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChangeProfessionBlock)(NSString *Professsion);

@interface ProfessionViewController : UIViewController
@property (nonatomic, copy) ChangeProfessionBlock changeBlock;
@end
