//
//  YMScanViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanViewController.h"
#import "YMScanView.h"
#import <AVFoundation/AVFoundation.h>
#import "YMScanTool.h"
#import "YMScanPayDetailsVC.h"
#import "YMLoadURLVC.h"
#import "YMPublicHUD.h"
#import "YMMyHttpRequestApi.h"
#import "YMScanModel.h"
#import "YMUserInfoTool.h"

#import "PromptBoxView.h"
#import "YMTransferCheckAccountDataModel.h"
#import "YMTransferMoneyVC.h"//扫二维码跳转有名钱包转账 界面
#import "YMTXSelectBankCardVC.h"//扫码跳转tx选择银行卡 界面

@interface YMScanViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PromptBoxViewDelegate>

@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) YMScanTool *scanTool;
@property (nonatomic, strong) YMScanView *scanView;
// 音频播放
@property (strong, nonatomic) AVAudioPlayer *beepPlayer;
@property (nonatomic, strong) YMTransferCheckAccountDataModel *dataModel;
@property (nonatomic, strong) PromptBoxView *promptBoxView;
@property (nonatomic, assign) NSInteger type;//1--tx;2--转账
@property (nonatomic, strong) NSString *scanResultMoney;
@end

@implementation YMScanViewController
#pragma mark - lifeCycle                    - Method -
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"扫一扫";
    [self setupNavigationItem];
    [self setupSubviews];
    
    WEAK_SELF;
    self.scanTool.scanFinish = ^(NSString *result, NSString *error) {
        [weakSelf.beepPlayer play];
        [weakSelf.scanTool stopRunning];
        [weakSelf.scanView showMessage:nil];
        if (error.length) {
            [YMPublicHUD showAlertView:nil message:@"未检测到二维码" cancelTitle:@"确定" handler:^{
                [weakSelf.scanTool startRunning];
                [weakSelf.scanView startAnimation];
            }];
            return;
        }
        if ([result rangeOfString:@"k_amount"].location !=NSNotFound) {
            NSArray *resultArray = [result componentsSeparatedByString:@"k_amount"];
            [weakSelf disposeScanResult:[resultArray firstObject]];
            weakSelf.scanResultMoney = [resultArray lastObject];
        }
        else{
            [weakSelf disposeScanResult:result];
            weakSelf.scanResultMoney = 0;
        }
    };
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _flashBtn.selected = NO;
    [_scanTool turnTorchOn:NO];
    [_scanView stopAnimation];
    [_scanTool stopRunning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scanView startAnimation];
    [self.scanTool startRunning];
}

#pragma mark - privateMethods               - Method -
#pragma mark - 初始化
-(void)setupNavigationItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.flashBtn];
}
-(void)setupSubviews
{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = RGBAlphaColor(0, 0, 0, 0.6);
    [self.view insertSubview:bottomView aboveSubview:self.scanView];
    
    UIButton *photoLibraryBtn = [[UIButton alloc]init];
    [photoLibraryBtn setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    [photoLibraryBtn addTarget:self action:@selector(photoLibraryDidClick) forControlEvents:UIControlEventTouchUpInside];
    [photoLibraryBtn sizeToFit];
    [bottomView addSubview:photoLibraryBtn];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [photoLibraryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.mas_equalTo(-LEFTSPACE);
    }];
}
#pragma mark - 其他 （扫一扫识别二维码之后操作）
-(void)disposeScanResult:(NSString *)result
{
    //扫描二维/相册中识别二维码，解析二维码成功之后
    /*
     * app3期时逻辑处理：
     * 1、二维码解析成功后判断
     是url---跳转webView界面
     */
    if (result.isUrlString) {
        //临时屏蔽
        YMLoadURLVC *eVC = [[YMLoadURLVC alloc]init];
        eVC.loadUrl = result;
        [self.navigationController pushViewController:eVC animated:YES];
    }else{
        /* 跳转逻辑判断：
         *****************************
         * 1、判断result跟userID账户ID 是否一样
         （1）一样（tx）跳转至 选择到账储蓄卡 界面
         YMTXSelectBankCardVC *vc = [[YMTXSelectBankCardVC alloc] init];
         [self.navigationController pushViewController:vc animated:YES];
         （2）不一样
         （2.1）有","分割---前14位商户号，后面的是交易单号（扫pc二维码）app3期的功能
         YMScanPayDetailsVC *payDetailsVC = [[YMScanPayDetailsVC alloc]init];
         （2.2）无"," ----（转账）跳转至 转账付款 界面(需要先请求接口校验对方账户是否可以转账)
         YMTransferMoneyVC *transferMoneyVC = [[YMTransferMoneyVC alloc] init];
         [self.navigationController pushViewController:transferMoneyVC animated:YES];
         */
        
        NSString *userID = [YMUserInfoTool shareInstance].userID;
        NSString *localScanStr = [NSString stringWithFormat:@"WSYMSK%@",userID];
        if ([result isEqualToString:localScanStr]) {//一样（tx）
            /*
             * 需要先请求接口判断能不能转账，能则进转账界面，否则弹框提示，进行相应的操作。
             */
            self.type = 1;
            [self loadCheckTransferMoneyData:result];
            
        }else{//不一样
            NSRange range = [result rangeOfString:@","];
            if (range.location == NSNotFound) {//无","判断有无“WSYMSK”,有跳转账
                if ([result containsString:@"WSYMSK"]) {
                    /*
                     * 需要先请求接口判断能不能转账，能则进转账界面，否则弹框提示，进行相应的操作。
                     */
                    self.type = 2;
                    [self loadCheckTransferMoneyData:result];
                }else{
                    [YMPublicHUD showAlertView:nil message:@"无法识别二维码信息" cancelTitle:@"确定" handler:^{
                        [self.scanTool startRunning];
                        [self.scanView startAnimation];
                    }];
                }
                
            }else{//有","
                NSString *merNo    = [result substringToIndex:range.location];
                NSString *prdOrdNo = [result substringFromIndex:range.location + 1];
                if (merNo.length != 14 || !merNo.mj_isPureInt){
                    [YMPublicHUD showAlertView:nil message:@"无法识别二维码信息" cancelTitle:@"确定" handler:^{
                        [self.scanTool startRunning];
                        [self.scanView startAnimation];
                    }];
                }
                WEAK_SELF;
                [YMMyHttpRequestApi loadHttpRequestWithScanCreatOrderParameters:prdOrdNo merNo:merNo success:^(YMScanModel *model, NSInteger resCode, NSString *resMsg) {
                    
                    if (resCode == 1) {
                        YMScanPayDetailsVC *payDetailsVC = [[YMScanPayDetailsVC alloc]init];
                        model.prdOrdNo         = prdOrdNo;
                        payDetailsVC.details   = model;
                        [weakSelf.navigationController pushViewController:payDetailsVC animated:YES];
                    } else {
                        [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"确定" handler:^{
                            [weakSelf.scanTool startRunning];
                            [weakSelf.scanView startAnimation];
                        }];
                    }
                }];
            }
        }
    }
}
- (void)loadCheckTransferMoneyData:(NSString *)userIDStr
{
    WEAK_SELF;
    NSString *resultUserID = [userIDStr stringByReplacingOccurrencesOfString:@"WSYMSK" withString:@""];
    RequestModel *params = [[RequestModel alloc] init];
    params.userID = resultUserID;
    params.tranMark = @"1";
    //账户id
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBalanceCheckAccount:params success:^(YMTransferCheckAccountDataModel *model) {
        STRONG_SELF;
        strongSelf.dataModel = model;
        [strongSelf goToNextMethod];
    } failure:^(NSString *resMsg) {
        [YMPublicHUD showAlertView:nil message:resMsg cancelTitle:@"确定" handler:^{
            [weakSelf.scanTool startRunning];
            [weakSelf.scanView startAnimation];
        }];
    }];
}
//发送注册邀请
- (void)loadInVitationData
{
    [YMMyHttpRequestApi loadHttpRequestWithTransferToBalanceInviteAccount:self.dataModel.getAccountStr];
}

/**
 * 根据返回的信息判断需要执行什么操作
 * 1、该用户还未注册有名钱包
 * 2、账户被冻结或禁用，进行提示
 * 3、对方账户为一类账户，弹框提示
 * 4、检测到账户为二、三类账户，进入有名钱包账户转账 转账金额界面
 */
- (void)goToNextMethod
{
    NSInteger num = [self.dataModel goToAction];
    switch (num) {
        case 1:
        {
            //该用户还未注册有名钱包
            [self promptBoxView].title = @"该用户还未注册有名钱包!";
            [self promptBoxView].rightButtonTitle = @"邀请注册";
            [self promptBoxView].tag = 102;
            [self.promptBoxView show];
        }
            break;
        case 2:
        {
            //账户冻结或禁用
            [self promptBoxView].title = MSG17;
            [self promptBoxView].rightButtonTitle = @"确定";
            [self promptBoxView].tag = 100;
            [self.promptBoxView show];
        }
            break;
        case 3:
        {
            if (self.type == 1) {//tx
                [self goToTransferMoneyVC];
            }else{
                //一类账户
                [self promptBoxView].title = @"对方账户为一类账户，每年累计付款交易（包括转账到个人银行卡）不超过1000元。您可以提醒对方进行账户升级。继续向对方转账？";
                [self promptBoxView].rightButtonTitle = @"确定";
                [self promptBoxView].tag = 101;
                [self.promptBoxView show];
            }
        }
            break;
        case 4:
        {
            //二三类账户，可以转账或tx
            [self goToTransferMoneyVC];
        }
            break;
        default:
            break;
    }
}

- (void)goToTransferMoneyVC
{
    switch (self.type) {
        case 1:
        {
            YMTXSelectBankCardVC *vc = [[YMTXSelectBankCardVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            YMTransferMoneyVC *vc = [[YMTransferMoneyVC alloc] init];
            vc.functionSource = @"2";
            vc.dataModel = self.dataModel;
            vc.moneyStr = self.scanResultMoney;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
  
        default:
            break;
    }
}

#pragma mark - eventResponse                - Method -
#pragma mark - 点击事件
-(void)photoLibraryDidClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *pVC = [[UIImagePickerController alloc]init];
        pVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pVC.delegate = self;
        [self presentViewController:pVC animated:YES completion:nil];
    } else {
        [YMPublicHUD showAlertView:@"未获得授权使用相册" message:@"请在iOS“设置”-“隐私”-“相机”中打开" cancelTitle:@"知道了" handler:nil];
    }
}

-(void)flashBtnDidClick
{
    _flashBtn.selected = !_flashBtn.isSelected;
    [self.scanTool turnTorchOn:_flashBtn.isSelected];
}

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.scanTool scanFormImage:image withBlock:^(NSString *result, NSString *error) {
            [self.scanTool stopRunning];
            [self.scanView showMessage:nil];
            if (error.length) {
                [YMPublicHUD showAlertView:nil message:@"未检测到二维码" cancelTitle:@"确定" handler:^{
                    [self.scanTool startRunning];
                    [self.scanView startAnimation];
                }];
                return;
            }
            [self disposeScanResult:result];
        }];
    }];
}
#pragma mark - PromptBoxViewDelegate
-(void)promptBoxViewLeftButttonDidClick:(PromptBoxView *)promptBoxView
{
    [self.scanTool startRunning];
    [self.scanView startAnimation];
}
-(void)promptBoxViewRightButtonDidClick:(PromptBoxView *)promptBoxView
{
    switch (promptBoxView.tag) {
        case 100://账户冻结或禁用,点击确定返回YMTransferVC
            [[self promptBoxView] removeView];
            break;
        case 101://一类账户，点击确定，继续跳转到 -- 有名钱包账户转账 转账金额界面
        {
            [self goToTransferMoneyVC];
        }
            break;
        case 102://该用户还未注册有名钱包--发短信邀请。。。
            YMLog(@"发送短信邀请");
            [self loadInVitationData];
            [[self promptBoxView] removeView];
            break;
        default:
            break;
    }
}
#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
#pragma mark - 懒加载
-(UIButton *)flashBtn
{
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc]init];
        [_flashBtn setImage:[UIImage imageNamed:@"flashoff"] forState:UIControlStateNormal];
        [_flashBtn setImage:[UIImage imageNamed:@"flashon"] forState:UIControlStateSelected];
        [_flashBtn addTarget:self action:@selector(flashBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        _flashBtn.size = _flashBtn.currentImage.size;
    }
    return _flashBtn;
}

-(YMScanTool *)scanTool
{
    if (!_scanTool) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            [YMPublicHUD showAlertView:@"未获得授权使用摄像头" message:@"请在iOS“设置”-“隐私”-“相机”中打开" cancelTitle:@"知道了" handler:nil];
            return nil;
        }
        _scanTool = [[YMScanTool alloc]init];
        [_scanTool beginScanningToView:self.view];
    }
    return _scanTool;
}

-(YMScanView *)scanView
{
    if (!_scanView) {
        _scanView = [[YMScanView alloc]init];
        [self.view addSubview:_scanView];
        _scanView.frame = self.view.bounds;
    }
    return _scanView;
}
- (AVAudioPlayer *)beepPlayer
{
    if (_beepPlayer == nil) {
        NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
        _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    }
    return _beepPlayer;
}

-(PromptBoxView *)promptBoxView
{
    if (!_promptBoxView) {
        _promptBoxView = [[PromptBoxView alloc]init];
        _promptBoxView.delegate = self;
        _promptBoxView.leftButtonTitle = @"取消";
    }
    return _promptBoxView;
}

@end
