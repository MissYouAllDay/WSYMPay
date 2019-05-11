//
//  YMSearchView.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/5/5.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColumnBtnClick)(NSInteger index);

@interface YMSearchView : UIView
@property (nonatomic, strong) NSArray *columns;
@property (nonatomic, copy) ColumnBtnClick  columnBtnClick;
-(void)show;
-(void)hide;
@end
