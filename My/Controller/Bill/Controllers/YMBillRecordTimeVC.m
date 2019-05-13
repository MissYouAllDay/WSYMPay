//
//  YMBillRecordTimeVC.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/25.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "YMBillRecordTimeVC.h"
#import "PGDatePickManager.h"
@interface YMBillRecordTimeVC ()<PGDatePickerDelegate>
@property (nonatomic,strong) PGDatePicker *datePicker;
@property (nonatomic,strong) PGDatePicker *datedayPicker;
@property (nonatomic,strong) UILabel *monLbl;
@property (nonatomic,strong) UILabel *dateLbl;
@property (nonatomic,strong) UIView *topLineView;
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,strong) UIButton *starttime;
@property (nonatomic,strong) UIButton *endtime;
@property (nonatomic,strong) UILabel *toLbl;
@property (nonatomic,assign) NSInteger timeTag;
@property (nonatomic,copy) NSString *value;
@end

@implementation YMBillRecordTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择时间";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSubviews];
}
- (void)setSubviews {
    
    UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(17, 12, 92, 27)];
    chooseView.layer.cornerRadius = 14;
    [chooseView.layer setMasksToBounds:YES];
    chooseView.layer.borderColor = UIColorFromHex(0xf6f6f6).CGColor;
    chooseView.layer.borderWidth = 1.0f;
    [self.view addSubview:chooseView];
    
    _monLbl = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 60, 27)];
    _monLbl.text = @"按月选择";
    _monLbl.textColor = UIColorFromHex(0x000000);
    _monLbl.font = [UIFont systemFontOfSize:14];
    [chooseView addSubview:_monLbl];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"date_change"]];
    icon.frame = CGRectMake(_monLbl.right+5, 8, 12, 9);
    [chooseView addSubview:icon];
    chooseView.userInteractionEnabled = YES;
    [chooseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseviewClick:)]];
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyleAlertBottomButton;
    datePickManager.isShadeBackground = true;
    self.datedayPicker = datePickManager.datePicker;
    self.datedayPicker.isHiddenMiddleText = false;
    self.datedayPicker.delegate = self;
    //    self.datePicker.maximumDate
    self.datedayPicker.language = @"zh-Hans";
    self.datedayPicker.datePickerType = PGDatePickerTypeSegment;
    self.datedayPicker.textColorOfSelectedRow = [UIColor blackColor];
    self.datedayPicker.textColorOfOtherRow = [UIColor lightGrayColor];
    self.datedayPicker.lineBackgroundColor = UIColorFromHex(0xdfdfdf);
    self.datedayPicker.datePickerMode = PGDatePickerModeDate;
    self.datedayPicker.rowHeight = 40.f;
    self.datedayPicker.frame = CGRectMake(105, 181, SCREENWIDTH - 210, 214);
    [self.view addSubview:self.datedayPicker];
    
    
    self.starttime = [[UIButton alloc]initWithFrame:CGRectMake(0, 74, (SCREENWIDTH-12)/2, 60)];
    [self.starttime setTitle:@"开始时间" forState:UIControlStateNormal];
    [self.starttime setTitleColor:UIColorFromHex(0xDD3F34) forState:UIControlStateNormal];
    self.starttime.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.starttime];
    self.starttime.tag = 10;
    self.starttime.hidden = YES;
    [self.starttime addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchDown];
    
    self.toLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-7, 74, 14, 60)];
    self.toLbl.text = @"至";
    [self.view addSubview:self.toLbl];
    self.toLbl.hidden = YES;
    
    self.endtime = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-7, 74, (SCREENWIDTH-12)/2, 60)];
    [self.endtime setTitle:@"结束时间" forState:UIControlStateNormal];
    [self.endtime setTitleColor:UIColorFromHex(0xDD3F34) forState:UIControlStateNormal];
    self.endtime.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.endtime];
    self.endtime.tag = 11;
    self.endtime.hidden = YES;
    [self.endtime addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchDown];
    
    
    
    
    
    
    PGDatePickManager *datePickManager1 = [[PGDatePickManager alloc]init];
    datePickManager1.style = PGDatePickManagerStyleAlertBottomButton;
    datePickManager1.isShadeBackground = true;
    self.datePicker = datePickManager1.datePicker;
    self.datePicker.isHiddenMiddleText = false;
    self.datePicker.delegate = self;
//    self.datePicker.maximumDate
    self.datePicker.language = @"zh-Hans";
    self.datePicker.datePickerType = PGDatePickerTypeSegment;
    self.datePicker.textColorOfSelectedRow = [UIColor blackColor];
    self.datePicker.textColorOfOtherRow = [UIColor lightGrayColor];
    self.datePicker.lineBackgroundColor = UIColorFromHex(0xdfdfdf);
    self.datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    self.datePicker.rowHeight = 40.f;
    self.datePicker.frame = CGRectMake(105, 181, SCREENWIDTH - 210, 214);
    [self.view addSubview:self.datePicker];
    
    
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, self.datePicker.bottom+52, SCREENWIDTH-24, 48)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"register_available"]forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 5.f;
    [btn.layer setMasksToBounds:YES];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
//   按月选择
    

    _dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 96, SCREENWIDTH, 15)];
    _dateLbl.text = @"选择时间";
    _dateLbl.textColor = UIColorFromHex(0xdd3f34);
    _dateLbl.font = [UIFont systemFontOfSize:15];
    _dateLbl.textAlignment = NSTextAlignmentCenter;
    _dateLbl.userInteractionEnabled = YES;
    [_dateLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateClick)]];
    [self.view addSubview:_dateLbl];
    
    _topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.dateLbl.bottom +24, SCREENWIDTH, 1)];
    _topLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_topLineView];
    
    _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.datePicker.bottom -1 , SCREENWIDTH, 1)];
    _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_bottomLineView];
    
    
}
- (void)chooseviewClick:(UITapGestureRecognizer *)tap {
    if ([_monLbl.text isEqualToString:@"按月选择"]) {
        self.datePicker.hidden = YES;
        self.starttime.hidden = NO;
        self.endtime.hidden = NO;
        self.toLbl.hidden = NO;
        self.dateLbl.hidden = YES;
        _monLbl.text = @"按日选择";
    }
    else {
        _monLbl.text = @"按月选择";
        self.datePicker.hidden = NO;
        self.starttime.hidden = YES;
        self.endtime.hidden = YES;
        self.toLbl.hidden = YES;
        self.dateLbl.hidden = NO;
    }
}
- (void)chooseTime:(UIButton *)sender {
    self.timeTag = sender.tag;
    [self.datedayPicker tapSelectedHandler];
}
//
- (void)dateClick {
    [self.datePicker tapSelectedHandler];
}
- (void)btnclick {
    if ([_monLbl.text isEqualToString:@"按月选择"]) {
        if (_dateLbl.text.length > 0 && ![_dateLbl.text isEqualToString:@"选择时间"]) {
            self.clickMonthblock(_dateLbl.text);
             [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [MBProgressHUD showText:@"选择时间"];
        }
    }
    else {
        if (![self.starttime.titleLabel.text isEqualToString:@"开始时间"] && ![self.endtime.titleLabel.text isEqualToString:@"结束时间"]) {
            self.clickMonthblock([NSString stringWithFormat:@"%@ - %@",self.starttime.titleLabel.text,self.endtime.titleLabel.text]);
             [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [MBProgressHUD showText:@"选择时间"];
        }
    }

   
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    if (self.timeTag > 0) {
        NSString *time =[NSString stringWithFormat:@"%d-%d-%d",(int)dateComponents.year,(int)dateComponents.month,(int)dateComponents.day];
        if (self.timeTag == 10) {
            [self.starttime setTitle:time forState:UIControlStateNormal];
        }
        else {
            [self.endtime setTitle:time forState:UIControlStateNormal];
        }
        
    }
    else {
    _dateLbl.text = [NSString stringWithFormat:@"%d-%d",(int)dateComponents.year,(int)dateComponents.month];
    }
    
}

@end
