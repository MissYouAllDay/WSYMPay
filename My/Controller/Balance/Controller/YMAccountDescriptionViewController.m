//
//  YMGradesDetailsViewController.m
//  WSYMPay
//
//  Created by W-Duxin on 2016/12/8.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "YMAccountDescriptionViewController.h"
#import "YMAccountGradesView.h"
#import "UIView+Extension.h"
#import "YMPublicHUD.h"
@interface YMAccountDescriptionViewController ()<UIAlertViewDelegate>
@property (nonatomic, weak) UILabel *warningLabel;

@end

@implementation YMAccountDescriptionViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

-(void)setupSubviews
{
    self.tableView.backgroundColor = VIEWGRAYCOLOR;
    self.navigationItem.title = @"账户分类说明";
    
    NSString *warningText = @"根据中国人民银行监管办法，支付账户包含三类,且同一个人在同一家支付机构只能开立一个Ⅲ类账户，具体如下（快捷支付和网银支付不受此条款限额约束)";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:warningText];
    
    [attributedString addAttributes:[self setFontStyle] range:NSMakeRange(0, warningText.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfMutableSize:12] range:NSMakeRange(0, attributedString.length)];
    
    UILabel *warningLabel       = [[UILabel alloc]init];
    warningLabel.textColor      = FONTCOLOR;
    warningLabel.numberOfLines  = 0;
    warningLabel.attributedText = attributedString;
    CGSize size                 = CGSizeMake(SCREENWIDTH * 0.9,MAXFLOAT);
    warningLabel.size = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    [self.tableView addSubview:warningLabel];
    self.warningLabel = warningLabel;
    
    //客服电话
    UILabel*tel         = [UILabel new];
    tel.backgroundColor = [UIColor clearColor];
    tel.font            = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12.0]];
    tel.text            = @"客服电话 : 4000-191-077";
    tel.alpha           = 1;
    tel.userInteractionEnabled = YES;
    tel.textColor       = FONTCOLOR;
    [self.view addSubview:tel];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [tel addGestureRecognizer:tap];
    
    [tel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(SCREENHEIGHT - (SCREENWIDTH * ROWProportion) -5);
        make.height.mas_equalTo((SCREENWIDTH * ROWProportion));
        
    }];
}

-(NSDictionary *)setFontStyle
{
    NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple           = 1.5;//调整行间距
    paragraphStyle.lineBreakMode                = NSLineBreakByCharWrapping;
    paragraphStyle.paragraphSpacing             = 0;//段落后面的间距
    paragraphStyle.paragraphSpacingBefore       = 0;//段落之前的间距
    paragraphStyle.alignment                    = NSTextAlignmentLeft;
    return @{NSParagraphStyleAttributeName:paragraphStyle};
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *ID = @"cell";
    
    YMAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[YMAccountDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSString *classText =nil;
    NSString *topText  = nil;
    NSString *bottomText  = nil;
    
    if (indexPath.row == 0) {
        
        classText  = @"I类";
        topText    = @"I类账户余额支付额度1000元/终身";
        bottomText = @"账户余额可用来消费、转账、提现占用额度";
    }
    
    if (indexPath.row == 1) {
        classText  = @"II类";
        topText    = @"II类账户余额支付额度10万元/年";
        bottomText = @"账户余额可用来消费、转账";
    }
    
    if (indexPath.row == 2) {
        classText  = @"III类";
        topText    = @"III类账户余额支付额度20万元/年";
        bottomText = @"账户余额可用来消费、转账、购买理财";
        
        CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
        self.warningLabel.centerX = rect.size.width / 2;
        self.warningLabel.y       = CGRectGetMaxY(rect) + HEADERSECTION_HEIGHT;
    }

    cell.classTitle = classText;
    cell.topText    = topText;
    cell.bottomText = bottomText;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREENHEIGHT * 0.15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.topView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.topView.hidden = NO;

}
-(void)tapAction
{
    WEAK_SELF;
    [YMPublicHUD showAlertView:nil message:@"4000-191-077" cancelTitle:@"取消" confirmTitle:@"确定" cancel:nil confirm:^{
        [weakSelf callServicePhone];
    }];
}

-(void)callServicePhone
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://4000191077"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4000191077"]];
    } else {
        [YMPublicHUD showAlertView:nil message:@"暂不能拨打电话" cancelTitle:@"确定" handler:nil];
    }
}
@end




#pragma mark - 等级详情cell

@interface YMAccountDetailCell ()

@property (nonatomic, weak) UILabel *classLabel;

@property (nonatomic, weak) UILabel *topLabel;

@property (nonatomic, weak) UILabel *bottomLabel;

@end

@implementation YMAccountDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.image   = [UIImage imageNamed:@"level"];
        self.selectionStyle                = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    
    return self;
}

-(void)setupSubViews
{
    UILabel *classLabel  = [[UILabel alloc]init];
    classLabel.textColor = FONTDARKCOLOR;
    classLabel.font      = COMMON_FONT;
    classLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:classLabel];
    self.classLabel = classLabel;
    
    UILabel *topLabel  = [[UILabel alloc]init];
    topLabel.textColor = FONTCOLOR;
    topLabel.font      = [UIFont systemFontOfMutableSize:13];
    topLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:topLabel];
    self.topLabel = topLabel;
    
    UILabel *bottomLabel  = [[UILabel alloc]init];
    bottomLabel.textColor = FONTCOLOR;
    bottomLabel.font      = [UIFont systemFontOfMutableSize:13];
    bottomLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:bottomLabel];
    self.bottomLabel = bottomLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = (self.height - self.bottomLabel.height - self.classLabel.height - self.topLabel.height)/4;
    
    self.imageView.x = LEFTSPACE;
    self.imageView.centerY = self.height / 2;
    
    self.classLabel.x = self.imageView.right + LEFTSPACE;
    self.classLabel.y = margin;
    
    self.topLabel.x = self.classLabel.x;
    self.topLabel.y = self.classLabel.bottom + margin;
    
    self.bottomLabel.x = self.classLabel.x;
    self.bottomLabel.y = self.topLabel.bottom + margin;
}

-(void)setClassTitle:(NSString *)classTitle
{
    _classTitle = [classTitle copy];
    self.classLabel.text = _classTitle;
    [self.classLabel sizeToFit];

}

-(void)setTopText:(NSString *)topText
{
    _topText = [topText copy];
    self.topLabel.text = _topText;
    [self.topLabel sizeToFit];

}
-(void)setBottomText:(NSString *)bottomText
{
    _bottomText = [bottomText copy];
    self.bottomLabel.text = _bottomText;
    [self.bottomLabel sizeToFit];
}

@end
