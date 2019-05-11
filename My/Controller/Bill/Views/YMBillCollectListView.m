//
//  YMBillCollectListView.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/26.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "YMBillCollectListView.h"
@interface YMBillCollectListView ()
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *middleView;


@end
@implementation YMBillCollectListView
-(instancetype)initWithFrame:(CGRect)frame {
    if(self=[super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI {
    [self addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self);
        make.height.mas_equalTo(KP6(40));
    }];
    [self addSubview:self.middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(KP6(0));
        make.height.mas_equalTo(KP6(120));
    }];
}
-(UIView *)topView {
    if(!_topView) {
        _topView=[UIView new];
        _topView.backgroundColor=UIColorFromHex(0xf2f2f2);
        [_topView addSubview:self.selectedBtn];
        [_topView addSubview:self.lblTitle];
        [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.topView).mas_offset(KP6(14));
            make.centerY.mas_equalTo(self.topView);
        }];
        [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.topView).mas_offset(KP6(-14));
            make.centerY.mas_equalTo(self.topView);
        }];
    }
    return _topView;
}
-(UIView *)middleView {
    if(!_middleView) {
        _middleView=[UIView new];
        _middleView.backgroundColor=[UIColor whiteColor];
        UILabel *lblDesc=[UILabel new];
        lblDesc.textColor=UIColorFromHex(0x808080);
        lblDesc.font=[UIFont monospacedDigitSystemFontOfSize:KP6(14) weight:UIFontWeightMedium];
        lblDesc.numberOfLines=0;
        lblDesc.textAlignment=NSTextAlignmentCenter;
        lblDesc.text=@"每一笔收款记录者您的付出和努力\n今天请继续加油";
        [_middleView addSubview:lblDesc];
        [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.middleView).mas_offset(KP6(48));
            make.right.mas_equalTo(self.middleView).mas_offset(KP6(-48));
        }];
    }
    return _middleView;
}
-(UIButton *)selectedBtn {
    if(!_selectedBtn) {
        _selectedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_selectedBtn setTitle:@"自定义查询" forState:UIControlStateNormal];
        [_selectedBtn setTitleColor:NAVIGATIONBARCOLOR forState:UIControlStateNormal];
    }
    return _selectedBtn;
}
-(UILabel *)lblTitle {
    if(!_lblTitle){
        _lblTitle=[UILabel new];
        _lblTitle.textColor=UIColorFromHex(0x333333);
        _lblTitle.font=[UIFont monospacedDigitSystemFontOfSize:KP6(14) weight:UIFontWeightMedium];
        _lblTitle.text=@"当前日期";
    }
    return _lblTitle;
}
@end
