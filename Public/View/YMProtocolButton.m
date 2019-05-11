//
//  AgreementButton.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/14.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMProtocolButton.h"
#import "YMFullTitleButton.h"
@interface YMProtocolButton ()

@property (nonatomic ,weak) UIButton *imageBtn;

@property (nonatomic, weak) YMFullTitleButton *textBtn;

@end

@implementation YMProtocolButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews
{
    
    UIButton *imageBtn = [[UIButton alloc]init];
    imageBtn.backgroundColor = [UIColor clearColor];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageBtn.selected = YES;
    self.selected     = imageBtn.selected;
    imageBtn.adjustsImageWhenHighlighted = NO;
    [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageBtn];
    self.imageBtn = imageBtn;
    
    YMFullTitleButton *textBtn            = [[YMFullTitleButton alloc]init];
    textBtn.backgroundColor          = [UIColor clearColor];
    textBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [textBtn addTarget:self action:@selector(textBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:textBtn];
    self.textBtn = textBtn;
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    

    CGFloat height = self.bounds.size.height;
    CGFloat width  = self.bounds.size.width;
    self.imageBtn.frame  = CGRectMake(0, 0, height, height);
    self.textBtn.frame   = CGRectMake(height + 5, 0,width - (height + 5), height);
    
 
}
-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,str.length-2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfMutableSize:12] range:NSMakeRange(0, str.length)];
    [self.textBtn setAttributedTitle:str forState:UIControlStateNormal];

}


-(void)imageBtnClick:(UIButton *)btn
{
    btn.selected  = !btn.isSelected;
    self.selected = btn.selected;
    
    if ([self.delegate respondsToSelector:@selector(protocolButtonImageBtnSelected:)]) {
        
        [self.delegate protocolButtonImageBtnSelected:self];
    }
    
}
-(void)textBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(protocolButtonTitleBtnDidClick:)]) {
        
        [self.delegate protocolButtonTitleBtnDidClick:self];
    }

}
-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.imageBtn.selected = selected;
    
}

@end
