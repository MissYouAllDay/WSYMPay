//
//  YMFinancialBannerCell.m
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMFinancialBannerCell.h"
#import "SDCycleScrollView.h"
#import "YMBannerModel.h"

@interface YMFinancialBannerCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray * bannerArray; //网络图片url
@property (nonatomic, strong) NSMutableArray * bannerHrefArray; //网络图片超链接

@end

@implementation YMFinancialBannerCell

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        //网络图片
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDETH, SCALEZOOM(101)) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
//        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@""];
//        _cycleScrollView.pageDotImage = [UIImage imageNamed:@""];
//        _cycleScrollView.userInteractionEnabled = YES;
        
        //本地图片
        NSArray *imageNames = @[@"home_banner"];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCALEZOOM(101)) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"home_banner"];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.userInteractionEnabled = YES;
    }
    return _cycleScrollView;
}

- (void)awakeFromNib {
    [super awakeFromNib];    
    [self.contentView addSubview:[self cycleScrollView]];
}
-(void)reloadBannerData
{
    [self requestBannerData:@"01"];
}
-(void)requestBannerData:(NSString *)position
{
    
    /*
     00个人APP-首页-中部
     01个人APP-理财-顶部
     02个人APP-发现-顶部
     03个人APP-发现-中部
     04个人APP-首页-旅游票务-顶部
     */
    
    YMUserInfoTool * user = [YMUserInfoTool shareInstance];
    NSDictionary * paramDic = @{
//                                @"token":user.token,
                                @"position":position,
                                @"tranCode":ADCODE
                                
                                };
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        
        self.bannerArray = [NSMutableArray new];
        self.bannerHrefArray = [NSMutableArray new];
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        if (resCode == 1) {
            NSArray * list = [YMBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]] ;
            for (YMBannerModel * model in list) {
                [self.bannerArray addObject:[IP stringByAppendingString:model.adUrl]];
                if (model.imgHerf.length > 0) {
                    [self.bannerHrefArray addObject:model.imgHerf];
                }else
                {
                    [self.bannerHrefArray addObject:@""];
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


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    YMLog(@"点击图片回调 - %ld",(long)index);
    if ([self.delegate respondsToSelector:@selector(selectBannerItemAtIndex:)]) {
         NSString * imgHerf = self.bannerHrefArray[index];
        [self.delegate selectBannerItemAtIndex:imgHerf];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
}
@end
