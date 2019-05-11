//
//  ProvinceModelTool.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/21.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "ProvinceModelTool.h"
#import "ProvinceModel.h"

@implementation ProvinceModelTool

static NSArray *_provinces;
+(NSArray *)getProvinces
{
//    if (!_provinces) {
    
        NSLog(@"test");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _provinces= [ProvinceModel mj_objectArrayWithFilename:@"provinces.plist"];
//
        });
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//        });
    
//    }

    return _provinces;

}

static NSDictionary *_cityesDict;
+(NSDictionary *)getCityes
{

    if (!_cityesDict) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *path = [[NSBundle mainBundle]pathForResource:@"address" ofType:@"plist"];
            _cityesDict =[[NSDictionary alloc]initWithContentsOfFile:path];
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
    }
    
    return _cityesDict;
}

@end
