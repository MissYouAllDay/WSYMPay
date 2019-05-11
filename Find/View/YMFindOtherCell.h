//
//  YMFindOtherCell.h
//  WSYMPay
//
//  Created by MaKuiying on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMColumnModel.h"
#import "YMColumnImageModel.h"
@class YMFindOtherCell;
@protocol YMFindOtherCellDelegate <NSObject>

-(void)yMFindOtherCellDidSelected:(YMColumnImageModel*)model;

@end


@interface YMFindOtherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img0;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UILabel *iconLableName;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;

@property (retain, nonatomic) YMColumnModel * model;
@property (retain, nonatomic)id<YMFindOtherCellDelegate> delegate;





@end
