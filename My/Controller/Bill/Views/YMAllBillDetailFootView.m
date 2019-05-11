//
//  YMAllBillDetailFootView.m
//  WSYMPay
//
//  Created by pzj on 2017/7/21.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllBillDetailFootView.h"
#import "YMRedBackgroundButton.h"
#import "YMAllBillDetailDataModel.h"

@interface YMAllBillDetailFootView ()
//@property (nonatomic, strong) YMRedBackgroundButton *searchBtn;
@property (nonatomic, strong) UIButton  *searchBtn;
@property (nonatomic, strong) UIButton  *revokeBtn;

@end

@implementation YMAllBillDetailFootView
- (void)selectComplaintsBtnMethod{}

+ (YMAllBillDetailFootView *)instanceView
{
    YMAllBillDetailFootView *footView = [[YMAllBillDetailFootView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 102)];
    return footView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  initViews];
    }
    return self;
}

- (void)initViews
{
    [self addSubview:self.searchBtn];
    [self addSubview:self.revokeBtn];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(46);
        make.top.equalTo(@10);
    }];
    [self.revokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(46);
    }];
    
}
-(UIButton *)searchBtn {
    if(!_searchBtn) {
        _searchBtn = [[UIButton alloc]init];
        [_searchBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [_searchBtn setTitle:@"订单疑问反馈？" forState:UIControlStateNormal];
        _searchBtn.backgroundColor = [UIColor whiteColor];
    }
    return _searchBtn;
}
-(UIButton *)revokeBtn {
    if(!_revokeBtn) {
        _revokeBtn = [[UIButton alloc]init];
        [_revokeBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_revokeBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [_revokeBtn setTitle:@"订单撤销" forState:UIControlStateNormal];
        _revokeBtn.backgroundColor = [UIColor whiteColor];
    }
    return _revokeBtn;
}

- (void)selectBtnClick
{
    if ([self.delegate respondsToSelector:@selector(selectComplaintsBtnMethod)]) {
        [self.delegate selectComplaintsBtnMethod];
    }
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    [self.searchBtn setTitle:_titleStr forState:UIControlStateNormal];
}
- (void)sendSelectMoney:(NSString *)money isSelect:(BOOL)isSelect
{
    if (money.length>0 && [money floatValue]>0.00 && isSelect==YES) {
        self.searchBtn.enabled = YES;
    }else{
        self.searchBtn.enabled = NO;
    }
}

- (void)sendBillDetailType:(BillDetailType)billDetailType model:(YMAllBillDetailDataModel *)model
{
    if (billDetailType !=  BillDetailAccountTransfer) {
        self.revokeBtn.hidden = YES;
    }
    else {
        self.revokeBtn.hidden = NO;
    }
//    switch (billDetailType) {
//        case BillDetailConsumeMobilePhoneRecharge://手机充值
//        {
//            NSString *btnTitle = @"";
//            if ([[model getXiaoFeiOrderStatusCode]isEqualToString:@"00"]) {
//                btnTitle = @"立即支付";
//            }else if ([[model getXiaoFeiOrderStatusCode]isEqualToString:@"99"]){
//                btnTitle = @"";
//                self.searchBtn.hidden = YES;
//            }else{
//                NSString *AcceptStateCode = [model getAcceptStateCodeStr];
//                if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
//                    btnTitle = @"订单投诉";
//                }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
//                    btnTitle = @"撤销投诉";
//                }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
//                    btnTitle = @"确认";
//                }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
//                    btnTitle = @"";
//                    self.searchBtn.hidden = YES;
//                }
//            }
//            [self.searchBtn setTitle:btnTitle forState:UIControlStateNormal];
//        }
//            break;
//        case BillDetailConsumeScan://手机充值,//消费---扫一扫超级收款码 //扫一扫pc端生成的二维码//TX
//        {
//            NSString *btnTitle = @"";
//            if ([[model getXiaoFeiOrderStatusCode]isEqualToString:@"00"]) {
//                btnTitle = @"";
//                self.searchBtn.hidden = YES;
//            }else if ([[model getXiaoFeiOrderStatusCode]isEqualToString:@"99"]){
//                btnTitle = @"";
//                self.searchBtn.hidden = YES;
//            }else{
//                NSString *AcceptStateCode = [model getAcceptStateCodeStr];
//                if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
//                    btnTitle = @"订单投诉";
//                }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
//                    btnTitle = @"撤销投诉";
//                }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
//                    btnTitle = @"确认";
//                }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
//                    btnTitle = @"";
//                    self.searchBtn.hidden = YES;
//                }
//            }
//            [self.searchBtn setTitle:btnTitle forState:UIControlStateNormal];
//        }
//            break;
//        case BillDetailAccountTransfer://转账(我要收款/ 扫一扫有名收款码)
//        {
//            NSString *btnTitle = @"";
//            NSString *AcceptStateCode = [model getAcceptStateCodeStr];
//            if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
//                btnTitle = @"订单投诉";
//            }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
//                btnTitle = @"撤销投诉";
//            }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
//                btnTitle = @"确认";
//            }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
//                btnTitle = @"";
//                self.searchBtn.hidden = YES;
//            }
//            [self.searchBtn setTitle:btnTitle forState:UIControlStateNormal];
//        }
//            break;
//        case BillDetailAccountRecharge://账户充值
//        {
//            NSString *btnTitle = @"";
//            if ([[model getXiaoFeiOrderStatusCode]isEqualToString:@"00"]) {
//                btnTitle = @"";
//                self.searchBtn.hidden = YES;
//            }else if ([[model getXiaoFeiOrderStatusCode]isEqualToString:@"99"]){
//                btnTitle = @"";
//                self.searchBtn.hidden = YES;
//            }else{
//                NSString *AcceptStateCode = [model getAcceptStateCodeStr];
//                if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
//                    btnTitle = @"订单投诉";
//                }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
//                    btnTitle = @"撤销投诉";
//                }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
//                    btnTitle = @"确认";
//                }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
//                    btnTitle = @"";
//                    self.searchBtn.hidden = YES;
//                }
//            }
//            [self.searchBtn setTitle:btnTitle forState:UIControlStateNormal];
//        }
//            break;
//        case BillDetailAccountWithDrawal://账户提现
//        {
//            NSString *btnTitle = @"";
//            NSString *AcceptStateCode = [model getAcceptStateCodeStr];
//            if ([AcceptStateCode isEqualToString:@"0"]) {//未投诉
//                btnTitle = @"订单投诉";
//            }else if ([AcceptStateCode isEqualToString:@"1"]){//未处理
//                btnTitle = @"撤销投诉";
//            }else if ([AcceptStateCode isEqualToString:@"2"]){//已处理
//                btnTitle = @"确认";
//            }else if ([AcceptStateCode isEqualToString:@"3"]){//已确认
//                btnTitle = @"";
//                self.searchBtn.hidden = YES;
//            }
//            [self.searchBtn setTitle:btnTitle forState:UIControlStateNormal];
//        }
//            break;
//
//        default:
//            break;
//    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
