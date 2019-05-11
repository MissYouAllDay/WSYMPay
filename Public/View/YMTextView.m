//
//  WXTextView.m
//  WX微博
//
//  Created by W-Duxin on 15/12/17.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "YMTextView.h"

@implementation YMTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [WSYMNSNotification addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
    
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];

}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

-(void)textDidChange
{
    [self setNeedsDisplay];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];

}

-(void)setPlaceholderColor:(NSString *)placeholderColor
{
    _placeholderColor = [placeholderColor copy];
    
    [self setNeedsDisplay];

}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    if (self.hasText)  return;
    
    //文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];

    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];

}

@end
