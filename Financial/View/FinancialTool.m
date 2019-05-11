//
//  FinancialTool.m
//  WSYMPay
//
//  Created by pzj on 2017/6/6.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "FinancialTool.h"
#import "YMFinancialClassCell.h"
#import "YMFinancialListCell.h"
#import "YMFinancialListHeaderView.h"
#import "YMFinancialBannerCell.h"
#import "YMSpecReusableView.h"
#import "YMAllCollectionViewCell.h"
#import "YMMobileCollectionViewCell_phone.h"
#import "YMMobileCollectionViewCell_money.h"



static NSString* const TYPE_BANNER=@"YMFinancialBannerCell";
static NSString* const TYPE_CLASS=@"YMFinancialClassCell";
static NSString* const TYPE_LISTHEADER=@"YMFinancialListHeaderView";
static NSString* const TYPE_SPEC=@"YMSpecReusableView";
static NSString* const TYPE_LIST=@"YMFinancialListCell";


@interface FinancialTool ()<UICollectionViewDelegate,UICollectionViewDataSource,YMFinancialBannerCellDelegate,YMMobileCollectionPhoneDelegate>
@property (nonatomic, strong) NSMutableArray *classImageArray;
@end

@implementation FinancialTool
//- (void)selectBannerMethodWithIndex:(NSInteger)index{}
//- (void)selectMethodWithViewType:(NSInteger)viewType{}
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithCollectionViewFrame:(CGRect)collectionViewFrame
{
    self = [super init];
    if (self) {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    return self;
}
#pragma mark - privateMethods               - Method -
#pragma mark - eventResponse                - Method -
#pragma mark - notification                 - Method -
#pragma mark - customDelegate               - Method -
- (void)selectBannerItemAtIndex:(NSString *)h5Url
{
    if ([self.delegate respondsToSelector:@selector(selectBannerMethodWithIndex:)]) {
    
        [self.delegate selectBannerMethodWithIndex:h5Url];
    }
}
#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return 3;
    
    //拓展
    return self.allArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    NSDictionary * dic = self.allArr[section];
    NSArray * itemArr =  dic[@"function"];
    return itemArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.allArr[indexPath.section];
    NSString * identifier = dic[@"itemCell"];
    NSArray * function = dic[@"function"];
    YMCollectionModel * model = function[indexPath.item];
   if ([NSStringFromClass([YMFinancialBannerCell class]) isEqualToString:dic[@"itemCell"]] ) {
      
       YMFinancialBannerCell *bannerCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
       bannerCell.delegate = self;
       [bannerCell reloadBannerData];
        return bannerCell;
       
       
   }else if ([NSStringFromClass([YMFinancialClassCell class]) isEqualToString:dic[@"itemCell"]] )
   {
       YMFinancialClassCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.classImageStr = self.classImageArray[indexPath.row];
        return cell;
       
   }else if ([NSStringFromClass([YMFinancialListCell class]) isEqualToString:dic[@"itemCell"]] )
   {
       YMFinancialListCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
       cell.model = model;
        return cell;
       
   }else if ([NSStringFromClass([YMMobileCollectionViewCell_phone class]) isEqualToString:dic[@"itemCell"]] )
   {
       YMMobileCollectionViewCell_phone * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
       cell.model = model;
       cell.delegate = self;
       return cell;
   }else if ([NSStringFromClass([YMMobileCollectionViewCell_money class]) isEqualToString:dic[@"itemCell"]] )
   {
       YMMobileCollectionViewCell_money * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
       cell.model = model;
       
       return cell;
   }else if ([NSStringFromClass([YMAllCollectionViewCell class]) isEqualToString:dic[@"itemCell"]] )
   {
       YMAllCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
       cell.model = model;
       
       return cell;
   }
    
    
    
    return  nil;
   
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath//定义每个Item 的大小
{

    NSDictionary * dic = self.allArr[indexPath.section];
    NSInteger column = [dic[@"column"] integerValue];
    float multipliedBy = [dic[@"multipliedBy"] floatValue];
    
    NSInteger left   = [dic[@"margin-left"] intValue];
    NSInteger right  = [dic[@"margin-right"] intValue];
    
    CGFloat w=(SCREENWIDTH-1-left-right)/column;
    CGFloat h=w*multipliedBy;
    return CGSizeMake(w, h);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section//定义每个UICollectionView 的 margin
{
    NSDictionary * dic = self.allArr[section];
    NSInteger top    = [dic[@"margin-top"] intValue];
    NSInteger left   = [dic[@"margin-left"] intValue];
    NSInteger bottom = [dic[@"margin-bottom"] intValue];
    NSInteger right  = [dic[@"margin-right"] intValue];
    
    return UIEdgeInsetsMake(top, left, bottom, right);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{//cell之间的行间距

    NSDictionary * dic = self.allArr[section];
    if ([NSStringFromClass([YMFinancialClassCell class]) isEqualToString:dic[@"itemCell"]] )
    {
        
        return 1;
        
    }else
    {
        
        return 0;
        
    }

    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    

    NSDictionary * dic = self.allArr[indexPath.section];
  
    
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        NSString * viewForSectionHeaderName = dic[@"sectionHeader"];
        if (viewForSectionHeaderName.length > 0) {
//            Class headerCl = NSClassFromString(viewForSectionHeaderName);
            UICollectionReusableView * headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewForSectionHeaderName forIndexPath:indexPath];
            return headerView;

        }
        /*
        if (viewType == TYPE_LIST) {
            YMFinancialListHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TYPE_LISTHEADER forIndexPath:indexPath];
            return headerView;
        }
         */
    }else if (kind == UICollectionElementKindSectionFooter) {
        
            NSString * viewForSectionFooterName = dic[@"sectionFooter"];
            if (viewForSectionFooterName.length > 0) {
              
                UICollectionReusableView * footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:viewForSectionFooterName forIndexPath:indexPath];
                return footerView;
                
            }
        
        /*
        if (viewType != TYPE_LIST) {
            YMSpecReusableView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TYPE_SPEC forIndexPath:indexPath];
            return footerView;
        }
         */
    }

    
    
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    NSDictionary * dic = self.allArr[section];
    float height = [dic[@"sizeForHeader"] floatValue];
    return CGSizeMake(0, SCALEZOOM(height));
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    NSDictionary * dic = self.allArr[section];
    float height = [dic[@"sizeForFooter"] floatValue];
    return CGSizeMake(0, SCALEZOOM(height));
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *viewType = [self getViewType:indexPath.section row:indexPath.row];
//    if (viewType == TYPE_CLASS) {
//        YMLog(@"select class index = %ld ",indexPath.row);
//    }else if (viewType == TYPE_LIST){
//        YMLog(@"select list index = %ld ",indexPath.row);
//    }
    NSDictionary * dic = self.allArr[indexPath.section];
    NSArray * arr = dic[@"function"];
    if ([self.delegate respondsToSelector:@selector(selectItemWithModel:)]) {
        [self.delegate selectItemWithModel:arr[indexPath.item]];
    }
}

#pragma mark - getters and setters          - Method -
- (NSMutableArray *)classImageArray
{
    if (!_classImageArray) {
        _classImageArray = [[NSMutableArray alloc] initWithObjects:@"financial_1-1",@"financial_1-2",@"financial_1-3",@"financial_1-4", nil];
    }
    return _classImageArray;
}
//拓展
-(void)setRegisterCellArr:(NSArray *)registerCellArr
{
    
    if (registerCellArr.count == 0) return;
    for (int i= 0; i<registerCellArr.count; i++) {
       
        NSDictionary * dic = registerCellArr[i];
        if ([dic[@"isXib"] boolValue]) {
            UINib *bannerNib = [UINib nibWithNibName:dic[@"name"] bundle:nil];
            [self.collectionView registerNib:bannerNib forCellWithReuseIdentifier:dic[@"name"]];
        }else
        {
             [self.collectionView registerClass:NSClassFromString(dic[@"name"]) forCellWithReuseIdentifier:dic[@"name"]];
        }
        
    }

    
}
-(void)setRegisterSectionHeaderArr:(NSArray *)registerSectionHeaderArr
{
    _registerSectionHeaderArr = registerSectionHeaderArr;
    if (registerSectionHeaderArr.count == 0) return;
    
    for (int i= 0; i<registerSectionHeaderArr.count; i++) {
    
        NSDictionary * dic = registerSectionHeaderArr[i];
        if ([dic[@"isXib"] boolValue]) {
            UINib *listHeaderNib = [UINib nibWithNibName:dic[@"name"] bundle:nil];
            [self.collectionView registerNib:listHeaderNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dic[@"name"]];
        }else
        {
             [self.collectionView registerClass:NSClassFromString(dic[@"name"]) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:dic[@"name"]];
        }
        
        
    }
   

}
-(void)setRegisterSectionFooterArr:(NSArray *)registerSectionFooterArr
{
    _registerSectionFooterArr = registerSectionFooterArr;
    if (registerSectionFooterArr.count == 0) return;
    
    for (int i= 0; i<registerSectionFooterArr.count; i++) {

        NSDictionary * dic = registerSectionFooterArr[i];
        if ([dic[@"isXib"] boolValue]) {
            UINib *specNib = [UINib nibWithNibName:dic[@"name"] bundle:nil];
            [self.collectionView registerNib:specNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dic[@"name"]];
        }else
        {
            [self.collectionView registerClass:NSClassFromString(dic[@"name"]) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:dic[@"name"]];
        }
        
    }
    
    
}
-(void)setAllArr:(NSArray *)allArr
{
    _allArr = allArr;
    [self.collectionView reloadData];
}

/**
 点击 通讯录 按钮代理
 */
-(void)toSystemContactVC
{
    if ([self.delegate respondsToSelector:@selector(presentContactViewController)]) {
        [self.delegate presentContactViewController];
    }
}

/**
 请求手机充值接口 返回可充值的金额

 @param phoneNum 手机充值接口回调
 */
-(void)startRequestMobileApi:(NSString *)phoneNum
{
    if ([self.delegate respondsToSelector:@selector(requestMobileApi:)]) {
        [self.delegate requestMobileApi:phoneNum];
    }
}
@end
