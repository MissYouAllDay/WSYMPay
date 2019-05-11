//
//  YMBillQuestionFachBackVC.m
//  WSYMPay
//
//  Created by junchiNB on 2019/4/26.
//  Copyright © 2019年 赢联. All rights reserved.
//

#import "YMBillQuestionFachBackVC.h"

@interface YMBillQuestionFachBackVC ()
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *middleView;
@property (nonatomic,strong)UIView *bottomView;
@end

@implementation YMBillQuestionFachBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单问题反馈";
    
}
-(UIView *)topView {
    if(!_topView) {
        _topView=[UIView new];
        
    }
    return _topView;
}
-(UIView *)middleView {
    if(!_middleView) {
        
    }
    return _middleView;
}
//-(UIView *)bottomView {
//
//}
/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
