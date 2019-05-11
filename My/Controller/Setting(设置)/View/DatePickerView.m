//
//  DatePickerView.m
//  YLPersonal
//
//  Created by MaKuiying on 16/4/21.
//  Copyright © 2016年 TY. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSMutableArray *_yearArray;
    NSMutableArray *_mothArray;
    UIToolbar* toolBar;
    
    NSString* yearStr;
    NSString* monthStr;
    
    UIView *_view;
    
    UIView*_maskView;
}

@end


@implementation DatePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
//        遮罩
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT)];
        _maskView.alpha = 0.3;
        _maskView.backgroundColor = [UIColor blackColor];
        [self addSubview:_maskView];
        
       
        [self initData];
        [self initView];
        [self initToolBar];
      
     
    }
    return self;
    
}

-(void)initToolBar{
    
    toolBar = [UIToolbar new];
    toolBar.barTintColor= [UIColor colorWithRed:250/255.0 green:221/255.0 blue:218/255.0 alpha:1];
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [item1 setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [item3 setTintColor:[UIColor redColor]];
    toolBar.items = @[item1, item2,item3];
    [self addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREENWIDTH);
        make.height.offset(45);
        make.left.offset(0);
        make.bottom.equalTo(_pickerView.mas_top).offset(0);
    }];
    
  
}

-(void)cancelAction{
    
    self.hidden = YES;
}
-(void)doneAction{
    
    NSString* ab=  [yearStr substringWithRange:NSMakeRange(2, 2)];
    NSString* endStr = [NSString stringWithFormat:@"%@/%@",monthStr,ab];
    _strBlock(endStr);
    
    [self removeFromSuperview];
    
}

-(void)strYearMonth:(StrYMBlock)str{
    _strBlock = str;
}
//得到年月日这些数组
-(void)initData{
    
    NSArray *array = [self getSystemTime];
    yearStr = array[0];
    monthStr = array[1];
    
    _yearArray = [NSMutableArray array];
    
    for (int i = [yearStr intValue]; i < [yearStr intValue] + 21; i++) {
        NSString *year = [NSString stringWithFormat:@"%.2d",i];
        
        
        [_yearArray addObject:year];
    }
    _mothArray = [NSMutableArray array];
    for (int i = 1; i<13; i++) {
        NSString *moth = [NSString stringWithFormat:@"%.2d",i];
        [_mothArray addObject:moth];
    }
    
}
//初始化pickerview
-(void)initView{
    
    _pickerView = [UIPickerView new];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SCREENWIDTH);
        make.left.offset(0);
        make.bottom.equalTo(self.mas_bottom);
        if (System_Version  >= 9.0) {
            make.height.offset(SCREENHEIGHT*0.30);
        }else{
            make.height.offset(180);
        }
    }];

    
    
    NSArray *array = [self getSystemTime];
    
    NSString  *yearRow = array[0] ;
    
    int year = [yearRow intValue];
    
    NSString *mothStr = array[1];
    
    int moth = [mothStr intValue];
    
    //  设置默认选中日期,即现在的日期
    [self.pickerView selectRow:year inComponent:1 animated:YES];
    [self.pickerView selectRow:(moth-1) inComponent:0 animated:YES];
    
    //得到选中的那个view,并获取到它上面的label,再改变label的字体颜色
    
    [self performSelector:@selector(selectSystemTime)  withObject:nil afterDelay:.1];
    
}

-(void)selectSystemTime{
    
    NSArray *array = [self getSystemTime];
    NSString  *yearRow = array[0];
    int year = [yearRow intValue]-2000;
    
    NSString *mothStr = array[1];
    int moth = [mothStr intValue];
    
    
    UIView*yearview = [_pickerView viewForRow:year forComponent:1];
    UILabel * yearlabel = yearview.subviews.firstObject;
    yearlabel.textColor = [UIColor blackColor];

    UIView * mothview =  [_pickerView viewForRow:(moth-1) forComponent:0];
    UILabel * mothlabel = mothview.subviews.firstObject;
    mothlabel.textColor = [UIColor blackColor];

    UILabel* monthL = [UILabel new];
    monthL.text = @"月";
    monthL.textColor = [UIColor blackColor];

    [_pickerView addSubview:monthL];
    [monthL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.equalTo(monthL.mas_width);
        make.centerY.equalTo(_pickerView.mas_centerY).offset(-3);
        make.left.offset(SCREENWIDTH*0.39);
    }];
    UILabel* yearL = [[UILabel alloc]initWithFrame:CGRectMake(266, 92, 40, 40)];
    yearL.text = @"年";
    yearL.textColor = [UIColor blackColor];

    
    [_pickerView addSubview:yearL];
    [yearL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.equalTo(monthL.mas_width);
        make.centerY.equalTo(_pickerView.mas_centerY).offset(-3);
        make.left.offset(SCREENWIDTH*0.72);
    }];
    
}

#pragma mark pickerviewDelegate
//返回列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回每列行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        
        return  _mothArray.count;
        
    }
    return  _yearArray.count;
    
    
    
}
//每行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
}
//每个item的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return  (self.bounds.size.width-50)/3;
}

//改变选中那行的字体和颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.bounds.size.width-50)/3, 40)];
    text.textAlignment = NSTextAlignmentCenter;
    
    
    if (component==0) {
        text.text = [_mothArray objectAtIndex:row];
    }
    if (component==1) {
        text.text = [_yearArray objectAtIndex:row];
        
    }
    
    [view addSubview:text];
    return view;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    UIView * view =  [_pickerView viewForRow:row forComponent:component];
    UILabel * label = view.subviews.firstObject;
    label.textColor = [UIColor blackColor];
//    label.textColor =[UIColor colorWithRed:13/255.f green:152/255.f blue:215/255.f alpha:1];
    
    if (component==0) {
        monthStr = [_mothArray objectAtIndex:row];
        
    }
    
    if (component==1) {
        yearStr = [_yearArray objectAtIndex:row] ;
    }
}


// 获取系统时间
-(NSArray*)getSystemTime{
    
    NSDate *date = [NSDate date];
    NSTimeInterval  sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:sec];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM"];
    NSString *na = [df stringFromDate:currentDate];
    return [na componentsSeparatedByString:@"-"];
    
}


@end



