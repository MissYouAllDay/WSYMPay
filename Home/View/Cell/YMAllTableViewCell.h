//
//  YMAllTableViewCell.h
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YMAllTableViewCellDelegate<NSObject>
- (void)didChangeCell:(UITableViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface YMAllTableViewCell : UITableViewCell
@property (nonatomic,weak) id<YMAllTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) NSArray * modelArr;
@end
