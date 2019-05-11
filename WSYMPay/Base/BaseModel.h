//
//  BaseModel.h
//  WSYMPay
//
//  Created by MaKuiying on 16/10/24.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject


-(id)initWithDictionary:(NSDictionary*)dic;
-(void)setAttributes:(NSDictionary*)dic;

@property (nonatomic,copy) NSDictionary*map;

- (NSString *)getSourceWith:(NSString *)sourceString;




@end
