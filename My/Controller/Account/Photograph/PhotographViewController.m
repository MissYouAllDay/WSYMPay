//
//  PhotographViewController.m
//  WSYMPay
//
//  Created by 赢联 on 16/9/21.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "PhotographViewController.h"
#import "PhotoBackViewController.h"
#import "LPCarema.h"
#import <AVFoundation/AVFoundation.h>
@interface PhotographViewController ()
@property (nonatomic, strong) LPCarema *caremaView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation PhotographViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.tag = 500;
    }
    return self;
}

- (LPCarema *)caremaView
{
    if (_caremaView == nil) {
        _caremaView = [[LPCarema alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 500.0/667*SCREENHEIGHT)];
        [self.view addSubview:_caremaView];
        [self.view sendSubviewToBack:_caremaView];
        
            //中间镂空的矩形框
            CGRect myRect =CGRectMake(12.5/375*SCREENWIDTH,125/667.0*SCREENHEIGHT,350/375.0*SCREENWIDTH, 215/375.0*SCREENWIDTH);
            
            //背景
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_caremaView.bounds cornerRadius:0];
            //镂空
            UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:5];
            [path appendPath:circlePath];
            [path setUsesEvenOddFillRule:YES];
            
            CAShapeLayer *fillLayer = [CAShapeLayer layer];
            fillLayer.path = path.CGPath;
            fillLayer.fillRule = kCAFillRuleEvenOdd;
            fillLayer.fillColor = [UIColor blackColor].CGColor;
            fillLayer.opacity = 0.5;
            [_caremaView.layer addSublayer:fillLayer];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"frontimg"]];
        imageView.backgroundColor = [UIColor clearColor];
        [_caremaView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(160/667.0*SCREENHEIGHT);
            make.left.equalTo(self.view.mas_left).offset(220/375.0*SCREENWIDTH);
            make.width.equalTo(self.view.mas_width).multipliedBy(100/375.0);
            make.height.equalTo(imageView.mas_width).multipliedBy(0.9);
        }];

        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(135/375.0*SCREENWIDTH/2, 350/667.0*SCREENHEIGHT, 240/375.0*SCREENWIDTH, 21/667.0*SCREENHEIGHT)];
        titleLab.text = @"将身份证正面置于此区域，拍摄身份证";
        titleLab.numberOfLines = 0;
        titleLab.adjustsFontSizeToFitWidth = YES;
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textColor = [UIColor whiteColor];
        [_caremaView addSubview:titleLab];
        
    }
    return _caremaView;
}


-(void)backBtnTouchUp:(UIButton *)sender
{
    [self.caremaView closeFlash];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UIButton *)flashBtn{
    if (_flashBtn == nil) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashBtn.selected = self.caremaView.flashType;
        _flashBtn.frame = CGRectMake(275/375.0*SCREENWIDTH, SCREENHEIGHT- 64-(60/667.0*SCREENHEIGHT), 50/375.0*SCREENWIDTH, 30/667.0*SCREENHEIGHT);
        [_flashBtn setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
        [_flashBtn setImage:[UIImage imageNamed:@"flash_default"] forState:UIControlStateSelected];
        [_flashBtn addTarget:nil action:@selector(flashBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashBtn;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 500.0/667*SCREENHEIGHT)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = nil;

    }
    return _imageView;
}

- (UIView *)selectView{
    if (_selectView == nil) {
        _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        self.selectView.backgroundColor = [UIColor blackColor];
        _selectView.hidden =YES;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(50/375.0*SCREENWIDTH, SCREENHEIGHT-(60/667.0*SCREENHEIGHT) - 64, 50/375.0*SCREENWIDTH, 30/667.0*SCREENHEIGHT);
       
        [cancelBtn setTitle:@"重拍" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:nil action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:cancelBtn];
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake(275/375.0*SCREENWIDTH, SCREENHEIGHT-(60/667.0*SCREENHEIGHT) - 64, 50/375.0*SCREENWIDTH, 30/667.0*SCREENHEIGHT);
        
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [finishBtn addTarget:nil action:@selector(finishBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:finishBtn];
    }
    return _selectView;
}

- (UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame =  CGRectMake(50/375.0*SCREENWIDTH, SCREENHEIGHT-(60/667.0*SCREENHEIGHT) - 64, 50/375.0*SCREENWIDTH, 30/667.0*SCREENHEIGHT);
        [_backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnTouchUp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)photoBtn{
    if (_photoBtn == nil) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame = CGRectMake(self.view.center.x - (35.0/375*SCREENWIDTH), SCREENHEIGHT-64-(82.0/667*SCREENHEIGHT), 70.0/375*SCREENWIDTH, 70.0/375*SCREENWIDTH);
        [_photoBtn setImage:[UIImage imageNamed:@"photo_default"] forState:UIControlStateNormal];
        [_photoBtn setImage:[UIImage imageNamed:@"photo_focus"] forState:UIControlStateSelected];
        [_photoBtn addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI{
    
    UIBarButtonItem  *rightBBI = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    [rightBBI setImage:[UIImage imageNamed:@"camera2"]];
    rightBBI.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBBI;

    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTouchUp)];
    self.navigationItem.leftBarButtonItem = leftItem;
  
    self.navigationItem.title = @"拍摄身份证";
    
    [self.caremaView startCamera];
    [self.view insertSubview:self.selectView aboveSubview:self.caremaView];
    [self.selectView addSubview:self.imageView];
    [self.view addSubview:self.photoBtn];
    [self.view sendSubviewToBack:self.photoBtn];
    [self.view addSubview:self.flashBtn];
    [self.view sendSubviewToBack:self.flashBtn];
    [self.view addSubview:self.backBtn];
    [self.view sendSubviewToBack:self.backBtn];
    self.view.backgroundColor = [UIColor blackColor];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.caremaView stopCamera];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)rightBtnClick{
    [self.caremaView changeCamera];

}

- (void)flashBtn:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.caremaView openFlash];
    }
    else {
        [self.caremaView closeFlash];
    }

}

- (void)cancelBtn:(UIButton *)button{
    _selectView.hidden = YES;
   [self.navigationController setNavigationBarHidden:NO];
}

- (void)finishBtn:(UIButton *)button{
    PhotoBackViewController *pbc = [[PhotoBackViewController alloc]init];
    pbc.frontImage = self.imageView.image;
    [self.navigationController pushViewController:pbc animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)takePhotoAction:(UIButton *)sender {
 
     AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.caremaView takePhotoWithCommit:^(UIImage *image) {
       
        CGRect rect1 = [self transfromRectWithImageSize:image.size];
        if ([[self.caremaView.deviceInput device] position] == AVCaptureDevicePositionBack) {
            rect1.origin.y -= 100;
        }else{
            rect1.origin.y -= 50;
        }
        UIGraphicsBeginImageContext(rect1.size);
        CGImageRef subImgeRef = CGImageCreateWithImageInRect(image.CGImage, rect1);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, rect1, subImgeRef);
        image = [UIImage imageWithCGImage:subImgeRef];
        UIGraphicsEndImageContext();
         _imageView.image = image;
        _selectView.hidden = NO;
        
    }];
    
}

- (CGRect)transfromRectWithImageSize:(CGSize)size {
    CGRect newRect;
    CGRect   clipRect   = CGRectMake(SCREENWIDTH/2.0-350/375.0*SCREENWIDTH/2, 475/667.0*SCREENHEIGHT, 350/375.0*SCREENWIDTH, 215/375.0*SCREENWIDTH);
    CGFloat  clipWidth  = clipRect.size.width;
    CGFloat  clipHeigth = clipRect.size.height;
    CGFloat  imageH     = size.height;
    CGFloat  imageW     = size.width;
    CGFloat  vpLayerW   = self.caremaView.bounds.size.width;
    CGFloat  vpLayerH   = self.caremaView.bounds.size.height;
    newRect.size        = CGSizeMake(imageW * clipWidth / vpLayerW, imageH * clipHeigth / vpLayerH);
    newRect.origin      = CGPointMake((imageW - newRect.size.width)/2, (imageH - newRect.size.height)/2);
    return newRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnTouchUp
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
