//
//  DatePickerView.h
//  YLPersonal
//
//  Created by MaKuiying on 16/4/21.
//  Copyright © 2016年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView

typedef void(^StrYMBlock)(NSString *strTM);

@property (strong, nonatomic) UIPickerView *pickerView;

@property(nonatomic,copy)StrYMBlock strBlock;


-(instancetype)initWithFrame:(CGRect)frame;

-(void)strYearMonth:(StrYMBlock)str;



@end
