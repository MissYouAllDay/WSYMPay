//
//  DXInputPasswordView.m
//  test-A
//
//  Created by TY on 16/9/1.
//  Copyright © 2016年 TY. All rights reserved.
//

#import "DXInputPasswordView.h"

//这个值是最大输入数
#define maxInputCount 6

#define DXTextFieldWSize  self.frame.size

@interface DXInputPasswordView ()<UITextFieldDelegate>
//黑色圆点数组，布局时和控制hidden时使用
@property (nonatomic, strong) NSMutableArray *dotInputArray;
//分隔线数组，布局时使用
@property (nonatomic, strong) NSMutableArray *lineArray;

@end

@implementation DXInputPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
//使用懒加载来创建数组
-(NSMutableArray *)pointInputArray
{
    if (!_dotInputArray) {
        
        _dotInputArray = [NSMutableArray array];
    }

    return _dotInputArray;
}

-(NSMutableArray *)lineArray
{
    if (!_lineArray) {
        
        _lineArray = [NSMutableArray array];
    }

    return _lineArray;
}

//添加子控件的方法
-(void)setupSubviews
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textField = [[UITextField alloc] init];
    _textField.hidden = YES;
    _textField.delegate = self;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_textField];
    
    [self.textField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
        self.dotSize = 15.0;
    
    //添加分隔线
    for (int i = 0; i < maxInputCount - 1; i++) {
        CALayer *lineLayer        = [[CALayer alloc]init];
        lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:lineLayer];
        [self.lineArray addObject:lineLayer];
        
    }
    //添加黑色圆点图片
    for (int i = 0; i < maxInputCount; i++) {
        CALayer *dotLayer        = [[CALayer alloc]init];
        dotLayer.hidden          = YES;
        dotLayer.cornerRadius    = self.dotSize/2.f;
        dotLayer.masksToBounds   = YES;
        dotLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:dotLayer];
        [self.pointInputArray addObject:dotLayer];
        
    }
}

//监听其点击的方法
-(void)textFieldTextDidChange:(UITextView *)textField
{
    //显示圆点数
    [self setDotWithCount:textField.text.length];
    
    //判断输入的值是否大于输入长度，如果大于退出键盘
    if(textField.text.length >= maxInputCount) {
    
        if ([self.delegate respondsToSelector:@selector(inputPasswordView:completeInput:)]) {
            
            [self.delegate inputPasswordView:self completeInput:textField.text];
        }
    }

}

//控制圆点的显示与隐藏
-(void)setDotWithCount:(NSInteger)count
{
    for (int i = 0; i < maxInputCount; i++) {
        
        CALayer *pointLayer = _dotInputArray[i];
        if (i < count) {
            
            pointLayer.hidden = NO;
            
        } else {
            
            pointLayer.hidden = YES;
        }
    }
}

//清空输入
-(void)clearUpPassword
{
    _textField.text = nil;
    [self setDotWithCount:0];

}

-(void)layoutSubviews
{
    [super layoutSubviews];

    _textField.frame = CGRectMake(0, 0,DXTextFieldWSize.width,DXTextFieldWSize.height);

    CGFloat lineInterval = DXTextFieldWSize.width / maxInputCount;
    
    for (int i = 0; i < maxInputCount - 1; i++) {
        CALayer *lineLayer = self.lineArray[i];
        lineLayer.frame    = CGRectMake((i + 1) *lineInterval, 0, 1, DXTextFieldWSize.height);
    }
    
    for (int i = 0; i < maxInputCount; i++) {
        CALayer *dotLayer = self.dotInputArray[i];
        dotLayer.frame    = CGRectMake(i *lineInterval+ (lineInterval - self.dotSize) /2 , (self.frame.size.height - self.dotSize)/2, self.dotSize, self.dotSize);
    }

}

//设置边框的颜色
-(void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    self.layer.borderColor = _borderColor.CGColor;

}
//设置分隔线的颜色
-(void)setIntervalLineColor:(UIColor *)intervalLineColor
{
    _intervalLineColor = intervalLineColor;
    
    for (int i = 0; i < maxInputCount - 1; i++) {
        CALayer *lineLayer = self.lineArray[i];
        lineLayer.backgroundColor =  intervalLineColor.CGColor;
    }

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
}

-(void)becomeFirstResponder
{
    [self.textField becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField.text.length > 5) {
        [self clearUpPassword];
    }
    
    return YES;
}


@end
