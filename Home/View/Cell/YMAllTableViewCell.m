//
//  YMAllTableViewCell.m
//  WSYMPay
//
//  Created by Kaifa-guoxiangzhen on 2017/7/19.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMAllTableViewCell.h"
#import "YMAllCollectionViewCell.h"
#import "YMCollectionModel.h"


@interface YMAllTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UIImageView * iconV;
@property (strong, nonatomic) UILabel * titleL;
@property (strong, nonatomic) UIView * headerV;
@property (strong, nonatomic) UICollectionView * collectionView;

@end

@implementation YMAllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerV];
        [self.headerV addSubview:self.iconV];
        [self.headerV addSubview:self.titleL];
        [self.contentView addSubview:self.collectionView];
        
      
        [self.headerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView);
            make.height.mas_equalTo(HEADERSECTIONVIEW_HEIGHT);
        }];
        
        [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(LEFTSPACE);
            make.centerY.mas_equalTo(self.headerV.mas_centerY);
            make.height.mas_equalTo(self.headerV.mas_height).multipliedBy(0.35);
            make.width.mas_equalTo(2);
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconV.mas_right).offset(4);
            make.centerY.mas_equalTo(self.headerV.mas_centerY);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.headerV.mas_bottom);

        }];
        
    }
    
    return self;
}

-(void)setModelArr:(NSArray *)modelArr
{

    _modelArr = modelArr;
    [self.collectionView reloadData];
    
}
-(UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = COMMON_FONT;
        [_titleL sizeToFit];
    }
    return _titleL;
}
-(UIView *)headerV
{
    if (!_headerV) {
      
        _headerV = [UIView new];
        _headerV.backgroundColor = [UIColor whiteColor];
       
        _headerV.layer.borderColor = LAYERCOLOR.CGColor;
        _headerV.layer.borderWidth = 1;
    }

    return _headerV;
}
-(UIImageView *)iconV
{
    if (!_iconV) {
        
        _iconV = [UIImageView new];
        _iconV.image = [UIImage imageNamed:@"home_标题色块1"];
    }
    return _iconV;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        NSLog(@"CollectionHeight:%f",SCREENWIDTH/4);
        
        layout.itemSize = CGSizeMake(SCREENWIDTH/4, SCREENWIDTH/4);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        // self.collectionViewFlowLayout.estimatedItemSize = CGSizeMake(125, 100);
        // self.collectionViewFlowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
       
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[YMAllCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YMAllCollectionViewCell class])];
       

    }
    _collectionView.scrollEnabled = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    return _collectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifer = NSStringFromClass([YMAllCollectionViewCell class]);
    YMAllCollectionViewCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    YMCollectionModel * model = self.modelArr[indexPath.item];
    collectionCell.title = model.title;
    collectionCell.imgName = model.imgName;
    
    return collectionCell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didChangeCell:didSelectItemAtIndexPath:)]) {
        [self.delegate didChangeCell:self didSelectItemAtIndexPath:indexPath];
    }
}
-(void)setTitleStr:(NSString *)titleStr
{
    self.titleL.text = titleStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
