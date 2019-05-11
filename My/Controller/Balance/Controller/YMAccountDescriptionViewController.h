//
//  YMGradesDetailsViewController.h
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/8.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YMAccountGradesView;

@interface YMAccountDescriptionViewController : UITableViewController

@property (nonatomic, weak) YMAccountGradesView *topView;

@end


@interface YMAccountDetailCell : UITableViewCell

@property (nonatomic, copy) NSString *classTitle;

@property (nonatomic, copy) NSString *topText;

@property (nonatomic, copy) NSString *bottomText;

@end
