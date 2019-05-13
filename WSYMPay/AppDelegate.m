//
//  AppDelegate.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "AppDelegate.h"
#import "YMUserInfoTool.h"
#import "KeyboardManager.h"
#import "YMLocationTool.h"
#import "Reachability.h"
#import "YMCollectionVC.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "YMCheckUpdateModel.h"
#import "YMAudioPlay.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "YMPushModel.h"
#import "YMNavigationController.h"

#import "BPush.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define BPushApikey  @"Fkj9oAq4m54bWgestLR9SIfj"



#import "AliPayViews.h"

@interface AppDelegate ()<CXFunctionDelegate>
@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic)NSInteger bagTaskId;
@property (nonatomic, strong) YMCollectionVC * vc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    
    
    [self setupRootViewController]; //加载根控制器
    [self setupGlobalData];//加载全局数据
    [self setupGlobalKeyboard];//设置keyboard管理
    [self setuprequestLocation];//开始请求定位
    [self setupMonitoringNetworkStatus];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iniAliPayViewstview) name:@"iniAliPayViewstview" object:nil];

//    [self setBPushData:application and:launchOptions];
    return YES;
}

-(void)setupCheckUpdate
{
    [YMCheckUpdateModel checkUpdate];
}

-(void)setuprequestLocation
{
    [[YMLocationTool sharedInstance]startLocationWithCurrentLocation:nil locationError:nil];
}

-(void)setupGlobalKeyboard
{
    //    启用键盘
    IQKeyboardManager* manager                  = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside          = YES;
    manager.enable                              = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar                   = NO;
}
//加载全局数据
-(void)setupGlobalData
{
    [[YMUserInfoTool shareInstance] loadUserInfoFromSanbox];    
}

-(void)setupRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootViewController = [[MyTabBarController alloc]init];
    self.window.rootViewController = _rootViewController;
    [self.window makeKeyAndVisible];
}

//监听网路状态
-(void)setupMonitoringNetworkStatus
{
    //网络缓慢时加载状态
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    //网络监听
    [WSYMNSNotification addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.hostReach startNotifier];
}

-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [currReach currentReachabilityStatus];
    if(status == NotReachable){
        [YMUserInfoTool shareInstance].networkStatus = NO;
    }
    if (status == ReachableViaWiFi ||status == ReachableViaWWAN) {
        [YMUserInfoTool shareInstance].networkStatus = YES;
        //有网络时检查更新
        [self setupCheckUpdate];
    }
    
}
-(void)setBPushData:(UIApplication *)application and:(NSDictionary *)launchOptions
{
    // iOS10 下需要使用新的 API
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [application registerForRemoteNotifications];
                                  }
                              }];
#endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
#warning 上线 AppStore 时需要修改BPushMode为BPushModeProduction 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    //BPushModeDevelopment   BPushModeProduction
    [BPush registerChannel:launchOptions apiKey:BPushApikey pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    [BPush disableLbs];
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 打印到日志 textView 中
    
    NSLog(@"********** iOS7.0之后 background **********%ld",(long)application.applicationState);
    YMLog(@"推送信息:\n%@",userInfo);
    //杀死状态下，直接跳转到跳转页面。application.applicationState == UIApplicationStateInactive  && !isBackGroundActivateApplication
    
    
    if (application.applicationState == UIApplicationStateActive  )
    {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        YMPushModel * model = [YMPushModel mj_objectWithKeyValues:userInfo];
        [YMAudioPlay playAudio:model.alert];
        
        // 根视图是nav 用push 方式跳转
        for (UIViewController *controller in _rootViewController.selectedViewController.childViewControllers ) {
            if ([controller isKindOfClass:[YMCollectionVC class]]) {
                YMCollectionVC *A =(YMCollectionVC *)controller;
                [A loadData];
                [_rootViewController.selectedViewController popToViewController:A animated:YES];
                return;
            }
        }
    
        YMCollectionVC *A =[[YMCollectionVC alloc] init];
        
        [_rootViewController.selectedViewController pushViewController:A animated:YES];
        
        
        NSLog(@"applacation is unactive ===== %@",userInfo);
    }else  if ( application.applicationState == UIApplicationStateInactive  )
    {
       
        // 根视图是nav 用push 方式跳转
        
        for (UIViewController *controller in _rootViewController.selectedViewController.childViewControllers ) {
            if ([controller isKindOfClass:[YMCollectionVC class]]) {
                YMCollectionVC *A =(YMCollectionVC *)controller;
                [A loadData];
                [_rootViewController.selectedViewController popToViewController:A animated:YES];
             
                return;
            }
        }
        
        YMCollectionVC *A =[[YMCollectionVC alloc] init];
        
        [_rootViewController.selectedViewController pushViewController:A animated:YES];
    }
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"backgroud : %@",userInfo);
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
       
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        // 网络错误
        if (error) {
            return ;
        }
        if (result) {
            // 确认绑定成功
            if ([result[@"error_code"]intValue]!=0) {
                return;
            }
        }
    }];
    
    
    
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    //开启后台任务
    
//    [self startBackgroudTask];

}
#pragma mark - BackgroudTask

- (void)startBackgroudTask {
    
    AVAudioSession *session=[AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    [session setActive:YES error:nil];
    
    if (_bagTaskId && _bagTaskId!=UIBackgroundTaskInvalid) {
        
        [[UIApplication sharedApplication] endBackgroundTask:_bagTaskId];
        
    }
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:1.0f
             
                                             target:self
             
                                           selector:@selector(timers) userInfo:nil
             
                                            repeats:YES];
    
    _bagTaskId = UIBackgroundTaskInvalid;
    
    _bagTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
}

- (void)stopBackgroudTask {
    
    if (_bagTaskId && _bagTaskId!=UIBackgroundTaskInvalid) {
        
        [[UIApplication sharedApplication] endBackgroundTask:_bagTaskId];
        
    }
    
    if (_timer) {
        
        [_timer invalidate];
        
    }
    
}

static int count = 0;

- (void)timers {
    
    count ++;
    
    //三分钟
    
    if (count == 3*60) {
        
        count = 0;
        
        //系统语音播报
        
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"云收银"];
        
        utterance.volume = 0.0;
        
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        
        [synth speakUtterance:utterance];
        
    }
    
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //判断是否开启那个模式
    NSString* index  = [USER_DEFAULT objectForKey:@"indexPathrow"] ;
    if ([index isEqualToString:@"1"]) {
        NSString * rightswitchOne = [USER_DEFAULT objectForKey:@"rightswitchTwo"];
        
        if ([rightswitchOne isEqualToString:@"1"]) {
            //验证手势密码
            [self iniAliPayViewstview];
        }
        NSString * rightswitchTwo = [USER_DEFAULT objectForKey:@"rightswitchOne"];
        if ([rightswitchTwo isEqualToString:@"1"]) {
            //验证手势密码
            [self havaFingerPay];
        }
    }
    
    //关闭后台任务
    
//    [self stopBackgroudTask];
}


- (void)havaFingerPay {
    
    CXFunctionTool *tool = [CXFunctionTool shareFunctionTool];
    tool.delegate = self;
    [tool fingerReg];
}

/** 指纹支付代理*/
- (void)functionWithFinger:(NSInteger)error {
    
    if (error == 0) {
        [self havaFingerPay] ;
    }else {
        [MBProgressHUD showText:@"解锁成功"];
    }
}

-(void)iniAliPayViewstview
{
    
    
    AliPayViews *alipay = [[AliPayViews alloc] initWithFrame:self.window.bounds];
    
    alipay.gestureModel = ValidatePwdModel;

    alipay.block = ^(NSString *pswString) {
        
        alipay.hidden = YES;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alipay];

    
    


}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"系统退出程序");
//    UIApplication*   app = [UIApplication sharedApplication];
//    __block    UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (bgTask != UIBackgroundTaskInvalid)
//            {
//                bgTask = UIBackgroundTaskInvalid;
//            }
//        });
//    });
    

}

@end
