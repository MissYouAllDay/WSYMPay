//
//  YMFindHeaderImgView.m
//  WSYMPay
//
//  Created by MaKuiying on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMFindHeaderImgView.h"
#import "SDCycleScrollView.h"
#import "YMBannerModel.h"
#import <NSString+MJExtension.h>

@interface YMFindHeaderImgView()<SDCycleScrollViewDelegate>

@property(nonatomic,strong)UIImageView* headerImg;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray * bannerArray;
@property (nonatomic, strong) NSMutableArray * bannerherfArray;
@end
@implementation YMFindHeaderImgView
- (void)selectBannerItemAtIndex:(NSInteger)index{}
-(instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
     
        NSArray *imageNames = @[@"banner"];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCALEZOOM(328/2)) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"banner"];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.userInteractionEnabled = YES;
    }
    return _cycleScrollView;
}


-(void)setupSubviews{
    
    [self addSubview:[self cycleScrollView]];
    
    
}
-(void)reloadBannerData
{
    [self requestBannerData:@"02"];
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

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    YMLog(@"点击图片回调 - %ld",(long)index);
    if ([self.delegate respondsToSelector:@selector(selectBannerItemAtIndex:)]) {
        [self.delegate selectBannerItemAtIndex:self.bannerherfArray[index]];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
}


@end
