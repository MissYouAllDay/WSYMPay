//
//  AFHTTPClient.m
//  AFNetworking3.0
//
//  Created by chan on 16/1/30.
//  Copyright © 2016年 CK_chan. All rights reserved.
//

#import "YMHTTPRequestTool.h"
#import "UploadParam.h"
#import "NSDictionary+Extension.h"
#import "RSAEncryptor.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "YMUserInfoTool.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#define WEAKSELF  typeof(self) __weak weakSelf = self;
@interface YMHTTPRequestTool ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation YMHTTPRequestTool

//请求实例的懒加载
-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 30.0f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"multipart/form-data",nil];
    }
    return _manager;
}

#pragma mark - 实现声明单例方法 GCD
+ (instancetype)shareInstance
{
    static YMHTTPRequestTool *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[YMHTTPRequestTool alloc] init];
    });
    return singleton;
}


-(void)uploadWithURLString:(NSString *)URLString formParameters:(NSArray<UploadParam *> *)formParameters uploadParam:(NSArray<UploadParam *> *)uploadParams success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    WEAKSELF
    [self.manager POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (formParameters.count) {
            
            for (UploadParam *uploadParam in formParameters) {
                
                [formData appendPartWithFormData:uploadParam.data name:uploadParam.name];
            }
        }
        
        if (uploadParams.count) {
            
            for (UploadParam *uploadPatam in uploadParams) {
                
                [formData appendPartWithFileData:uploadPatam.data name:uploadPatam.name fileName:uploadPatam.filename mimeType:uploadPatam.mimeType];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf requestFailed:error];
        if (failure) {
            failure(error);
        }
    }];

}

#pragma mark - 请求失败统一回调方法
- (void)requestFailed:(NSError *)error
{
    [MBProgressHUD hideHUD];
  switch (error.code) {
      case AFNetworkErrorType_NoNetwork:
      case AFNetworkErrorType_ConnectToHost:
            NSLog(@"网络连接失败，请检查网络");
          [MBProgressHUD showText:@"网络连接失败，请检查网络"];
            break;
        case AFNetworkErrorType_TimedOut :
            NSLog(@"访问服务器超时，请检查网络。");
          [MBProgressHUD showText:@"访问服务器超时，请检查网络"];
            break;
        case AFNetworkErrorType_3840Failed :
            NSLog(@"服务器报错了，请稍后再访问。");
          [MBProgressHUD showText:@"服务器报错了，请稍后再访问"];
            break;
        case AFNetworkErrorType_Cancelled:
          YMLog(@"操作取消");
          break;
        default:
          YMLog(@"%ld",(long)error.code);
          [MBProgressHUD showText:@"操作失败，请稍候再试"];
            break;
    }
}

-(NSDictionary *)dictionaryWithEncryptionDictionary:(NSDictionary *)dict
{    
    NSString *privateKeyPath = [[NSBundle mainBundle]pathForResource:@"private_key.p12" ofType:nil];
    NSString *jsonString      = [RSAEncryptor decryptString:dict[@"data"] privateKeyWithContentsOfFile:privateKeyPath password:@"wdx7883629"];
    if (!jsonString.length || [jsonString isEqualToString:@"null"] || [jsonString isEqualToString:@"<null>"]) return dict;
        
    NSDictionary *data           = [NSDictionary dictionaryWithJsonString:jsonString];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        
     for (NSString *key in dict) {
            
        if ([key isEqualToString:@"data"]) {
                
             [newDict setObject:data forKey:key];
                
            } else {
                
             [newDict setObject:dict[key] forKey:key];
                
            }
        }
    
    return newDict;

}

-(NSURLSessionTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
        NSString * jsonString = [self createJsonStringFromID:parameters];
    NSLog(@"URLString:%@,parameters:%@",URLString,jsonString);
        //使用RSA加密
        NSString *publicKeyPath = [[NSBundle mainBundle]pathForResource:@"public_key.der" ofType:nil];
        jsonString              = [RSAEncryptor encryptString:jsonString publicKeyWithContentsOfFile:publicKeyPath];
        parameters              = @{@"params":jsonString};
        WEAKSELF
        return [self.manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            YMLog(@"%@",responseObject);
            NSString *m = responseObject[@"resCode"];
            NSLog(@"resCode = %@",m);
            YMLog(@"resMsg  = %@",responseObject[@"resMsg"]);
            NSString *resCode = responseObject[@"resCode"];
            
            if ([resCode isString:@"40"] || [resCode isString:@"41"] || [resCode isString:@"2"]||[resCode isString:@"4"]) {
                if (failure) {
                    NSError * er = [NSError errorWithDomain:responseObject[@"resMsg"] code:[resCode integerValue]  userInfo:nil];
                        failure(er);
                    }
                
                if ([resCode isString:@"2"]) {
                    [MBProgressHUD showText:MSG14];
                } else if ([resCode isString:@"4"]) {
                    [MBProgressHUD showText:responseObject[@"resMsg"]];
                    return ;
                } else {
                    [MBProgressHUD showText:MSG12];
                }
                
                MyTabBarController * tab = (MyTabBarController *)KEYWINDOW.rootViewController;
                [tab.selectedViewController popToRootViewControllerAnimated:YES];
                [WSYMNSNotification postNotificationName:WSYMUserLogoutNotification object:nil];
                [[YMUserInfoTool shareInstance] removeUserInfoFromSanbox];
                
            } else {
                
                responseObject = [self dictionaryWithEncryptionDictionary:responseObject];
                [weakSelf saveGlobalRandomCode:responseObject];
                
                if (success) {
                    success(responseObject);
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                [weakSelf requestFailed:error];
            }
    }];
}

//将参数转换成json字符串
-(NSString *)createJsonStringFromID:(id)parameters
{
    NSString * jsonString = nil;
    if ([parameters isKindOfClass:[NSDictionary class]])
    {
        NSError *errorJ;
        NSData * diccData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&errorJ];
        if (!diccData) {
            YMLog(@"%@",errorJ);
        } else {
            jsonString = [[NSString alloc] initWithData:diccData encoding:NSUTF8StringEncoding];
        }
        
    }else if ([parameters isKindOfClass:[NSObject class]]) {
        
        jsonString = [parameters mj_JSONString];
    }
    
    return jsonString;
}

-(void)cancelLastRequest
{
    NSURLSessionTask *task = [self.manager.tasks lastObject];
    [task cancel];
}

-(void)saveGlobalRandomCode:(id)responseObject
{
    NSDictionary *dic = responseObject[@"data"];
    if (![dic.allKeys containsObject:@"randomCode"]) return;
    [YMUserInfoTool shareInstance].randomCode = dic[@"randomCode"];
}


@end
