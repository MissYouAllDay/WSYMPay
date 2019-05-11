//
//  YMTravelTicketTableViewCell.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/18.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMTravelTicketTableViewCell;
@protocol TicketFunctionDelegate <NSObject>

-(void)didSelectTicketFunctionItem:(NSDictionary *)dic;

@end

@interface YMTravelTicketTableViewCell : UITableViewCell
@property (nonatomic, weak) id <TicketFunctionDelegate> delegate;
@property (nonatomic, retain) NSArray * dicArr;

@property (nonatomic, strong) UIButton * but_left;
@property (nonatomic, strong) UIButton * but_middle1;
@property (nonatomic, strong) UIButton * but_middle2;
@property (nonatomic, strong) UIButton * but_right1;
@property (nonatomic, strong) UIButton * but_right2;


@end
