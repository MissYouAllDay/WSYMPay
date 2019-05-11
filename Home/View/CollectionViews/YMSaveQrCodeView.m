//
//  YMSaveQrCodeView.m
//  WSYMPay
//
//  Created by pzj on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMSaveQrCodeView.h"
#import "YMUserInfoTool.h"

@interface YMSaveQrCodeView ()
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *qrCodeImage;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation YMSaveQrCodeView
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
#pragma mark - privateMethods               - Method -
- (void)initView
{
    [self addSubview:self.bgImage];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.bgImage addSubview:self.qrCodeImage];
    [self.qrCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(115);
        make.centerX.mas_equalTo(self.bgImage.mas_centerX);
        make.width.mas_equalTo(@140);
        make.height.mas_equalTo(@140);
    }];
    
    [self.bgImage addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrCodeImage.mas_bottom).with.offset(2);
        make.centerX.mas_equalTo(self.bgImage.mas_centerX);
        make.width.mas_equalTo(@148);
        make.height.mas_equalTo(@20);
    }];
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -
- (UIImageView *)bgImage
{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] init];
        _bgImage.image = [UIImage imageNamed:@"saveQrCodeImg"];
    }
    return _bgImage;
}
- (UIImageView *)qrCodeImage
{
    if (!_qrCodeImage) {
        _qrCodeImage = [[UIImageView alloc] init];
        _qrCodeImage.backgroundColor = [UIColor yellowColor];
    }
    return _qrCodeImage;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"商户名称";
        _nameLabel.textColor = FONTCOLOR;
        _nameLabel.font = [UIFont systemFontOfMutableSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (void)sendQrCode:(UIImage *)qrCode
{
    self.qrCodeImage.image = qrCode;
    _nameLabel.text = [YMUserInfoTool shareInstance].custName;
}
@end
