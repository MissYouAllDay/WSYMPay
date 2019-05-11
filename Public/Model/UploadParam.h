//
//  UploadParam.h
//  WSYMPay
//
//  Created by W-Duxin on 16/10/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadParam : NSObject
/**
 *上传的参数
 */
@property (nonatomic, strong) NSData   *data;
/**
 *  服务器对应的参数名称
 */
@property (nonatomic, copy)   NSString *name;
/**
 *  文件的名称(上传到服务器后，服务器保存的文件名)
 */
@property (nonatomic, copy)   NSString *filename;
/**
 *  文件的MIME类型(image/png,image/jpg等)
 */
@property (nonatomic, copy)   NSString *mimeType;

@end
