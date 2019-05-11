//
//  YMCollectionView.m
//  WSYMPay
//
//  Created by pzj on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMCollectionView.h"
#import "UIImage+QRCode.h"
#import "YMSaveQrCodeView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YMCollectionBaseListModel.h"
#import "YMPublicHUD.h"

@interface YMCollectionView ()
@property (nonatomic, strong) UIImageView *scanBgImg;
@property (nonatomic, strong) UILabel *scanTitleLabel;
@property (nonatomic, strong) UIImageView *qrCodeImg;
@property (nonatomic, strong) UIImageView *qrCodeIconImg;//二维码上面的图片

@property (nonatomic, strong) UIView *payMentRecordView;//最新两条收款记录bgView
@property (nonatomic, strong) UIView *specLineView;//分割线
@property (nonatomic, strong) UIButton *oneRecordBtn;
@property (nonatomic, strong) UIButton *twoRecordBtn;

@property (nonatomic, strong) UIView *selectBtnBgView;
@property (nonatomic, strong) UIButton *collectCodeBtn;//领取收款码贴纸btn
@property (nonatomic, strong) UIButton *saveQrCodeBtn;//保存二维码图片btn
//保存到相册中二维码
@property (nonatomic, strong) YMSaveQrCodeView *savePhotoBgImg;
@property (nonatomic,strong) UIButton *recordBtn;
@end

@implementation YMCollectionView
{
    CGFloat payMentRecodeHeight;
}
- (void)selectRecordBtn:(YMCollectionBaseListModel *)model{}
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - privateMethods               - Method -
- (void)initView
{
    [self addSubview:self.scanBgImg];
    [self.scanBgImg addSubview:self.scanTitleLabel];
    [self.scanBgImg addSubview:self.qrCodeImg];
    self.dataArray = [[NSMutableArray alloc] init];
    [self addSubview:self.recordBtn];
    
    [self.scanBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).with.offset(SCREENWIDTH *0.13);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
        make.height.mas_equalTo(self.scanBgImg.mas_width);
    }];
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.scanBgImg);
        make.top.mas_equalTo(self.scanBgImg.mas_bottom).mas_offset(-4);
        make.height.mas_equalTo(45);
    }];
    [self.scanTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(self.scanBgImg.mas_top).with.offset(SCREENWIDTH *0.035);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
        make.height.equalTo(self.mas_width).multipliedBy(0.053);
    }];
    [self.qrCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scanBgImg.mas_centerX);
        make.centerY.mas_equalTo(self.scanBgImg.mas_centerY);
        make.left.mas_equalTo(SCALEZOOM(166/2));
        make.right.mas_equalTo(-SCALEZOOM(166/2));
        make.height.mas_equalTo(self.qrCodeImg.mas_width);
    }];
    //保存到相册中的image
    [self addSubview:self.savePhotoBgImg];
    [self.savePhotoBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(self.mas_right).with.offset(0);
        make.width.mas_equalTo(@300);
        make.height.mas_equalTo(@380);
    }];
    [self.scanBgImg addSubview:self.selectBtnBgView];
    [self.scanBgImg addSubview:self.lblA];
    [self.selectBtnBgView addSubview:self.collectCodeBtn];
    [self.selectBtnBgView addSubview:self.saveQrCodeBtn];
    [_lblA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrCodeImg.mas_bottom).offset(4);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
    }];
    [self.selectBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lblA.mas_bottom).offset(4);
        make.left.mas_equalTo(LEFTSPACE);
        make.right.mas_equalTo(-LEFTSPACE);
        make.height.mas_equalTo(45);
    }];
    UIView *linV=[UIView new];
    linV.backgroundColor=RGBColor(51, 51, 51);
    [self.collectCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(LEFTSPACE);
        make.width.mas_equalTo(SCALEZOOM(280/2));
    }];
    [self.selectBtnBgView addSubview:linV];
    [linV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.selectBtnBgView);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(self.selectBtnBgView);
    }];
    [self.saveQrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-LEFTSPACE);
        make.width.mas_equalTo(SCALEZOOM(280/2));
    }];
}

#pragma mark - 保存图片到相册
/*
 * UIView 转成 UIImage
 */
- (UIImage *)imageFromView:(UIView *)view
{
    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO,否则传YES。第三个参数就是屏幕密度了。
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetCurrentContext();
    return image;
}

#pragma mark - eventResponse                - Method -
- (void)collectCodeBtnClick
{
    YMLog(@"领取收款码贴纸");
    [MBProgressHUD showText:MSG0];
}
- (void)saveQrCodeBtnClick
{
    YMLog(@"保存二维码图片");
      [self loadImageFinished:[self imageFromView:self.savePhotoBgImg]];
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [YMPublicHUD showAlertView:@"提示" message:msg cancelTitle:@"确定" handler:nil];
}
- (void)oneRecordBtnClick:(UIButton *)btn
{
    //最新的收款信息
    if ([self.delegate respondsToSelector:@selector(selectRecordBtn)]) {
        [self.delegate selectRecordBtn];
    }
//    NSInteger count = self.dataArray.count;
//    if (count>=1) {
//        YMCollectionBaseListModel *model = self.dataArray[0];
//        if ([self.delegate respondsToSelector:@selector(selectRecordBtn:)]) {
//            [self.delegate selectRecordBtn:model];
//        }
//    }
//    else {
//        [MBProgressHUD showInfo:@"暂无收款记录"];
//    }
//    switch (btn.tag) {
//        case 1000:
//        {
//            if (count>=1) {
//                YMCollectionBaseListModel *model = self.dataArray[0];
//                if ([self.delegate respondsToSelector:@selector(selectRecordBtn:)]) {
//                    [self.delegate selectRecordBtn:model];
//                }
//            }
//        }
//            break;
//        case 1001:
//        {
//            if (count>=2) {
//                YMCollectionBaseListModel *model = self.dataArray[1];
//                if ([self.delegate respondsToSelector:@selector(selectRecordBtn:)]) {
//                    [self.delegate selectRecordBtn:model];
//                }
//            }
//        }
//            break;
//        default:
//            break;
//    }
}
-(void)setAmountAction {
    if(self.delegate&&[self.delegate respondsToSelector:@selector(didsetAmountAction)]) {
        [self.delegate didsetAmountAction];
    }
}
#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -

- (UIImageView *)scanBgImg
{
    if (!_scanBgImg) {
        _scanBgImg = [[UIImageView alloc] init];
        _scanBgImg.image = [UIImage imageNamed:@"scanBgImg"];
        _scanBgImg.userInteractionEnabled=YES;
    }
    return _scanBgImg;
}
- (UILabel *)scanTitleLabel
{
    if (!_scanTitleLabel) {
        _scanTitleLabel = [[UILabel alloc] init];
        _scanTitleLabel.text = @"扫一扫,向我付款";
        _scanTitleLabel.textAlignment = NSTextAlignmentCenter;
        _scanTitleLabel.textColor = FONTCOLOR;
        _scanTitleLabel.font = COMMON_FONT;
    }
    return _scanTitleLabel;
}
- (UIImageView *)qrCodeImg
{
    if (!_qrCodeImg) {
        _qrCodeImg = [[UIImageView alloc] init];
        _qrCodeImg.userInteractionEnabled=YES;
    }
    return _qrCodeImg;
}
- (UIImageView *)qrCodeIconImg
{
    if (!_qrCodeIconImg) {
        _qrCodeIconImg = [[UIImageView alloc] init];
        _qrCodeIconImg.backgroundColor = [UIColor purpleColor];
    }
    return _qrCodeIconImg;
}
- (UIView *)payMentRecordView
{
    if (!_payMentRecordView) {
        _payMentRecordView = [[UIView alloc] init];
        _payMentRecordView.backgroundColor = [UIColor whiteColor];
        _payMentRecordView.layer.masksToBounds = YES;
        _payMentRecordView.layer.cornerRadius = CORNERRADIUS;
        [self addSubview:_payMentRecordView];
        [_payMentRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.scanBgImg.mas_bottom).offset(10);
            make.width.mas_equalTo(self.scanBgImg.mas_width);
            make.height.mas_equalTo(payMentRecodeHeight);
        }];
    }
    return _payMentRecordView;
}
- (UIView *)specLineView
{
    if (!_specLineView) {
        _specLineView = [[UIView alloc] init];
        _specLineView.backgroundColor = lINECOLOR;
        [self.payMentRecordView addSubview:_specLineView];
        [_specLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(40);
            make.height.mas_equalTo(1);
        }];
    }
    return _specLineView;
}
-(UIButton *)recordBtn {
    if(!_recordBtn) {
        _recordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setTitle:@"收款记录" forState:UIControlStateNormal];
        [_recordBtn setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        UIView *linV=[UIView new];
        linV.backgroundColor=RGBColor(240,240,240);
        [self.recordBtn addSubview:linV];
        _recordBtn.backgroundColor=[UIColor whiteColor];
        _recordBtn.tag=111;
        _recordBtn.titleEdgeInsets=UIEdgeInsetsMake(0,16,0, 0);
        _recordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_recordBtn addTarget:self action:@selector(oneRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [linV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.recordBtn).mas_offset(8);
            make.right.mas_equalTo(self.recordBtn).mas_offset(-8);
            make.top.mas_equalTo(self.recordBtn);
            make.height.mas_equalTo(0.8);
        }];
    }
    return _recordBtn;
}
- (UIButton *)oneRecordBtn
{
    if (!_oneRecordBtn) {
        _oneRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneRecordBtn.titleLabel.font = [UIFont systemFontOfMutableSize:13];
        [_oneRecordBtn setTitleColor:FONTCOLOR forState:UIControlStateNormal];
        _oneRecordBtn.tag = 1000;
        [_oneRecordBtn addTarget:self action:@selector(oneRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _oneRecordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self.payMentRecordView addSubview:_oneRecordBtn];
        [_oneRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(39);
        }];
    }
    return _oneRecordBtn;
}
- (UIButton *)twoRecordBtn
{
    if (!_twoRecordBtn) {
        _twoRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoRecordBtn.titleLabel.font = COMMON_FONT;
        [_twoRecordBtn setTitleColor:FONTCOLOR forState:UIControlStateNormal];
        _twoRecordBtn.tag = 1001;
        [_twoRecordBtn addTarget:self action:@selector(oneRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _twoRecordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [self.payMentRecordView addSubview:_twoRecordBtn];
        [_twoRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.right.mas_equalTo(-LEFTSPACE);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
    return _twoRecordBtn;
}
#pragma mark -btn
- (UIView *)selectBtnBgView
{
    if (!_selectBtnBgView) {
        _selectBtnBgView = [[UIView alloc] init];
    }
    return _selectBtnBgView;
}

- (UIButton *)collectCodeBtn
{
    if (!_collectCodeBtn) {
        _collectCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectCodeBtn.backgroundColor = [UIColor whiteColor];
        _collectCodeBtn.layer.masksToBounds = YES;
        _collectCodeBtn.layer.cornerRadius = CORNERRADIUS;
        [_collectCodeBtn setTitle:@"设置金额" forState:UIControlStateNormal];
        _collectCodeBtn.titleLabel.font = COMMON_FONT;
        [_collectCodeBtn setTitleColor:NAVIGATIONBARCOLOR forState:UIControlStateNormal];
        _collectCodeBtn.backgroundColor = [UIColor whiteColor];
//        [_collectCodeBtn addTarget:self action:@selector(collectCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [_collectCodeBtn addTarget:self action:@selector(setAmountAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _collectCodeBtn;
}
- (UIButton *)saveQrCodeBtn
{
    if (!_saveQrCodeBtn) {
        _saveQrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveQrCodeBtn.backgroundColor = [UIColor whiteColor];
        _saveQrCodeBtn.layer.masksToBounds = YES;
        _saveQrCodeBtn.layer.cornerRadius = CORNERRADIUS;
        [_saveQrCodeBtn setTitle:@"保存图片" forState:UIControlStateNormal];
        _saveQrCodeBtn.titleLabel.font = COMMON_FONT;
        _saveQrCodeBtn.backgroundColor = [UIColor whiteColor];
        [_saveQrCodeBtn setTitleColor:NAVIGATIONBARCOLOR forState:UIControlStateNormal];
        [_saveQrCodeBtn addTarget:self action:@selector(saveQrCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveQrCodeBtn;
}

//- (void)setDataArray:(NSMutableArray *)dataArray
//{
////    _dataArray = dataArray;
////
////    //最新的收款信息
////    NSInteger count = _dataArray.count;
////    if (count>0) {
////        if (count == 1) {
////            payMentRecodeHeight = 40;
////            [self payMentRecordView];
////            [self oneRecordBtn];
////            YMCollectionBaseListModel *model = _dataArray[0];
////            [self.oneRecordBtn setTitle:model.getOrderMsgStr forState:UIControlStateNormal];
////        }else{
////            payMentRecodeHeight = 80;
////            [self payMentRecordView];
////            [self specLineView];
////            [self oneRecordBtn];
////
////            YMCollectionBaseListModel *model1 = _dataArray[0];
////            [self.oneRecordBtn setTitle:model1.getOrderMsgStr forState:UIControlStateNormal];
////            YMCollectionBaseListModel *model2 = _dataArray[1];
////            [self.twoRecordBtn setTitle:model2.getOrderMsgStr forState:UIControlStateNormal];
////        }
////
////        [self.selectBtnBgView removeFromSuperview];
////
////    }else{
////        payMentRecodeHeight = 0;
////    }
//    [self.scanBgImg addSubview:self.selectBtnBgView];
//    [self.scanBgImg addSubview:self.lblA];
//    [self.selectBtnBgView addSubview:self.collectCodeBtn];
//    [self.selectBtnBgView addSubview:self.saveQrCodeBtn];
//    [_lblA mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.qrCodeImg.mas_bottom).offset(4);
//        make.left.mas_equalTo(LEFTSPACE);
//        make.right.mas_equalTo(-LEFTSPACE);
//    }];
//    [self.selectBtnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.lblA.mas_bottom).offset(4);
//        make.left.mas_equalTo(LEFTSPACE);
//        make.right.mas_equalTo(-LEFTSPACE);
//        make.height.mas_equalTo(45);
//    }];
//    UIView *linV=[UIView new];
//    linV.backgroundColor=RGBColor(51, 51, 51);
//    [self.collectCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(LEFTSPACE);
//        make.width.mas_equalTo(SCALEZOOM(280/2));
//    }];
//    [self.selectBtnBgView addSubview:linV];
//    [linV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.selectBtnBgView);
//        make.height.mas_equalTo(10);
//        make.width.mas_equalTo(1);
//        make.centerY.mas_equalTo(self.selectBtnBgView);
//    }];
//    [self.saveQrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.right.mas_equalTo(-LEFTSPACE);
//        make.width.mas_equalTo(SCALEZOOM(280/2));
//    }];
//}

- (YMSaveQrCodeView *)savePhotoBgImg
{
    if (!_savePhotoBgImg) {
        _savePhotoBgImg = [[YMSaveQrCodeView alloc] init];
        _savePhotoBgImg.backgroundColor = [UIColor yellowColor];
    }
    return _savePhotoBgImg;
}
- (void)setUserIdStr:(NSString *)userIdStr
{
    _userIdStr = userIdStr;
    self.qrCodeImg.image = [UIImage qrImageByContent:_userIdStr];
    [self.savePhotoBgImg sendQrCode:self.qrCodeImg.image];

}
-(UILabel *)lblA {
    if(!_lblA) {
        _lblA=[UILabel new];
        _lblA.textColor=[UIColor blackColor];
        _lblA.font=[UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _lblA.lineBreakMode=NSLineBreakByClipping;
        _lblA.textAlignment=NSTextAlignmentCenter;
    }
    return _lblA;
}
@end
