//
//  AFHTTPClient.h
//  AFNetworking3.0
//
//  Created by chan on 16/1/30.
//  Copyright © 2016年 CK_chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UploadParam;
//请求方式
typedef NS_ENUM(NSUInteger, RequestMethod) {
    POST = 0,
    GET,
    PUT,
    PATCH,
    DELETE
};

typedef NS_ENUM (NSInteger, AFNetworkErrorType) {
    AFNetworkErrorType_Cancelled = NSURLErrorCancelled, //-999操作取消
    AFNetworkErrorType_TimedOut  = NSURLErrorTimedOut,  //-1001 请求超时
    AFNetworkErrorType_UnURL     = NSURLErrorUnsupportedURL, //-1002 不支持的url
    AFNetworkErrorType_NoNetwork = NSURLErrorNotConnectedToInternet, //-1009 断网
    AFNetworkErrorType_404Failed = NSURLErrorBadServerResponse, //-1011 404错误
    AFNetworkErrorType_ConnectToHost = NSURLErrorCannotConnectToHost,
    AFNetworkErrorType_3840Failed = 3840, //请求或返回不是纯Json格式
};


@interface YMHTTPRequestTool : NSObject

//声明单例方法
+ (instancetype)shareInstance;

/**
 *  上传图片
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数格式为form
 *  @param uploadParam 上传图片的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
- (void)uploadWithURLString:(NSString *)URLString
             formParameters:(NSArray <UploadParam *> *)formParameters
                uploadParam:(NSArray <UploadParam *> *)uploadParams
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionTask *)POST:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
-(void)cancelLastRequest;
@end
