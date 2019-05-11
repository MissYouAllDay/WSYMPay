//
//  YMFindCenterView.m
//  WSYMPay
//
//  Created by MaKuiying on 2017/7/17.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMFindCenterView.h"
#import "SDCycleScrollView.h"
#import "YMBannerModel.h"

@interface YMFindCenterView()<SDCycleScrollViewDelegate>

@property(nonatomic,strong)UIImageView* iconImage;
@property (nonatomic, strong) SDCycleScrollView *textScrollView;
@property (nonatomic, strong) NSMutableArray * bannerArray;
@property (nonatomic, strong) NSMutableArray * bannerimgHerfArray;


@end
@implementation YMFindCenterView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

/**
 请求借口数据信息
 */
-(void)requestBannerData
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
                                @"position":@"03",
                                @"tranCode":ADCODE
                                
                                };
    [[YMHTTPRequestTool shareInstance] POST:BASEURL parameters:paramDic success:^(id responseObject) {
        
        self.bannerArray = [NSMutableArray new];
        self.bannerimgHerfArray = [NSMutableArray new];
        NSInteger resCode = [responseObject[@"resCode"] intValue];
        NSString * resMsg = responseObject[@"resMsg"];
        if (resCode == 1) {
            NSArray * list = [YMBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]] ;
            for (YMBannerModel * model in list) {
                [self.bannerArray addObject:[IP stringByAppendingString:model.adUrl]];
                [self.bannerimgHerfArray addObject:[model.imgHerf length]>0?model.imgHerf:@""];
            }
            
            [self.textScrollView setImageURLStringsGroup:self.bannerArray];
            
        }else
        {
            [MBProgressHUD showText:resMsg];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)setupSubviews{
   
    
//    _iconImage = [UIImageView new];
//    [_iconImage setImage:[UIImage imageNamed:@"有名头条"]];
//    [self addSubview:_iconImage];
//    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(SCREENWIDTH*0.032);
//        make.centerY.mas_equalTo(self.mas_centerY);
//    }];
    
    _textScrollView = [SDCycleScrollView new];
    _textScrollView.delegate = self;
    _textScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    _textScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
     [self addSubview:_textScrollView];
    [_textScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.with.right.with.top.with.bottom.mas_equalTo(0);
    }];

}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(selectCenterBannerItemAtIndex:)]) {
        [self.delegate selectCenterBannerItemAtIndex:self.bannerimgHerfArray[index]];
    }
}


@end
