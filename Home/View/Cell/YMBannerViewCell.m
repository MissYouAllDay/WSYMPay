//
//  YMBannerViewCell.m
//  WSYMPay
//
//  Created by W-Duxin on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMBannerViewCell.h"
#import "YMBannerModel.h"


@interface YMBannerViewCell ()<SDCycleScrollViewDelegate>

@end

@implementation YMBannerViewCell

+(instancetype)configCell:(UITableView *)tableView withBannerPosition:(NSString *)position{

    static NSString *ID    = @"YMBannerViewCellID";
    YMBannerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YMBannerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell requestBannerData:position];
    return cell;
    
};
-(void)requestBannerData:(NSString *)position
{
    /*
    00个人APP-首页-中部
    01个人APP-理财-顶部
    02个人APP-发现-顶部
    03个人APP-发现-中部
    04个人APP-首页-旅游票务-顶部
     */
    
    NSDictionary * paramDic = @{
//                                @"token":user.token,
                                @"position":position,
                                @"tranCode":ADCODE
                                
                                };
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        
        self.bannerArray = [NSMutableArray new];
        self.bannerherfArray = [NSMutableArray new];
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        if (resCode == 1) {
            NSArray * list = [YMBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]] ;
            for (YMBannerModel * model in list) {
                [self.bannerArray addObject:[IP stringByAppendingString:model.adUrl]];
                
                if (model.imgHerf.length > 0) {
                    [self.bannerherfArray addObject:model.imgHerf];
                }else
                {
                    [self.bannerherfArray addObject:@""];
                }
                
                
            }
            
            [self.cycleScrollView setImageURLStringsGroup:self.bannerArray];
            
        }else
        {
            [MBProgressHUD showText:resMsg];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc]init];
    cycleScrollView.placeholderImage   = [UIImage imageNamed:@"home_banner.png"];
    cycleScrollView.delegate           = self;
    cycleScrollView.pageControlStyle   = SDCycleScrollViewPageContolStyleAnimated;
    [self.contentView addSubview:cycleScrollView];
    self.cycleScrollView               = cycleScrollView;
   
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleScrollView.frame = self.contentView.bounds;
    
}

-(void)setIsOnlyShowText:(BOOL)isOnlyShowText
{
    self.cycleScrollView.onlyDisplayText = isOnlyShowText;
   
}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(bannerViewCell:bannerButtonDidClick:)])
    {
        [self.delegate bannerViewCell:self bannerButtonDidClick:self.bannerherfArray[index]];
    }

}


@end
