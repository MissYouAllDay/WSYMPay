//
//  MyTabBarController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "MyTabBarController.h"
#import "YMNavigationController.h"
@interface MyTabBarController ()<CXFunctionDelegate>

/** <#mark#> */
@property (nonatomic, assign) NSInteger didSel;
@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabBar];
    [self setColor];
    self.didSel = 0;
}

- (void)createTabBar
{
//    NSArray *selectImageArray   = @[@"home",@"Finance",@"find",@"my"];
//    NSArray *unSelectImageArray = @[@"home_s",@"Finance_s",@"find_s",@"my_s"];
//    NSArray * nameArray         = @[@"首页",@"理财",@"发现",@"我的"];
//
//    _homeViewController         = [[HomeViewController alloc]init];
//    _financialViewController    = [[FinancialViewController alloc]init];
//    _findViewController         = [[FindViewController alloc]init];
//    _myViewController           = [[MyViewController alloc]init];
    NSArray *selectImageArray   = @[@"home",@"find",@"Finance",@"my"];
        NSArray *unSelectImageArray = @[@"home_s",@"find_s",@"Finance_s",@"my_s"];
        NSArray * nameArray         = @[@"首页",@"发现",@"银行卡", @"我的"];
        _homeViewController         = [[HomeViewController alloc]init];
//        _financialViewController    = [[FinancialViewController alloc]init];
    _mybankcardController=           [[YMMyBankCardController alloc]init];
     _mybankcardController.isFirst=YES;
        _findViewController         = [[FindViewController alloc]init];
        _myViewController           = [[MyViewController alloc]init];

   
    [self addChildViewController:_homeViewController title:nameArray[0] image:unSelectImageArray[0] selectImage:selectImageArray[0]];
//    [self addChildViewController:_financialViewController title:nameArray[1] image:unSelectImageArray[1] selectImage:selectImageArray[1]];
    [self addChildViewController:_findViewController title:nameArray[1] image:unSelectImageArray[1] selectImage:selectImageArray[1]];
    [self addChildViewController:_mybankcardController title:nameArray[2] image:unSelectImageArray[2] selectImage:selectImageArray[2]];
    [self addChildViewController:_myViewController title:nameArray[3] image:unSelectImageArray[3] selectImage:selectImageArray[3]];
     self.selectedIndex = 0;
}

-(void)addChildViewController:(UIViewController*)childVC title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    
    childVC.navigationItem.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.title = title;
    YMNavigationController *nVC = [[YMNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:nVC];

}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];

    if (index == 3) {
        //判断是否开启那个模式
        NSString* index  = [USER_DEFAULT objectForKey:@"indexPathrow"] ;
        if ([index isEqualToString:@"2"]) {
            NSString * rightswitchOne = [USER_DEFAULT objectForKey:@"rightswitchTwo"];
            
            if ([rightswitchOne isEqualToString:@"1"]) {
                //验证手势密码
                [[NSNotificationCenter defaultCenter] postNotificationName:@"iniAliPayViewstview" object:nil];

            }
            NSString * rightswitchTwo = [USER_DEFAULT objectForKey:@"rightswitchOne"];
            if ([rightswitchTwo isEqualToString:@"1"]) {
                //验证手势密码
                [self havaFingerPay];
            }
        }
        self.selectedIndex = self.didSel;
    }else {
        self.didSel = index;
    }
    
}

- (void)havaFingerPay {
    
    CXFunctionTool *tool = [CXFunctionTool shareFunctionTool];
    tool.delegate = self;
    [tool fingerReg];
}

/** 指纹支付代理*/
- (void)functionWithFinger:(NSInteger)error {
    
    if (error == 0) {
        
        self.selectedIndex = self.didSel;
    }else {
        [MBProgressHUD showText:@"解锁成功"];
    }
}

- (void)setColor{
    
    //设置TabBar title颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[VUtilsTool fontWithString:11.0]],NSForegroundColorAttributeName:RGBColor(202, 202, 202)}   forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[VUtilsTool fontWithString:11.0]],NSForegroundColorAttributeName:UIColorFromHex(0xe2483c)} forState:UIControlStateSelected];
}


@end
