//
//  YMTextField.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/3/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTextField.h"
@interface YMTextField ()
@property (nonatomic, strong) UILabel *leftLabel;
@end

@implementation YMTextField

-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel               = [[UILabel alloc]init];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor     = [UIColor grayColor];
        _leftLabel.font          = COMMON_FONT;
    }
    
    return _leftLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.leftViewMode  = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

-(void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = [leftTitle copy];
    
    //字符串长度为2就手动添加一个空格
    if (_leftTitle.length == 2) {
        NSMutableString *mStr = [[NSMutableString alloc]initWithString:_leftTitle];
        [mStr insertString:@"　" atIndex:1];
        _leftTitle = mStr;
    }
    
    self.leftLabel.text = _leftTitle;
    [self.leftLabel sizeToFit];
    self.leftLabel.size = CGSizeMake(self.leftLabel.size.width + 20, self.leftLabel.size.height);
    self.leftView = self.leftLabel;
}
@end
