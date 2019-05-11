//
//  YMScanTool.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/2.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMScanTool.h"
#import <AVFoundation/AVFoundation.h>
@interface YMScanTool ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, assign) CGFloat scanWH;
@end
@implementation YMScanTool

-(AVCaptureDevice *)device
{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

//-(AVCaptureDeviceInput *)input
//{
//    if (!_input) {
//        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
//        if (!_input) {
//            YMLog(@"初始化失败");
//        }
//    }
//    return _input;
//}

-(AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc]init];
    }
    return _output;
}

-(AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
    }
    return _session;
}

-(AVCaptureVideoPreviewLayer *)preview
{
    if (!_preview) {
        _preview = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    }
    return _preview;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scanWH = SCREENWIDTH / 1.5;
//        
//        if (!interestRect.size.width) {
//            [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
//                                                              object:nil
//                                                               queue:[NSOperationQueue currentQueue]
//                                                          usingBlock: ^(NSNotification *_Nonnull note) {
//                                                              YMLog(@"1 = %@,thread = %@",[NSDate date],[NSThread currentThread]);
//                                                              CGRect rect = CGRectMake((SCREENWIDETH - _scanWH)/2, (SCREENHEIGHT - _scanWH)/2 - 64, _scanWH, _scanWH);
//                                                            interestRect = [self.preview metadataOutputRectOfInterestForRect:rect];
//                                                              
//                                                              self.output.rectOfInterest = interestRect;
//                                                              [[NSNotificationCenter defaultCenter] removeObserver:self];
//                                                          }];
//        }
    }
    return self;
}

-(void)beginScanningToView:(UIView *)view
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginScanningToView:view];
        });
    }
    
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    if (!self.input) {
        YMLog(@"初始化失败");
    }

    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    } else {
        NSLog(@"初始化失败");
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    } else {
        NSLog(@"初始化失败");
    }
    
//    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    if (self.output) {
        //设置扫码支持的编码格式
        NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
        
        if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [array addObject:AVMetadataObjectTypeQRCode];
        }
        if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [array addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [array addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [array addObject:AVMetadataObjectTypeCode128Code];
        }
        self.output.metadataObjectTypes = array;
    }

    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = view.layer.bounds;
    [view.layer insertSublayer:self.preview atIndex:0];
    CGRect rect = CGRectMake((SCREENWIDTH - _scanWH)/2,SCREENHEIGHT *0.15, _scanWH, _scanWH);
    self.output.rectOfInterest = [self getScanCrop:rect readerViewBounds:view.frame];;
    [self.session startRunning];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.y / readerViewBounds.size.height;
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    return CGRectMake(x, y, width, height);
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        if (self.scanFinish) {
            self.scanFinish(metadataObject.stringValue,nil);
        }
    } else {
        if (self.scanFinish) {
            self.scanFinish(nil,@"二维码解析失败");
        }
    }
}

-(void)stopRunning
{
//    [self.session stopRunning];
    [self.output setMetadataObjectsDelegate:nil queue:nil];
}

-(void)startRunning
{
//    [self.session startRunning];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
}

- (void)turnTorchOn:(BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(void)scanFormImage:(UIImage *)image withBlock:(ScanFinish)finish
{
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        if (finish) {
            finish(feature.messageString,nil);
        }
    } else {
        if (finish) {
            finish(nil,@"二维码解析失败");
        }
    }

}

@end
