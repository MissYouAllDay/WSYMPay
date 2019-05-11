//
//  YMCheckUpdateModel.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/26.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCheckUpdateModel.h"
#import "YMHTTPRequestTool.h"
#import "YMCheckUpdateVC.h"
#import "YMPublicHUD.h"
@implementation YMCheckUpdateModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ymqb_ver_ios" :@"data.ymqb_ver_ios",
             @"ymqbURL_ios"  :@"data.ymqbURL_ios",
             @"ymqbVerStatus":@"data.ymqbVerStatus",
             };
}

-(NSString *)oldVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return infoDic[@"CFBundleShortVersionString"];
}

-(BOOL)haveNewUpdate
{
    return ![self.ymqb_ver_ios isString:self.oldVersion] && ([self.ymqb_ver_ios compare:self.oldVersion options:NSNumericSearch] == NSOrderedDescending);
    
}

-(NSString *)lastShowTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastShowTime"];
}

-(BOOL)isShow
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat       = @"yyyy-MM-dd HH:mm:ss";
    NSDate*lastDate      = [fmt dateFromString:self.lastShowTime];
    if (!lastDate) return YES;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit  = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDate *currentDate  = [NSDate date];
    NSDateComponents *currentCmps  = [calendar components:unit fromDate:currentDate];
    NSDateComponents *cmps         = [calendar components:unit fromDate:lastDate];
    if (currentCmps.year == cmps.year) {
        if (cmps.month == currentCmps.month) return NO;
    }
    return YES;
}

+(void)checkUpdate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tranCode"]         = @"900277";
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:params success:^(id responseObject) {
        YMCheckUpdateModel *m = [YMCheckUpdateModel mj_objectWithKeyValues:responseObject];
        
        if (m.resCode == 1) {
            if (m.haveNewUpdate) {
                if (m.ymqbVerStatus == 1){
                    YMCheckUpdateVC *checkUpdateVC = [[YMCheckUpdateVC alloc]init];
                    checkUpdateVC.ymqbURL_ios      = m.ymqbURL_ios;
                    KEYWINDOW.rootViewController   = checkUpdateVC;
                } else if (m.ymqbVerStatus == 2) {
                    if (m.isShow) {
                        [YMPublicHUD showAlertView:@"提示" message:[NSString stringWithFormat:@"检测到有新版本:%@",m.ymqb_ver_ios] cancelTitle:@"取消" confirmTitle:@"立即更新"  cancel:^{
                        }  confirm:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:m.ymqbURL_ios]];
                        }];
                        
                        [m saveCurrentDate];
                    }
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSString *)saveCurrentDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat       = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr    = [fmt stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"lastShowTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return dateStr;
}

+(BOOL)isNewVersion
{
    NSString *currentVersion    = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *sandboxVersionKey = @"sandboxVersionKey";
    NSString *sandboxVersion    = [[NSUserDefaults standardUserDefaults] objectForKey:sandboxVersionKey];
    [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:sandboxVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return ![currentVersion isString:sandboxVersion];
}

@end
