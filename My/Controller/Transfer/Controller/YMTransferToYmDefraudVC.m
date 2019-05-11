//
//  YMTransferToYmDefraudVC.m
//  WSYMPay
//
//  Created by PengCheng on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import "YMTransferToYmDefraudVC.h"

@interface YMTransferToYmDefraudVC ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation YMTransferToYmDefraudVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"有名钱包账户";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descLabel];
}
- (UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.text = @"防范电信网络新型违法犯罪提示";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)descLabel{
    if (_descLabel==nil) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+10, SCREENWIDTH-20, 220)];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = [UIColor blackColor];
        _descLabel.text = @"提高自防意识，防范电信诈骗\n当接到陌生短信、电话时，坚决做到四不原则：不汇款、不轻信、不泄露、不连接。\n请谨记以下“八个凡是”都是诈骗，切勿上当，\n    1)凡是自称公安、检查、法院要求汇款的；\n    2)凡是叫你汇款到“安全账户”的；\n    3)凡是通知中奖、领取补贴要你先交钱的；\n    4)凡是通知“家属出事”要先汇款的；\n    5)凡是索要个人和银行卡信息及短信验证码的；\n    6)凡是让你开通网银并接受检查的；\n    7)凡是自称领导（老板）要求打款的；\n    8)凡是陌生网站（链接）要登记银行卡信息的。";
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _descLabel;
}
@end
