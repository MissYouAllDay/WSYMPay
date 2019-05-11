//
//  YMBillComplainTextViewCell.m
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBillComplainTextViewCell.h"
#import "YMTextView.h"

@interface YMBillComplainTextViewCell ()<UITextViewDelegate>

@property (nonatomic,strong) YMTextView *inputTextField;
@property (nonatomic,strong) UILabel *numsLbl;

@end
@implementation YMBillComplainTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(LEFTSPACE, LEFTSPACE, LEFTSPACE, LEFTSPACE));
    }];
    [self.contentView addSubview:self.numsLbl];
    [self.numsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-17);
        make.right.equalTo(@-31);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (YMTextView *)textView
{
    if (!_inputTextField) {
        _inputTextField = [[YMTextView alloc] init];
        _inputTextField.editable = YES;
        _inputTextField.textColor    = FONTCOLOR;
        _inputTextField.font         = [UIFont systemFontOfMutableSize:13];
        _inputTextField.delegate     = self;
        _inputTextField.placeholder = @"请输入不少于10个字的描述";
    }
    return _inputTextField;
}
- (UILabel *)numsLbl {
    if (!_numsLbl) {
        _numsLbl = [[UILabel alloc]init];
        _numsLbl.font = COMMON_FONT;
        _numsLbl.textColor = [UIColor blackColor];
        _numsLbl.text = @"0/240";
        _numsLbl.textAlignment = NSTextAlignmentRight;
    }
    return _numsLbl;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(![textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
        NSLog(@"输入为空");
        textView.text = @"";
        return;
    }else{
        self.numsLbl.text = [NSString stringWithFormat:@"%lu/240",(unsigned long)textView.text.length];
        if (textView.text.length>240) {
            [MBProgressHUD showText:@"输入文字限240个字符"];
            textView.text = [textView.text substringToIndex:240];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(selectInputReasonStr:)]) {
            [self.delegate selectInputReasonStr:textView.text];
        }
    }
}

@end
