//
//  CGXPickerViewManager.m
//  CGXPickerView
//
//  Created by 曹贵鑫 on 2018/1/8.
//  Copyright © 2018年 曹贵鑫. All rights reserved.
//

#import "CGXPickerViewManager.h"

@interface CGXPickerViewManager ()

@end
@implementation CGXPickerViewManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kPickerViewH = 200;
        _kTopViewH = 50;
        _pickerTitleSize  =15;
        _pickerTitleColor = [UIColor blackColor];
        _lineViewColor =CGXPickerRGBColor(225, 225, 225, 1);
        
        _titleLabelColor = [UIColor blackColor];
        _titleSize = 16;
        _titleLabelBGColor = [UIColor whiteColor];
        
        _rightBtnTitle = @"确定";
        _rightBtnBGColor =  [UIColor whiteColor];
        _rightBtnTitleSize = 16;
        _rightBtnTitleColor = [UIColor blackColor];
        
//        _rightBtnborderColor = MainColor;
//        _rightBtnCornerRadius = 6;
//        _rightBtnBorderWidth = 1;
        
        _leftBtnTitle = @"取消";
        _leftBtnBGColor =  [UIColor whiteColor];
        _leftBtnTitleSize = 16;
        _leftBtnTitleColor = [UIColor blackColor];
        
//        _leftBtnborderColor = MainColor;
//        _leftBtnCornerRadius = 6;
//        _leftBtnBorderWidth = 1;
        
    }
    return self;
}
@end
