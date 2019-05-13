//
//  AddCardDetailViewController.m
//  WSYMPay
//
//  Created by MaKuiying on 16/9/22.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "AddCardDetailViewController.h"
#import "YMProtocolButton.h"
#import "DatePickerView.h"
#import "ProtocolViewController.h"
#import "VerificationCodeViewController.h"
#import "YMRedBackgroundButton.h"
#import "YMUserInfoTool.h"
#import "YMResponseModel.h"
#import "YMBankCardModel.h"
#import "UITextField+Extension.h"
#import "YMIDTextField.h"
@interface AddCardDetailViewController ()<UITableViewDataSource,UITableViewDelegate,YMProtocolButtonDelegate,UITextFieldDelegate>

@property (nonatomic, strong) VerificationCodeViewController* verificationVC;

@end

@implementation AddCardDetailViewController{
    
    UITableView    *addTableView;
    UITextField    *CardholderTF;//持卡人
    UITextField    *ExpiryTF; //有效期
    UITextField    *mobilTF; //手机号
    UITextField    *securityTF; //安全码
    UIImageView    *tickImageView;
    YMIDTextField  *IDTF; //身份证
    YMRedBackgroundButton * nextBtn;//下一步按钮
    YMProtocolButton *agreementButton;//同意协议按钮
    NSString* typeCard; //卡类型－信用／储蓄
}

-(VerificationCodeViewController *)verificationVC
{
    if (!_verificationVC) {
        
        _verificationVC = [[VerificationCodeViewController alloc]init];
    }
    return _verificationVC;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VIEWGRAYCOLOR];
    self.title = @"添加银行卡";
    [self loadData];
    [self initViews];
    
}

- (void)loadData{
    
    // 01（借记卡），02（贷记卡） 03 准贷记卡
    if (self.bankCardInfo.cardType == 1) {
        typeCard =@"借记卡";
    }else if (self.bankCardInfo.cardType == 2){
        typeCard = @"信用卡";
    }else if (self.bankCardInfo.cardType == 3){
        typeCard = @"准贷记卡";
    }
    
}
- (void)initViews {
    addTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStyleGrouped];
    addTableView.scrollEnabled = NO;
    addTableView.delegate = self;
    addTableView.dataSource = self;
    [self.view addSubview:addTableView];
    UIView* footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    addTableView.tableFooterView = footView;
    
    UILabel * markL = [UILabel new];
    [footView addSubview:markL];
    markL.font = [UIFont systemFontOfSize:DEFAULTFONT(12)];
    markL.backgroundColor = [UIColor clearColor];
    markL.textColor = [UIColor grayColor];
    markL.text = @"信息加密处理，仅用于银行验证";
    [markL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LEFTSPACE);
        make.right.offset(-RIGHTSPACE);
        make.top.offset(10);
        make.height.offset(22);
    }];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [footView addGestureRecognizer:tap];
    
    agreementButton          = [[YMProtocolButton alloc]init];
    agreementButton.delegate = self;
    agreementButton.selected = YES;
    agreementButton.title    = @"同意《网上有名服务协议》";
//    agreementButton.
    [footView addSubview:agreementButton];
    [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markL.mas_left);
        make.top.equalTo(markL.mas_bottom).offset(3);
        make.height.offset(30);
        make.width.equalTo(self.view.mas_width).multipliedBy(.6);

    }];

     nextBtn = [[YMRedBackgroundButton alloc]init];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
     nextBtn.enabled = NO;
    [nextBtn addTarget:self action:@selector(nextPushVC) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-RIGHTSPACE);
        make.left.offset(LEFTSPACE);
        make.top.equalTo(agreementButton.mas_bottom).offset(LEFTSPACE);
        make.height.offset(SCREENWIDTH*ROWProportion);
    }];

    
}


//验证信息是否全部输入
-(void)textFieldChanged:(NSNotification *) note
{
    UITextField * textF =  note.object;
    NSString * userContent = CardholderTF.text;
    NSString* passContent = IDTF.text;
    NSString* mobilCentent = mobilTF.text;
    NSString* secrityCentent= securityTF.text;
    if (self.bankCardInfo.cardType == 02||self.bankCardInfo.cardType == 03) {
        if (textF == securityTF){
            if (securityTF.text.length > 3) {
                textF.text = [textF.text substringToIndex:3];
            }
            if (mobilCentent.length >0 && secrityCentent.length >0) {
                nextBtn.enabled = YES;
            }else{
                nextBtn.enabled = NO;
            }
        }else if (textF == CardholderTF){
            nextBtn.enabled = YES;
            
        }else if (textF == IDTF){
            nextBtn.enabled = YES;
            
        }else if (textF == mobilTF){
            if (mobilCentent.length >0 ) {
                nextBtn.enabled = YES;
                
            }else{
                nextBtn.enabled = NO;
            }
            if ( mobilCentent.length > 0) {
                textF.text = [VUtilsTool MobilePhoneFormat:mobilCentent];
                if (textF.text.length > 13) {
                    textF.text = [textF.text substringToIndex:13];
                }
                
            }
        }
    }else if (self.bankCardInfo.cardType == 01){
       if (textF == CardholderTF) {
            if (userContent.length > 0 && passContent.length >0 && mobilCentent.length >0) {
                nextBtn.enabled = YES;
                
            }else{
                nextBtn.enabled = NO;
            }
           nextBtn.enabled = YES;
    }else if (textF == IDTF){
        if (IDTF.text.length > 18) {
            textF.text = [textF.text substringToIndex:18];
        }
        if (passContent.length > 0 && userContent.length >0 && mobilCentent.length >0) {
            nextBtn.enabled = YES;
        }else{
            nextBtn.enabled = NO;
        }
        nextBtn.enabled = YES;
        }else if (textF == mobilTF){
            if (mobilCentent.length >0 ) {
                nextBtn.enabled = YES;
                
            }else{
                nextBtn.enabled = NO;
            }
            if ( mobilCentent.length > 0) {
                if (textF.text.length > 13) {
                    textF.text = [textF.text substringToIndex:13];
                }
            }
        }
    }
}


//下一界面
- (void)nextPushVC{
    
    [self hideKeyboard];
    NSString* mobilStr = mobilTF.text;
    mobilStr = [mobilStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if ( [VUtilsTool validateIdentityCard:IDTF.text]== NO ) {
//        [MBProgressHUD showText:@"身份证输入有误,请检查后重新输入"];
//        return;
//    }
 
    if (!mobilStr.isValidateMobile) {
        [MBProgressHUD showText:@"手机号正确,请重新输入"];
        return;
    }
    
    if (self.bankCardInfo.cardType == 02|| self.bankCardInfo.cardType == 03) {
        if (ExpiryTF.text.length == 0) {
            [MBProgressHUD showText:@"请选择有效期"];
            return;
        }
    }
    
    if (self.bankCardInfo.cardType == 02|| self.bankCardInfo.cardType == 03) {
        if (securityTF.text.length == 0) {
            [MBProgressHUD showText:@"请输入安全码"];
            return;
        }
    }
    
    if (agreementButton.selected == false) {
        [MBProgressHUD showText:@"请同意服务协议"];
        return;
    }
    
//    if (![CardholderTF.text isNameValid]) {
//        [MBProgressHUD showText:@"姓名不合法,请重新输入"];
//        return;
//    }
//
    [self getbankVerifyCodeURL];
 
}

//请求验证码接口
-(void)getbankVerifyCodeURL{
    
    
    RequestModel *params = [[RequestModel alloc]init];
    params.token         = [YMUserInfoTool shareInstance].token;
    params.bankPreMobile = [mobilTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *bankNo = [[NSMutableString alloc] initWithString:self.bankCardInfo.bankAcNo];
    NSString *bankNum = [bankNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    params.cardNo      =  bankNum;
    params.tranCode      = JUDEMENTSETPAYPWD;
    [MBProgressHUD showMessage:@"正在验证"];
        
    [[YMHTTPRequestTool shareInstance]POST:BASEURL parameters:params success:^(id responseObject) {
        YMLog(@"%@",responseObject);
        
        YMResponseModel *m = [YMResponseModel loadModelFromDic:responseObject];
        
        if (m.resCode == 1 || m.resCode == 48 || m.resCode == 36) {
            
            [MBProgressHUD hideHUD];
            self.verificationVC.bankPreMobil = [mobilTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];//手机号
            self.verificationVC.cardName     = CardholderTF.text; // 持卡人姓名
            self.verificationVC.idCardNum    = IDTF.text; //身份证
            self.verificationVC.cardDeadline = ExpiryTF.text;//有效期
            self.verificationVC.bankCardInfo = self.bankCardInfo;
            self.verificationVC.safetyCode   = securityTF.text;
            self.verificationVC.isDebitCard  = self.bankCardInfo.cardType == 1;
            self.verificationVC.resCode      = m.resCode;
            NSDictionary *dic = m.data ;
            
            self.verificationVC.chaneel_short = dic[@"chaneel_short"];
            self.verificationVC.trxId = dic[@"trxId"];
            self.verificationVC.trxDtTm = dic[@"trxDtTm"];
            self.verificationVC.smskey = dic[@"smskey"];
            self.verificationVC.wl_url = dic[@"wl_url"];

            if (m.resCode == 48) {
                [YMUserInfoTool shareInstance].payPwdStatus = -1;
                self.verificationVC .isSendVCode = NO;
                
            } else {
                
                self.verificationVC .isSendVCode = YES;
                [MBProgressHUD showText:m.resMsg];
            }
            
            [self.navigationController pushViewController:self.verificationVC  animated:YES];
            
        } else {
            
            [MBProgressHUD showText:m.resMsg];
        }

    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark-UITextField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == mobilTF) {
       return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}
#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //  01（借记卡），02（贷记卡）
    if (self.bankCardInfo.cardType == 02 || self.bankCardInfo.cardType == 03) {
        if (section == 0) {
            return 2;
        }else if (section == 1){
            return 3;
        }
    }else if (self.bankCardInfo.cardType == 01){//储蓄卡
        if (section == 0) {
            return 3;
        }
    }
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 01（借记卡），02（贷记卡）
        if (self.bankCardInfo.cardType == 02 || self.bankCardInfo.cardType == 03) {
            if (indexPath.section == 0) {//第一组
                if (indexPath.row == 0) {//第一行
                    
                    NSString *str = [NSString stringWithFormat:@"%@ %@",self.bankCardInfo.bankName,typeCard];
                    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfMutableSize:14] range:[str rangeOfString:self.bankCardInfo.bankName]];
                    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfMutableSize:11] range:[str rangeOfString:typeCard]];
                    
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"发卡行";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    CardholderTF = [UITextField new];
                    CardholderTF.backgroundColor = [UIColor whiteColor];
                    CardholderTF.attributedText = attrStr;
                    CardholderTF.leftView = label;
                    CardholderTF.enabled = NO;
                    CardholderTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:CardholderTF];
                    [CardholderTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
                
                }else{//第二行
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"持卡人";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    CardholderTF = [UITextField new];
                    CardholderTF.backgroundColor = [UIColor whiteColor];
                    CardholderTF.placeholder = @"输入持卡人姓名";
                    [CardholderTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
                    CardholderTF.leftView = label;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:CardholderTF];
                    CardholderTF.keyboardType = UIKeyboardTypeDefault;
                    CardholderTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:CardholderTF];
                    [CardholderTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
                }
            }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"身份证";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    IDTF = [[YMIDTextField alloc]init];
                    IDTF.backgroundColor = [UIColor whiteColor];
                    IDTF.placeholder = @"输入持卡人本人身份证号";
                    [IDTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
                    IDTF.leftView = label;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:IDTF];
                    IDTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:IDTF];
                    [IDTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
                }else if (indexPath.row == 1){
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"有效期";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    ExpiryTF = [UITextField new];
                    ExpiryTF.userInteractionEnabled = NO;
                    ExpiryTF.backgroundColor = [UIColor whiteColor];
                    ExpiryTF.placeholder = @"月份/年份";
                    [ExpiryTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
                    ExpiryTF.leftView = label;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:ExpiryTF];
                    
                    ExpiryTF.keyboardType = UIKeyboardTypeNumberPad;
                    ExpiryTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:ExpiryTF];
                    [ExpiryTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
 
                }else{
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"安全码";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    securityTF = [UITextField new];
                    securityTF.backgroundColor = [UIColor whiteColor];
                    securityTF.placeholder = @"卡背面末3位";
                    [securityTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
                    securityTF.leftView = label;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:securityTF];
                    //            mobilTF.delegate = self;
                    securityTF.keyboardType = UIKeyboardTypeNumberPad;
                    securityTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:securityTF];
                    [securityTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
                }
            }else{
                UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                label.text = @"手机号";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor lightGrayColor];
                label.font = [UIFont systemFontOfMutableSize:14];
                mobilTF = [[UITextField alloc]init];
                mobilTF.delegate = self;
                mobilTF.backgroundColor = [UIColor whiteColor];
                mobilTF.placeholder = @"输入银行预留手机号";
                [mobilTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
                mobilTF.leftView = label;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:mobilTF];
                mobilTF.keyboardType = UIKeyboardTypeNumberPad;
                mobilTF.leftViewMode = UITextFieldViewModeAlways;
                [cell.contentView addSubview:mobilTF];
                [mobilTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.width.equalTo(cell.contentView.mas_width);
                    make.height.equalTo(cell.contentView.mas_height);
                }];
            }
         //01（借记卡），02（贷记卡）
        }else if (self.bankCardInfo.cardType == 01){
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    NSString *str = [NSString stringWithFormat:@"%@ %@",self.bankCardInfo.bankName,typeCard];
                    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
                    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfMutableSize:14] range:[str rangeOfString:self.bankCardInfo.bankName]];
                    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfMutableSize:11] range:[str rangeOfString:typeCard]];
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"发卡行";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    CardholderTF = [UITextField new];
                    CardholderTF.backgroundColor = [UIColor whiteColor];
                    CardholderTF.attributedText = attrStr;
                    CardholderTF.leftView = label;
                    CardholderTF.enabled = NO;
                    CardholderTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:CardholderTF];
                    [CardholderTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
                }else if (indexPath.row == 1){
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"持卡人";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    CardholderTF = [UITextField new];
                    CardholderTF.backgroundColor = [UIColor whiteColor];
                    CardholderTF.placeholder = @"输入持卡人姓名";
                    [CardholderTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
                    CardholderTF.leftView = label;
                    //            mobilTF.delegate = self;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:CardholderTF];
                    CardholderTF.keyboardType = UIKeyboardTypeDefault;
                    CardholderTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:CardholderTF];
                    [CardholderTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
                }else{
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                    label.text = @"身份证";
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfMutableSize:14];
                    IDTF = [[YMIDTextField alloc]init];
                    IDTF.backgroundColor = [UIColor whiteColor];
                    IDTF.placeholder = @"输入持卡人本人身份证号";
                    [IDTF setValue:[UIFont systemFontOfMutableSize:14]forKeyPath:@"_placeholderLabel.font"];
                    IDTF.leftView = label;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:IDTF];
                    IDTF.leftViewMode = UITextFieldViewModeAlways;
                    [cell.contentView addSubview:IDTF];
                    [IDTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.offset(0);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.width.equalTo(cell.contentView.mas_width);
                        make.height.equalTo(cell.contentView.mas_height);
                    }];
                }
            }else{
                UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
                label.text = @"手机号";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor lightGrayColor];
                label.font = [UIFont systemFontOfMutableSize:14];
                mobilTF = [[UITextField alloc]init];
                mobilTF.delegate = self;
                mobilTF.backgroundColor = [UIColor whiteColor];
                mobilTF.placeholder = @"输入银行预留手机号";
                [mobilTF setValue:[UIFont systemFontOfMutableSize:14] forKeyPath:@"_placeholderLabel.font"];
                mobilTF.leftView = label;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:mobilTF];
                mobilTF.keyboardType = UIKeyboardTypeNumberPad;
                mobilTF.leftViewMode = UITextFieldViewModeAlways;
                [cell.contentView addSubview:mobilTF];
                [mobilTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.width.equalTo(cell.contentView.mas_width);
                    make.height.equalTo(cell.contentView.mas_height);
                }];
            }
        }
    }
    cell.clipsToBounds = YES;
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 01（借记卡），02（贷记卡） 03准贷记卡
    if (self.bankCardInfo.cardType == 02||self.bankCardInfo.cardType == 03) {
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
                DatePickerView *view = [[DatePickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                
                [view strYearMonth:^(NSString *strTM) {
                    YMLog(@"选中的值---%@",strTM);
                    ExpiryTF.text = strTM;
                }];
                
                [self.view addSubview:view];
                [tableView reloadData];
            }
        }
    }
    
}

#pragma mark-
#pragma mark- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //1 -信用卡3组
    if (self.bankCardInfo.cardType == 02||self.bankCardInfo.cardType == 03) {
        return 3;
        
    } else {//储蓄卡2组
    
        return 2;
    }
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //  01（借记卡），02（贷记卡）
    if (self.bankCardInfo.cardType == 02 || self.bankCardInfo.cardType == 03) {
        if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 1 && indexPath.row == 0)) {
            return 0;
        }
    }else if (self.bankCardInfo.cardType == 01){//储蓄卡
        if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 0 && indexPath.row == 2)) {
            return 0;
        }
    }
    CGFloat cellH = SCREENWIDTH* ROWProportion;
    return cellH;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
    
}

//键盘
- (void)hideKeyboard{
    [CardholderTF resignFirstResponder];//持卡人
    [IDTF resignFirstResponder]; //身份证
    [ExpiryTF resignFirstResponder]; //有效期
    [mobilTF resignFirstResponder]; //手机号
    [securityTF resignFirstResponder];
    
}

-(void)protocolButtonImageBtnSelected:(YMProtocolButton *)agBtn{
    
  
    NSString * userContent = CardholderTF.text;
    NSString* passContent = IDTF.text;
    NSString* mobilCentent = mobilTF.text;
    NSString* secrityCentent= securityTF.text;
    if (self.bankCardInfo.cardType == 02||self.bankCardInfo.cardType == 03) {
       
        if (passContent.length > 0 && userContent.length >0 && mobilCentent.length >0 && secrityCentent.length >0 && agreementButton.isSelected) {
                nextBtn.enabled = YES;
            }else{
                nextBtn.enabled = NO;
            }
       
    }else if (self.bankCardInfo.cardType == 01){
       
        if (userContent.length > 0 && passContent.length >0 && mobilCentent.length >0 && agreementButton.isSelected) {
                nextBtn.enabled = YES;
                
            }else{
                nextBtn.enabled = NO;
            }
    }
}

-(void)protocolButtonTitleBtnDidClick:(YMProtocolButton *)agBtn{
    
    [self protocolTap];
}

//协议
- (void)protocolTap{
    
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc]init];
    WEAK_SELF;
    protocolVC.block = ^(){
        agreementButton.selected = YES;
        [weakSelf protocolButtonImageBtnSelected:nil];
    };
    
    [self.navigationController pushViewController:protocolVC animated:YES];
}


-(void)dealloc
{
    [WSYMNSNotification removeObserver:self];
}

@end
