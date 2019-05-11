//
//  IDVerificationViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/26.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "IDVerificationViewController.h"
#import "PhotographViewController.h"
#import "IDInfoView.h"
#import "YMUserInfoTool.h"
#import <AVFoundation/AVFoundation.h>
#import "YMPublicHUD.h"
@interface IDVerificationViewController ()

@property (nonatomic, weak) UIImageView * backgroundImage;

@property (nonatomic, weak) UILabel *statusLabel;

@property (nonatomic, weak) UILabel *failLabel;

@property (nonatomic, weak) UIButton *takePhotoButton;
@end

@implementation IDVerificationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _verificationStatus = IDVerificationStatusNotStart;
    }
    return self;
}


-(UIImageView *)backgroundImage
{
    if(!_backgroundImage){
        UIImageView *backgroundImage = [[UIImageView alloc]init];
        [self.view addSubview:backgroundImage];
        _backgroundImage = backgroundImage;
    
    }
    
    return _backgroundImage;
}

-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel  *statusLabel  = [[UILabel alloc]init];
        statusLabel.font      = [UIFont systemFontOfSize:17];
        statusLabel.textColor = FONTCOLOR;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:statusLabel];
        _statusLabel = statusLabel;
    }
    return _statusLabel;
}

-(UILabel *)failLabel
{
    if (!_failLabel) {
        UILabel *failLabel  = [[UILabel alloc]init];
        failLabel.font      = [UIFont systemFontOfSize:12];
        failLabel.textColor = [UIColor redColor];
        failLabel.text      = @"身份证审核不通过，请重新上传";
        failLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:failLabel];
        _failLabel = failLabel;
    }
    
    return _failLabel;
    
}

-(UIButton *)shotPhotoButton
{
    if (!_takePhotoButton) {
        
        UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        takePhotoButton.titleLabel.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:15.0]];;
        [takePhotoButton setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register_available"] forState:UIControlStateNormal];
        [takePhotoButton setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"register"] forState:UIControlStateDisabled];
        [takePhotoButton setTitle:@"立即拍摄" forState:UIControlStateNormal];
        [takePhotoButton setTintColor:[UIColor whiteColor]];
        [takePhotoButton addTarget:self action:@selector(takePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
         [takePhotoButton setBackgroundImage:[VUtilsTool stretchableImageWithImgName:@"login_seclected"] forState:UIControlStateHighlighted];
        [self.view addSubview:takePhotoButton];
        _takePhotoButton = takePhotoButton;
    }
    
    return _takePhotoButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNotifications];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:RGBColor(226, 72, 60)];
}
-(void)setupNotifications
{
    [WSYMNSNotification addObserver:self selector:@selector(refreshUserInfo) name:WSYMRefreshUserInfoNotification object:nil];
}

-(void)refreshUserInfo
{
    self.verificationStatus = (int)[YMUserInfoTool shareInstance].usrStatus;
}

-(void)setupSubviews
{
    self.view.backgroundColor = VIEWGRAYCOLOR;
    IDInfoView *infoView      = [[IDInfoView alloc]init];
    infoView.name             = [YMUserInfoTool shareInstance].custName;
    infoView.IDNumber         = [self setSecurityText:[YMUserInfoTool shareInstance].custCredNo];
    [self.view addSubview:infoView];
    
    if (_verificationStatus == IDVerificationStatusSuccess) {
        
        self.navigationItem.title = @"实名认证";
        [self.backgroundImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.view.mas_width).multipliedBy(.25);
            make.height.equalTo(self.view.mas_width).multipliedBy(.25);
            make.top.equalTo(self.view.mas_top).offset(SCREENHEIGHT * 0.07);
            make.centerX.equalTo(self.view.mas_centerX);
            
        }];
        
        
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(SCREENWIDTH*ROWProportion * 2);
            make.width.equalTo(self.view.mas_width);
            make.top.equalTo(self.backgroundImage.mas_bottom).offset(SCREENHEIGHT * 0.07);
            make.centerX.equalTo(self.view.mas_centerX);
            
        }];
        
    } else {
        
         self.navigationItem.title = @"身份证验证";
    
        [self.backgroundImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.view.mas_width).multipliedBy(.19);
            make.height.equalTo(self.view.mas_width).multipliedBy(.15);
            make.top.equalTo(self.view.mas_top).offset(SCREENHEIGHT * 0.05);
            make.centerX.equalTo(self.view.mas_centerX);
            
        }];
        
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.view.mas_width);
            make.height.mas_equalTo(SCREENHEIGHT * 0.05);
            make.top.equalTo(self.backgroundImage.mas_bottom).offset(SCREENHEIGHT * 0.05);
            make.centerX.equalTo(self.view.mas_centerX);
            
        }];
        
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(SCREENWIDTH*ROWProportion * 2);
            make.width.equalTo(self.view.mas_width);
            make.top.equalTo(self.statusLabel.mas_bottom).offset(SCREENHEIGHT * 0.05);
            make.centerX.equalTo(self.view.mas_centerX);
            
        }];
        
        [self.failLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.view.mas_width).multipliedBy(.8);
            make.height.mas_equalTo(SCREENHEIGHT * 0.03);
            make.top.equalTo(infoView.mas_bottom).offset((SCREENHEIGHT * 0.05 - SCREENHEIGHT * 0.03)  / 2);
            make.right.equalTo(self.view.mas_right).offset(-20);
            
        }];
        
        [self.shotPhotoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view.mas_width).multipliedBy(.9);
            make.height.mas_equalTo(SCREENWIDTH*ROWProportion);
            make.top.equalTo(infoView.mas_bottom).offset(SCREENHEIGHT * 0.05);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
    }
}
#pragma mark - 立即拍摄点击
-(void)takePhotoButtonClick
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [YMPublicHUD showAlertView:@"未获得授权使用摄像头" message:@"请在iOS“设置”-“隐私”-“相机”中打开" cancelTitle:@"知道了" handler:nil];
    } else {
        
        PhotographViewController *pgc = [[PhotographViewController alloc]init];
        [self.navigationController pushViewController:pgc animated:YES];
    }
}

-(NSString *)setSecurityText:(NSString *)str
{
    if (str.length < 5) {
        
        NSString * str1 = [str substringFromIndex:1];
        str1 = [@"*" stringByAppendingString:str1];
        return str1;
        
    } else {
        
        NSString *str1 = [str substringToIndex:4];
        NSString *str2 = [str substringFromIndex:14];
        return [[str1 stringByAppendingString:@"********"]stringByAppendingString:str2];
    }
}

-(void)setVerificationStatus:(IDVerificationStatus)verificationStatus
{
    _verificationStatus  = verificationStatus;
    UIImage *image       = nil;
    NSString *str        = nil;
    BOOL hiddenFailLabel = YES;
    BOOL hiddenStatusLabel = NO;
    BOOL hiddenTakePhotoBtn = NO;
    
    switch (_verificationStatus) {
        case IDVerificationStatusFail:
            image = [UIImage imageNamed:@"camera"];
            str = @"拍摄身份证,完善身份信息";
            hiddenFailLabel = NO;
            break;
        case IDVerificationStatusSuccess:
            
            image = [UIImage imageNamed:@"yirenz"];
            hiddenStatusLabel = YES;
            hiddenTakePhotoBtn = YES;
            break;
            
        case IDVerificationStatusNotStart:
            image = [UIImage imageNamed:@"camera"];
            str = @"拍摄身份证,完善身份信息";
            break;
            
        case IDVerificationStatusStarting:
            image = [UIImage imageNamed:@"certification"];
            str = @"您的身份证正在审核中";
            hiddenTakePhotoBtn = YES;
            break;
            
        default:
            break;
    }
    [self setupSubviews];
    
    self.takePhotoButton.hidden = hiddenTakePhotoBtn;
    self.statusLabel.text      = str;
    self.backgroundImage.image = image;
    self.failLabel.hidden      = hiddenFailLabel;
    self.statusLabel.hidden    = NO;
}

@end
