//
//  SetpasswordViewController.m
//  AliPayDemo
//
//  Created by pg on 15/7/15.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#import "SetpasswordViewController.h"
#import "AliPayViews.h"
#import "KeychainData.h"

@interface SetpasswordViewController ()

@end

@implementation SetpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手势设置";
    // Do any additional setup after loading the view.
    
    
    /************************* start **********************************/
    
    
    AliPayViews *alipay = [[AliPayViews alloc] initWithFrame:self.view.bounds];
    
    if ([self.string isEqualToString:@"验证密码"]) {
        alipay.gestureModel = ValidatePwdModel;
    } else if ([self.string isEqualToString:@"修改密码"]) {
        alipay.gestureModel = AlertPwdModel;
    } else if ([self.string isEqualToString:@"重置密码"]) {
        alipay.gestureModel = SetPwdModel;
    } else {
        alipay.gestureModel = NoneModel;
    }
    alipay.block = ^(NSString *pswString) {
        
        
        
        
        
//        NSString  * gesturepassword = [USER_DEFAULT setObject:@"1" forKey:@"gesturepassword"];
        
        

//        23442314231
        NSLog(@"设置密码成功-----你的密码为 = 【%@】\n\n", pswString);
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    
    [self.view addSubview:alipay];
    
    
    /************************* end **********************************/


    
    
    
}

- (void)back  {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
