//
//  YMCancelReasonCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/13.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMCancelReasonCell.h"
#import "YMTextView.h"
@interface YMCancelReasonCell ()<UITextViewDelegate>

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIButton *imageButton;

@property (nonatomic, weak) YMTextView*inputTextField;
@end

@implementation YMCancelReasonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        [self setupSubviews];
    }
    
    return self;
}

-(YMTextView *)inputTextField
{
    if (!_inputTextField) {
        
        YMTextView *inputTextField = [[YMTextView alloc]init];
        inputTextField.placeholder  = @"描述原因";
        inputTextField.textColor    = FONTCOLOR;
        inputTextField.font         = [UIFont systemFontOfMutableSize:13];
        inputTextField.delegate     = self;
        [self.contentView addSubview:inputTextField];
        _inputTextField = inputTextField;
    }
    
    return _inputTextField;

}

-(void)setupSubviews
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
    
    UILabel *titleLabel      = [[UILabel alloc]init];
    titleLabel.textColor     = FONTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font          = [UIFont systemFontOfMutableSize:13];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *imageButton = [[UIButton alloc]init];
    imageButton.userInteractionEnabled = NO;
    [imageButton setImage:[UIImage imageNamed:@"reason_unselected"] forState:UIControlStateNormal];
    [imageButton setImage:[UIImage imageNamed:@"reason_selected"] forState:UIControlStateSelected];
    [imageButton sizeToFit];
    [self.contentView addSubview:imageButton];
    self.imageButton = imageButton;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.contentView.bounds.size.height > (SCREENWIDTH * ROWProportion)) {
        
        CGFloat interval = ((SCREENWIDTH * ROWProportion) - self.titleLabel.bounds.size.height) / 2;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(LEFTSPACE / 2);
            make.top.mas_equalTo(interval);
            
        }];
        
        [self.imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-LEFTSPACE / 2);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            
        }];
        
        [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(SCREENWIDTH * ROWProportion);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.imageButton.mas_right);
            make.height.mas_equalTo(SCREENWIDTH * ROWProportion);
            
        }];
        
        self.inputTextField.hidden = NO;
        
    } else {
    
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(LEFTSPACE / 2);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        [self.imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-LEFTSPACE / 2);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        self.inputTextField.hidden = YES;
    
    }

}

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.titleLabel.text = _title;
    
    [self.textLabel sizeToFit];

}

-(void)setSelectedButton:(BOOL)selectedButton
{
    _selectedButton = selectedButton;
    self.imageButton.selected = _selectedButton;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 20) {
        
        textView.text = [textView.text substringToIndex:20];
    }

    self.inputText = textView.text;
    
}

@end
