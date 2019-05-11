//
//  IDVerificationDatePicker.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "IDVerificationDatePicker.h"

#define DATEFORMAT  @"yyyy.MM.dd"

@interface IDVerificationDatePicker ()

@property (nonatomic, weak) UIToolbar *toolBar;

@property (nonatomic, weak) UIDatePicker *datePicker;

@property (nonatomic, weak) UIView *backgroundView;

@property (nonatomic, strong)UIBarButtonItem *item1;
@property (nonatomic, strong)UIBarButtonItem *item2;
@property (nonatomic, strong)UIBarButtonItem *item3;

@end

@implementation IDVerificationDatePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    self.backgroundColor = RGBAlphaColor(0, 0, 0, 0.7);
    
    UIToolbar *toolBar = [UIToolbar new];
    toolBar.barTintColor= [UIColor colorWithRed:250/255.0 green:221/255.0 blue:218/255.0 alpha:1];
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"长期有效" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [item1 setTintColor:[UIColor redColor]];
    self.item1 = item1;
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.item2 = item2;
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [item3 setTintColor:[UIColor redColor]];
    self.item3 = item3;
    toolBar.items = @[item1, item2,item3];
    [self addSubview:toolBar];
    self.toolBar = toolBar;
    
    UIDatePicker *datePicker   = [[UIDatePicker alloc]init];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.maximumDate = [NSDate date];
    [self addSubview:datePicker];
    self.datePicker  = datePicker;
    
//    UIView *backgroundView = [[UIView alloc]init];
//    backgroundView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.7);
//    [self addSubview:backgroundView];
//    self.backgroundView = backgroundView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(150);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.datePicker.mas_top);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.width.equalTo(self.mas_width);
//        make.top.equalTo(keyWindow.mas_top);
//        make.bottom.equalTo(self.mas_top);
//        make.centerX.equalTo(self.mas_centerX);
//        
//    }];
    
}

-(void)setMaximumDate:(NSString *)maximumDate
{
    _maximumDate = [maximumDate copy];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:DATEFORMAT];
    NSDate* inputDate = [inputFormatter dateFromString:_maximumDate];
    self.datePicker.maximumDate = inputDate;

}

-(void)setMinimumDate:(NSString *)minimumDate
{
    _minimumDate = minimumDate;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:DATEFORMAT];
    NSDate* inputDate = [inputFormatter dateFromString:_minimumDate];
    self.datePicker.minimumDate = inputDate;

}

-(void)cancelAction
{
    if (self.strBlock) {
     
        self.strBlock(@"长期");
    };
    
    if ([self.delegate respondsToSelector:@selector(idVerificationDatePickerDidEndEditing:)]) {
        
        [self.delegate idVerificationDatePickerDidEndEditing:self];
    }
}

-(void)doneAction
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:DATEFORMAT];
    NSString *strT = [inputFormatter stringFromDate:self.datePicker.date];
    
    if (self.strBlock) {
        
        self.strBlock(strT);
    };
    
    if ([self.delegate respondsToSelector:@selector(idVerificationDatePickerDidEndEditing:)]) {
        
        [self.delegate idVerificationDatePickerDidEndEditing:self];
    }
}

-(void)setLongTimeButtonHiden:(BOOL)longTimeButtonHiden
{
    _longTimeButtonHiden = longTimeButtonHiden;
    
    if (_longTimeButtonHiden) {
       self.toolBar.items = @[self.item2,self.item3];
    } else {
    
        self.toolBar.items = @[self.item1,self.item2,self.item3];
    }

}


@end
