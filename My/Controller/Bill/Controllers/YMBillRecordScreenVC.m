//
//  YMBillRecordScreenVC.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/24.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "YMBillRecordScreenVC.h"

@interface YMBillRecordScreenVC ()
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *middleView;
@property (nonatomic,strong) UITextField *txtLowF;
@property (nonatomic,strong)UITextField *txtHightTF;
@property (nonatomic,strong)UIButton *resetBtn;
@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,strong) NSMutableArray *buttons;

@end

@implementation YMBillRecordScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"筛选";
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *lbl=[UILabel new];
    lbl.text=@"快捷选择";
    lbl.textColor=FONTDARKCOLOR;
    lbl.font=[UIFont systemFontOfSize:SCALEZOOM(16) weight:UIFontWeightMedium];
    [self.view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(KP6(10));
        make.left.mas_equalTo(self.view).mas_offset(KP6(10));
    }];
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(lbl.mas_bottom).mas_offset(KP6(10));
        make.height.mas_equalTo(2*46);
    }];
    [self.view addSubview:self.middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(KP6(20));
        make.height.mas_equalTo(KP6(64));
    }];
    [self.view addSubview:self.resetBtn];
    [self.view addSubview:self.sureBtn];
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(KP6(10));
        make.top.mas_equalTo(self.middleView.mas_bottom).mas_offset(48);
        make.height.mas_equalTo(KP6(48));
        make.width.mas_equalTo((SCREENWIDTH-20)/2);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(KP6(-10));
        make.top.mas_equalTo(self.middleView.mas_bottom).mas_offset(48);
        make.height.mas_equalTo(KP6(48));
        make.width.mas_equalTo((SCREENWIDTH-20)/2);
    }];
}
-(void)selectAction:(UIButton *)btn {
    
    if(!btn.selected) {
        btn.backgroundColor=NAVIGATIONBARCOLOR;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        btn.backgroundColor=LAYERCOLOR;
        [btn setTitleColor:FONTDARKCOLOR forState:UIControlStateNormal];
    }
    if (btn.tag == 0) {
        _value = @"转账";
    }
    else {
        _value = @"网购";
    }
    btn.selected = !btn.selected;
    
}
-(void)resetAction {
    _value = nil;
    _txtLowF.text = @"";
    _txtHightTF.text = @"";
    for (UIButton *btn in self.buttons) {
        btn.backgroundColor=LAYERCOLOR;
        [btn setTitleColor:FONTDARKCOLOR forState:UIControlStateNormal];
    }
}
-(void)sureAction {
    if (self.clickValueblock) {
        self.clickValueblock(_value);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)topView {
    if(!_topView) {
        _topView=[UIView new];
        NSArray *arr = @[@"消费",@"账户充值",@"账户提现",@"转账",@"手机充值",@"我要收款"];
        [self.buttons removeAllObjects];
        for (int i=0;i<6;i++) {
            int m=i%3;
            int n=i/3;
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=LAYERCOLOR;
            btn.tag=i;
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:FONTDARKCOLOR forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont monospacedDigitSystemFontOfSize:SCALEZOOM(14) weight:UIFontWeightMedium];
            [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [_topView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.topView).mas_offset(SCALEZOOM(122*m)+SCALEZOOM(10));
                make.top.mas_equalTo(self.topView).mas_offset(SCALEZOOM(46*n));
                make.width.mas_equalTo(SCALEZOOM(112));
                make.height.mas_equalTo(SCALEZOOM(36));
            }];
            [self.buttons addObject:btn];
        }
    }
    return _topView;
}

-(UIView *)middleView {
    if(!_middleView) {
        _middleView=[UIView new];
        UILabel *lbl1=[UILabel new];
        lbl1.text=@"金额";
        lbl1.textColor=FONTDARKCOLOR;
        lbl1.font=[UIFont systemFontOfSize:SCALEZOOM(16) weight:UIFontWeightMedium];
        [_middleView addSubview:lbl1];
         [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.mas_equalTo(self.middleView).mas_offset(KP6(10));
             make.top.mas_equalTo(self.middleView).mas_offset(KP6(8));
        }];
        UIView *linview1=[UIView new];
        linview1.layer.cornerRadius=KP6(4);
        linview1.layer.borderColor=UIColorFromHex(0xf2f2f2).CGColor;
        linview1.layer.borderWidth=KP6(1);
        UIView *linview2=[UIView new];
        linview2.layer.cornerRadius=KP6(4);
        linview2.layer.borderColor=UIColorFromHex(0xf2f2f2).CGColor;
        linview2.layer.borderWidth=KP6(1);
        
        UIView *linview3=[UIView new];
        linview3.layer.borderColor=UIColorFromHex(0xf2f2f2).CGColor;
        [_middleView addSubview:linview1];
        [_middleView addSubview:linview2];
        [_middleView addSubview:linview3];
        [linview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.middleView).mas_offset(KP6(10));
            make.top.mas_equalTo(lbl1.mas_bottom).mas_offset(KP6(8));
            make.width.mas_equalTo((SCREENWIDTH-40)/2);
            make.height.mas_equalTo(KP6(36));
        }];
        [linview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.middleView).mas_offset(KP6(-10));
            make.top.mas_equalTo(lbl1.mas_bottom).mas_offset(KP6(8));
            make.width.mas_equalTo((SCREENWIDTH-40)/2);
            make.height.mas_equalTo(KP6(36));
        }];
        [linview3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(linview1).mas_offset(KP6(4));
            make.right.mas_equalTo(linview2.mas_right).mas_offset(KP6(-4));
            make.centerY.mas_equalTo(linview1);
            make.height.mas_equalTo(KP6(1));
        }];
        UILabel *lbl2=[UILabel new];
        lbl2.text=@"¥";
        lbl2.textColor=FONTDARKCOLOR;
        lbl2.font=[UIFont systemFontOfSize:SCALEZOOM(16) weight:UIFontWeightMedium];
        [linview1 addSubview:lbl2];
        [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(linview1).mas_offset(KP6(4));
            make.centerY.mas_equalTo(linview1);
        }];
        [linview1 addSubview:self.txtLowF];
        [_txtLowF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lbl2.mas_right).mas_offset(KP6(8));
            make.top.bottom.right.mas_equalTo(linview1);
        }];
        UILabel *lbl3=[UILabel new];
        lbl3.text=@"¥";
        lbl3.textColor=FONTDARKCOLOR;
        lbl3.font=[UIFont systemFontOfSize:SCALEZOOM(16) weight:UIFontWeightMedium];
        [linview2 addSubview:lbl3];
        [lbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(linview2).mas_offset(KP6(4));
            make.centerY.mas_equalTo(linview2);
        }];
        [linview2 addSubview:self.txtHightTF];
        [_txtHightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lbl3.mas_right).mas_offset(KP6(8));
            make.top.bottom.right.mas_equalTo(linview2);
        }];
    }
    return _middleView;
}
-(UITextField *)txtLowF {
    if(!_txtLowF) {
        _txtLowF=[[UITextField alloc]init];
        _txtLowF.textAlignment=NSTextAlignmentLeft;
        _txtLowF.font=[UIFont systemFontOfSize:KP6(14)];
        _txtLowF.placeholder=@"最低金额";
    }
    return _txtLowF;
}
-(UITextField *)txtHightTF {
    if(!_txtHightTF) {
        _txtHightTF=[[UITextField alloc]init];
        _txtHightTF.textAlignment=NSTextAlignmentLeft;
        _txtHightTF.font=[UIFont systemFontOfSize:KP6(14)];
        _txtHightTF.placeholder=@"最高金额";
    }
    return _txtHightTF;
}
-(UIButton *)resetBtn {
    if(!_resetBtn) {
        _resetBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"register"] forState:UIControlStateNormal];
        [_resetBtn setTitleColor:FONTDARKCOLOR forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}
-(UIButton *)sureBtn {
    if(!_sureBtn) {
        _sureBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[VUtilsTool  stretchableImageWithImgName:@"register_available"]forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
@end
