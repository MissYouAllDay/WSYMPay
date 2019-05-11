//
//  YMHomeColumnCell.h
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMHomeColumnModel;
@class YMHomeColumnCell;
@protocol YMHomeColumnCellDelegate <NSObject>

/**
 cell中的模块点击

 @param cell self
 @param h5url h5url
 */
-(void)homeColumnCell:(YMHomeColumnCell *)cell columnsDidClick:(NSString *)h5url;

@end

@interface YMHomeColumnCell : UITableViewCell

@property (nonatomic, strong) YMHomeColumnModel *columns;

+(instancetype)configCell:(UITableView *)tableView withColumns:(YMHomeColumnModel *)columns;

@property (nonatomic, weak) id <YMHomeColumnCellDelegate> delegate;

@end
