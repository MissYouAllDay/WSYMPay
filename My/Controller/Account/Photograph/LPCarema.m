//
//  LPCarema.m
//  Photo
//
//  Created by 赢联 on 16/9/20.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "LPCarema.h"


@interface LPCarema()
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *VPlayer;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;
@end

@implementation LPCarema

- (id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpCameraPreviewLayer];
    }
    return self;
}

- (void)setUpCameraPreviewLayer {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return;
    }
    if (!_VPlayer) {
        [self initSession];
        self.VPlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.VPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.VPlayer.position = self.center;
        self.VPlayer.bounds = self.bounds;
        [self.layer insertSublayer:self.VPlayer atIndex:0];
    }
}

- (void)initSession {
    self.captureDevice   = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.captureSession  = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithDirection:AVCaptureDevicePositionBack] error:nil];
    self.imageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.imageOutput setOutputSettings:outputSettings];
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
}

- (AVCaptureDevice *)cameraWithDirection:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

/*
 拍照事件
 */
- (void)takePhotoWithCommit:(void (^)(UIImage *image))commitBlock {
    AVCaptureConnection *vConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    vConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;//控制输出照片方向
    __block UIImage *image;
    if (!vConnection) {
        YMLog(@"failed");
        return ;
    }
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:vConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        image = [UIImage imageWithData:imageData];
        image = [self image:image rotation:UIImageOrientationRight];
        commitBlock(image);
    }];
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

- (void)startCamera
{
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}

- (void)stopCamera {
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

/*
 闪光灯
 */
- (void)openFlash{
    if ([self.captureDevice hasFlash] && [self.captureDevice hasTorch]) {
        if (self.captureDevice.flashMode == AVCaptureFlashModeOff) {
            [self.captureSession beginConfiguration];
            [self.captureDevice lockForConfiguration:nil];
            //[self.captureDevice setTorchMode:AVCaptureTorchModeOn];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
            [self.captureDevice unlockForConfiguration];
        }else{
            NSLog(@"闪光灯已开");
        }
    [self.captureSession commitConfiguration];
    }else{
        NSLog(@"设备不支持");
    }
}

- (void)closeFlash{
    if ([self.captureDevice hasFlash] && [self.captureDevice hasTorch]) {
        if (self.captureDevice.flashMode == AVCaptureFlashModeOn) {
            [self.captureSession beginConfiguration];
            [self.captureDevice lockForConfiguration:nil];
            //[self.captureDevice setTorchMode:AVCaptureTorchModeOn];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
            [self.captureDevice unlockForConfiguration];
        }else{
            YMLog(@"闪光灯已关");
        }
        [self.captureSession commitConfiguration];
    }else{
        YMLog(@"设备不支持");
    }

}
- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        
        animation.duration = .5f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_deviceInput device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
            
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.VPlayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:_deviceInput];
            if ([self.captureSession canAddInput:newInput]) {
                [self.captureSession addInput:newInput];
                self.deviceInput = newInput;
                
            } else {
                [self.captureSession addInput:self.deviceInput];
            }
            
            [self.captureSession commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
    if ( device.position == position ) return device;
    return nil;
}
-(BOOL)flashType
{
    return self.captureDevice.flashMode == AVCaptureFlashModeOn;
}
@end
