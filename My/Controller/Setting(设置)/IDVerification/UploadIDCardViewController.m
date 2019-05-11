//
//  UploadIDCardViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/27.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "UploadIDCardViewController.h"
#import "IDVerificationViewController.h"
#import "IDCardView.h"
#import "IDVerificationTimeView.h"
#import "IDVerificationDatePicker.h"
#import "ShowIDView.h"
#import "IDUploadSucessController.h"
#import "YMUserInfoTool.h"
//表单模型
#import "UploadParam.h"
@interface UploadIDCardViewController ()<IDVerificationTimeViewDelegate,IDCardViewDelegate,IDVerificationDatePickerDelegate>

@property (nonatomic, weak)   IDVerificationTimeView *idTimeView;

@property (nonatomic, weak)   IDCardView             *idCardView;

@property (nonatomic, weak)   UIButton               *uploadBtn;

@property (nonatomic, strong) ShowIDView             *show;

@property (nonatomic, copy)   NSString               *IDStartTime;

@property (nonatomic, copy)   NSString               *IDEndTime;
@end

@implementation UploadIDCardViewController

-(ShowIDView *)show
{
    if (!_show) {
        
       _show = [[ShowIDView alloc]init];
    }
   
    return _show;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];  
}

-(void)viewWillAppear:(BOOL)animated
{
    //略过拍摄照片的界面，直接返回拍摄照片界面
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:NAVIGATIONBARCOLOR];
}

-(void)setupSubviews
{
    self.navigationItem.title = @"身份证验证";
    self.view.backgroundColor = VIEWGRAYCOLOR;
    
    UILabel *titleLabel  = [[UILabel alloc]init];
    titleLabel.text      = @"证件照";
    titleLabel.font      = [UIFont systemFontOfSize:15];
    titleLabel.textColor = FONTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    

    IDCardView *idCardView   = [[IDCardView alloc]init];
    idCardView.frontImage    = self.frontImage;
    idCardView.backImage     = self.backImage;
    idCardView.delegate      = self;
    [self.view addSubview:idCardView];
    self.idCardView = idCardView;

    
    IDVerificationTimeView *idTimeView = [[IDVerificationTimeView alloc]init];
    idTimeView.delegate                = self;
    [self.view addSubview:idTimeView];
    self.idTimeView = idTimeView;
    
    //注册按钮
    UIButton *uploadBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
     uploadBtn.enabled         = NO;
     uploadBtn.titleLabel.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:15.0]];;
    [uploadBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register_available"] forState:UIControlStateNormal];
    [uploadBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register"] forState:UIControlStateDisabled];
    [uploadBtn setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
    [uploadBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [uploadBtn setTitleColor:FONTCOLOR forState:UIControlStateDisabled];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];
    self.uploadBtn = uploadBtn;
    
    
    [idCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height).multipliedBy(.4);
        make.top.equalTo(self.view.mas_top).offset(SCREENWIDTH*ROWProportion);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    [idTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.top.equalTo(idCardView.mas_bottom).offset(LEFTSPACE);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.view.mas_width).multipliedBy(.5);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(idCardView.mas_top);
        make.left.equalTo(self.view.mas_left).offset(LEFTSPACE);
    }];
    
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.view.mas_width).multipliedBy(.9);
        make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
        make.top.equalTo(idTimeView.mas_bottom).offset(LEFTSPACE);
        make.centerX.equalTo(self.view.mas_centerX);
    }];

}

#pragma mark - 提交审核
-(void)uploadBtnClick
{/**
    token           令牌
    validity	    身份证有效
    validityStart	有效开始日期
    front           身份证正面
    back            身份证反面
    handheld        手持身份证
*/
    NSDateFormatter*formatter  = [[NSDateFormatter alloc]init];
    formatter.dateFormat       =  @"yyyyMMddHHmmss";
    NSString *strDate          = [formatter stringFromDate:[NSDate date]];
    
    [MBProgressHUD showMessage:@"上传中"];
    UploadParam *paramImage1  = [[UploadParam alloc]init];
    paramImage1.data          = UIImageJPEGRepresentation(self.frontImage, 0.3);
    paramImage1.name          = @"front";
    paramImage1.filename      = [strDate stringByAppendingString:@"front.jpg"];
    paramImage1.mimeType      = @"jpg";
    
    UploadParam *paramImage2  = [[UploadParam alloc]init];
    paramImage2.data          = UIImageJPEGRepresentation(self.backImage, 0.3);
    paramImage2.name          = @"back";
    paramImage2.filename      = [strDate stringByAppendingString:@"back.jpg"];
    paramImage2.mimeType      = @"jpg";
    
    NSArray *uploadImageArray = @[paramImage1,paramImage2];
    
    UploadParam *formParam1   = [[UploadParam alloc]init];
    formParam1.data           = [[YMUserInfoTool shareInstance].token dataUsingEncoding:NSUTF8StringEncoding];
    formParam1.name           = @"token";
    
    UploadParam *formParam2   = [[UploadParam alloc]init];
    formParam2.data           = [[self.IDStartTime stringByReplacingOccurrencesOfString:@"." withString:@""] dataUsingEncoding:NSUTF8StringEncoding];
    formParam2.name           = @"validityStart";
    
    UploadParam *formParam3   = [[UploadParam alloc]init];
    formParam3.data           = [[self.IDEndTime stringByReplacingOccurrencesOfString:@"." withString:@""] dataUsingEncoding:NSUTF8StringEncoding];
    formParam3.name           = @"validity";
    
    UploadParam *formParam4   = [[UploadParam alloc]init];
    formParam4.data           = [UPLOADIDCARD dataUsingEncoding:NSUTF8StringEncoding];
    formParam4.name           = @"tranCode";
    

    NSArray *formParamData    = @[formParam1,formParam2,formParam3,formParam4];
    YMUserInfoTool *currentInfo = [YMUserInfoTool shareInstance];
    [[YMHTTPRequestTool shareInstance] uploadWithURLString:UPLOADURL formParameters:formParamData uploadParam:uploadImageArray success:^(id responseObject) {
        YMLog(@"%@",responseObject);
        if ([responseObject[@"resCode"]intValue] == 1) {
           
           [MBProgressHUD hideHUD];
            currentInfo.usrStatus = 1;
            [currentInfo saveUserInfoToSanbox];
            [currentInfo refreshUserInfo];
           IDUploadSucessController *successVC = [[IDUploadSucessController alloc]init];
           [self.navigationController pushViewController:successVC animated:YES];
            [self dissmissCurrentViewController:1];
            
        } else {
        
            [MBProgressHUD showText:responseObject[@"resMsg"]];
        
        }
    } failure:^(NSError *error) {}];
}

#pragma mark - 开始时间按钮点击
-(void)idVerificationTimeViewStartButtonDidClick:(IDVerificationTimeView *)idV
{
    IDVerificationDatePicker *datePicker = [[IDVerificationDatePicker alloc]init];
    datePicker.delegate = self;
    datePicker.longTimeButtonHiden = YES;
    datePicker.minimumDate = @"2004.01.01";
    [self.view addSubview:datePicker];
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    __weak typeof(self) weakSelf = self;
    datePicker.strBlock = ^(NSString *strTM){
        
        idV.startDate        = strTM;
        weakSelf.IDStartTime = strTM;
    };
}
#pragma mark - 结束时间按钮点击
-(void)idVerificationTimeViewEndButtonDidClick:(IDVerificationTimeView *)idV
{
    if (_idTimeView.startDate.length == 0) {
        
         [MBProgressHUD showText:@"请先选择开始日期"];
        return;
    }
    
    IDVerificationDatePicker *datePicker = [[IDVerificationDatePicker alloc]init];
    datePicker.delegate                  = self;
    datePicker.minimumDate               = idV.startDate;
    NSString *lastStr                    = [idV.startDate substringFromIndex:4];
    int years                            = [[idV.startDate substringToIndex:4]intValue] + 20;
    lastStr                              = [NSString stringWithFormat:@"%d%@",years,lastStr];
    datePicker.maximumDate               = lastStr;
    [self.view addSubview:datePicker];
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(SCREENHEIGHT);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    __weak typeof(self) weakSelf = self;
    datePicker.strBlock = ^(NSString *strTM){
        
        idV.endDate                = strTM;
        weakSelf.uploadBtn.enabled = YES;
        
        if ([strTM isEqualToString:@"长期"]) {
            strTM = @"30000101";
        }
        
        weakSelf.IDEndTime         = strTM;
    };
}

#pragma mark - 正面照片点击
-(void)idCardViewFrontPhotoButtonDidClick:(IDCardView *)idcv
{
    [self.show showImage:idcv.frontImage];
   
}

#pragma mark - 反面照片点击
-(void)idCardViewBackPhotoButtonDidClick:(IDCardView *)idcv
{
    [self.show showImage:idcv.backImage];
}

#pragma mark - 选中时间
-(void)idVerificationDatePickerDidEndEditing:(IDVerificationDatePicker *)idve
{
    [idve removeFromSuperview];
}

@end
