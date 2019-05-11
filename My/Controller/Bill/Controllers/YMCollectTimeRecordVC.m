//
//  YMCollectTimeRecordVC.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/26.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "YMCollectTimeRecordVC.h"

@interface YMCollectTimeRecordVC ()
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *middleView;
@property (nonatomic,strong)UIButton *beginTime;
@property (nonatomic,strong)UIButton *finishTime;
@property (nonatomic,strong)UIButton *queryBtn;

@end

@implementation YMCollectTimeRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"自定义查询";
    self.view.backgroundColor=UIColorFromHex(0xededed);
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(KP6(30));
    }];
    [self.view addSubview:self.middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(KP6(1));
    }];
}
-(void)queryAction {
}
-(UIView *)topView {
    if(!_topView) {
        _topView=[UIView new];
        _topView.backgroundColor=UIColorFromHex(0xf5f5f5);
        UILabel *lblDesc=[UILabel new];
        lblDesc.text=@"目前仅支持开始时间起30天内的查询";
        lblDesc.textColor=UIColorFromHex(0x333333);
        lblDesc.font=[UIFont monospacedDigitSystemFontOfSize:KP6(14) weight:UIFontWeightRegular];
        [_topView addSubview:lblDesc];
        [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.topView).mas_offset(KP6(10));
            make.centerY.mas_equalTo(self.topView);
            make.height.mas_equalTo(KP6(150));
        }];
    }
    return _topView;
}
-(UIView *)middleView {
    if(!_middleView) {
        _middleView=[UIView new];
        _middleView.backgroundColor=[UIColor whiteColor];
        [_middleView addSubview:self.beginTime];
        [_beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.middleView);
            make.height.mas_equalTo(KP6(50));
        }];
        [_middleView addSubview:self.finishTime];
        [_finishTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.middleView);
            make.top.mas_equalTo(self.beginTime.mas_bottom).mas_offset(KP6(1));
            make.height.mas_equalTo(KP6(50));
        }];
        [_middleView addSubview:self.queryBtn];
        [_queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.middleView);
            make.top.mas_equalTo(self.finishTime.mas_bottom).mas_offset(KP6(1));
            make.height.mas_equalTo(KP6(50));
        }];
    }
    return _middleView;
}
-(UIButton *)beginTime {
    if(!_beginTime) {
        _beginTime=[UIButton buttonWithType:UIButtonTypeCustom];
        [_beginTime setTitle:@"选择开始时间" forState:UIControlStateNormal];
        [_beginTime setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
        UILabel *lbl=[UILabel new];
        lbl.textColor=UIColorFromHex(0x333333);
        lbl.font=[UIFont monospacedDigitSystemFontOfSize:KP6(16) weight:UIFontWeightMedium];
        lbl.text=@"开始时间";
        [_beginTime addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.beginTime).mas_offset(KP6(10));
            make.centerY.mas_equalTo(self.beginTime);
        }];
    }
    return _beginTime;
}
-(UIButton *)finishTime {
    if(!_finishTime) {
        _finishTime=[UIButton buttonWithType:UIButtonTypeCustom];
        [_finishTime setTitle:@"选择结束时间" forState:UIControlStateNormal];
        [_finishTime setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
        UILabel *lbl=[UILabel new];
        lbl.textColor=UIColorFromHex(0x333333);
        lbl.font=[UIFont monospacedDigitSystemFontOfSize:KP6(16) weight:UIFontWeightMedium];
        lbl.text=@"结束时间";
        [_finishTime addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.finishTime).mas_offset(KP6(10));
            make.centerY.mas_equalTo(self.finishTime);
        }];
    }
    return _finishTime;
}
-(UIButton *)queryBtn {
    if(!_queryBtn) {
        _queryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_queryBtn setTitleColor:NAVIGATIONBARCOLOR forState:UIControlStateNormal];
        [_queryBtn setTitle:@"查询" forState:UIControlStateNormal];
        [_queryBtn addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryBtn;
}

@end
