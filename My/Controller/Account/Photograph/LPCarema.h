//
//  LPCarema.h
//  Photo
//
//  Created by 赢联 on 16/9/20.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface LPCarema : UIView
@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, assign) BOOL flashType;
- (void)startCamera;
- (void)stopCamera;
- (void)takePhotoWithCommit:(void (^)(UIImage *image))commitBlock;
- (void)openFlash;
- (void)closeFlash;
- (void)changeCamera;
@end
