//
//  YMScanView.m
//  二维码OC
//
//  Created by W-Duxin on 2017/4/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YMScanView.h"
@interface YMScanView ()

@property (nonatomic, strong) NSMutableArray *viewArray;

@property (nonatomic, strong) UIImageView *centerView;

@property (nonatomic, strong) CABasicAnimation *scanNetAnimation;

@property (nonatomic, strong) UIImageView *scanLine;

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation YMScanView

-(NSMutableArray *)viewArray
{
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

-(UIImageView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIImageView alloc]init];
        _centerView.image = [UIImage imageNamed:@"扫描框"];
        _centerView.clipsToBounds = true;
        _centerView.backgroundColor = [UIColor clearColor];
    }
    return _centerView;
}

-(CABasicAnimation *)scanNetAnimation
{
    if (!_scanNetAnimation) {
        _scanNetAnimation = [[CABasicAnimation alloc]init];
        _scanNetAnimation.keyPath  = @"transform.translation.y";
        _scanNetAnimation.byValue  = @(_scanBoxWH);
        _scanNetAnimation.duration = 2.5;
        _scanNetAnimation.repeatCount = MAXFLOAT;
    }
    return _scanNetAnimation;
}

-(UIImageView *)scanLine
{
    if (!_scanLine) {
        _scanLine = [[UIImageView alloc]init];
        _scanLine.image = [UIImage imageNamed:@"QRCodeScanLine"];
    }
    return _scanLine;
}

-(UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.text = @"将二维码放入框内,即可自动扫描";
        _promptLabel.font = [UIFont systemFontOfMutableSize:12];
        _promptLabel.textColor = [UIColor whiteColor];
    }
    
    return _promptLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scanBoxWH = [UIScreen mainScreen].bounds.size.width / 1.5;
        [self setupSubviews];
        [self setupNotifications];
    }
    return self;
}

-(void)setupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                               name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序，（把程序放在后台执行其他操作）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)
                               name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.（回到程序)
}


-(void)setupSubviews
{
    self.backgroundColor = [UIColor clearColor];
    for (int i = 0; i<4; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = RGBAlphaColor(0, 0, 0, 0.5);
        [self addSubview:view];
        [self.viewArray addObject:view];
    }
    [self addSubview:self.centerView];
    [_centerView addSubview:self.scanLine];
    [self addSubview:self.promptLabel];
    [self setupSubviewsFrame];
    [self startAnimation];
    
}

-(void)setScanBoxWH:(CGFloat)scanBoxWH
{
    _scanBoxWH = scanBoxWH;
    _scanNetAnimation.byValue  = @(_scanBoxWH);
    [self setupSubviewsFrame];
}

-(void)setupSubviewsFrame
{
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.mas_equalTo(SCREENHEIGHT *0.15);
        make.width.mas_equalTo(_scanBoxWH);
        make.height.mas_equalTo(_scanBoxWH);
    }];
    
    [_viewArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(_centerView.mas_top);
    }];

    [_viewArray[1] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(_centerView.mas_bottom);
    }];
    
    [_viewArray[2] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(_centerView.mas_left);
        make.height.equalTo(_centerView.mas_height);
        make.top.equalTo(_centerView);
    }];

    [_viewArray[3] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerView.mas_right);
        make.right.equalTo(self);
        make.height.equalTo(_centerView.mas_height);
        make.top.equalTo(_centerView);
    }];
    
    [_scanLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerView);
        make.top.mas_equalTo(0);
    }];
    
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerView);
        make.top.equalTo(_centerView.mas_bottom).offset(5);
    }];
}

-(void)stopAnimation
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimation];
        });
    }
    [self hideHUD];
    [_scanLine.layer removeAllAnimations];
    _scanLine.hidden = true;
}

-(void)startAnimation
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimation];
        });
    }
    [self hideHUD];
    [_scanLine.layer addAnimation:self.scanNetAnimation forKey:@"translationAnimation"];
    _scanLine.hidden = false;
}

-(void)applicationWillResignActive
{
    [self stopAnimation];
}

-(void)applicationDidBecomeActive
{
    [self startAnimation];
}

-(void)showMessage:(NSString *)str
{
    [self stopAnimation];
    if (str) {
        [MBProgressHUD showText:str toView:_centerView];
    } else {
        [MBProgressHUD showInView:_centerView];
    }
}
-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:_centerView];
}

@end
