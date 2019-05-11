//
//  E_MailViewController.h
//  WSYMPay
//
//  Created by W-Duxin on 16/9/22.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMChangeGetVCodeController.h"

typedef void (^ChangeE_MailBlcok)(NSString *e_mail);

@interface E_MailViewController : YMChangeGetVCodeController
@property(nonatomic, copy)ChangeE_MailBlcok changeBlock;
@end
