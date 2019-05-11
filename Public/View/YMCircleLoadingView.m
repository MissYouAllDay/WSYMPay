//
//  YMCircleLoadingView.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/6.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCircleLoadingView.h"

@interface YMCircleLoadingView ()
//渲染层
@property (nonatomic,strong) CAShapeLayer *loadingLayer;

@end

@implementation YMCircleLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [WSYMNSNotification addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序，（把程序放在后台执行其他操作）
        [WSYMNSNotification addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.（回到程序)
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

-(CAShapeLayer *)loadingLayer
{
    if (!_loadingLayer) {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        _loadingLayer.strokeColor = RGBAlphaColor(217, 49,47, 0.8).CGColor;
        _loadingLayer.lineWidth = 4;
        _loadingLayer.path = [self drawLoadingBezierPath].CGPath;
    }
    
    return _loadingLayer;
}


- (void)startAnimation {
    if (self.isAnimating) {
        [self stopAnimation];
        [self.layer removeAllAnimations];
    }
    _isAnimating = YES;
    
    [self startRotateAnimation];
    return;
}

- (void)stopAnimation {
    _isAnimating = NO;
    [self stopRotateAnimation];
    return;
}

- (void)startRotateAnimation {
    
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue   = @(1);
    basicAnimation.duration  = 1;
    [self.layer addSublayer:self.loadingLayer];
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    basicAnimation1.fromValue = @(-1);
    basicAnimation1.toValue   = @(1);
    basicAnimation1.duration  = 1;
    
    CAAnimationGroup *animationGroup =[[CAAnimationGroup alloc]init];
    animationGroup.duration = 1;
    animationGroup.repeatCount = HUGE_VAL;
    animationGroup.animations  = @[basicAnimation,basicAnimation1];
    [self.loadingLayer addAnimation:animationGroup forKey:@"loadingAnimation"];
}

- (void)stopRotateAnimation {
    
    [_loadingLayer removeFromSuperlayer];
    [self.layer removeAllAnimations];
}

-(UIBezierPath *)drawLoadingBezierPath{
    
    CGFloat radius = self.bounds.size.height/2 - 3;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    return bezierPath;
}

-(void)applicationWillResignActive:(NSNotification *)notification
{
    
    [self stopAnimation];
}

-(void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self startAnimation];
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    
    _loadingLayer.lineWidth = lineWidth;

}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    
    _loadingLayer.strokeColor = lineColor.CGColor;
}

@end
