//
//  YMTransferToYmWalletTool.m
//  WSYMPay
//
//  Created by pzj on 2017/4/28.
//  Copyright © 2017年 赢联. All rights reserved.
//

#import "YMTransferToYmWalletTool.h"
#import "YMRedBackgroundButton.h"
#import "YMGetUserInputCell.h"
#import "UITextField+Extension.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <Contacts/Contacts.h>
#import <Contacts/ContactsDefines.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/ContactsUI.h>
#
@interface YMTransferToYmWalletTool ()<UITextFieldDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) YMRedBackgroundButton *nextBtn;
@property (nonatomic, copy) NSString *phoneNumber;

@end

@implementation YMTransferToYmWalletTool
- (void)selectNextSearchAccount:(NSString *)account{}
#pragma mark - lifeCycle                    - Method -
- (instancetype)initWithTableView
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - privateMethods               - Method -
-(UIButton *)addressBookButton
{
    UIButton *accessoryButton = [[UIButton alloc]init];
    [accessoryButton setImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [accessoryButton addTarget:self action:@selector(addressBookButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [accessoryButton sizeToFit];
    return accessoryButton;
}

//通讯录授权
- (BOOL)accessTheAddress
{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            if (error) {
                NSLog(@"Error:%@",(__bridge NSError *)error);
            }else if (!granted){
                
            }else{
                accessGranted = YES;
            }
        });
    }else if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized){
        accessGranted = YES;
    }else{
        NSLog(@"用户未授权提示");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有开启授权" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }
    return accessGranted;
}

//获取通讯录里的号码
- (void)getAddressBookNumber
{
    if (System_Version >= 9.0) {
        CNContactPickerViewController *con = [[CNContactPickerViewController alloc] init];
        con.delegate = self;
        [self.vc presentViewController:con animated:YES completion:nil];
    }else{
        ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
        nav.peoplePickerDelegate = self;
        if (System_Version>=8.0&&System_Version<9.0) {
            nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            [self.vc presentViewController:nav animated:YES completion:nil];
        }
    }
}

#pragma mark - eventResponse                - Method -
- (void)nextBtnClick//下一步。。。
{
    
    [self.vc.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(selectNextSearchAccount:withType:)]) {
        [self.delegate selectNextSearchAccount:self.countTextField.text.clearSpace withType:self.type];
    }
}
- (void)labelTapAction{
    [self.vc.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(tipOfDefraudAction)]) {
        [self.delegate tipOfDefraudAction];
    }
}
- (void)addressBookButtonClick
{//通讯录。。。
    [self.vc.view endEditing:YES];
    if ([self accessTheAddress]) {
        [self getAddressBookNumber];
    }
}

- (void)selectAddressBook:(NSString *)phoneNumber
{//选择通讯录中的电话
    self.phoneNumber = phoneNumber;
    self.countTextField.text = self.phoneNumber.MobilePhoneFormat;
    [self textFieldDidEditingChange:self.countTextField];
}
-(void)textFieldDidEditingChange:(UITextField *)textField
{
    if (self.countTextField.text.length
        && [self.countTextField.text clearSpace].length >= 1) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}
#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellID = @"YMGetUserInputCell";
        YMGetUserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[YMGetUserInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            [cell.userInputTF addTarget:self action:@selector(textFieldDidEditingChange:) forControlEvents:UIControlEventEditingChanged];
        }
        cell.leftTitle   = @"对方账号";
        cell.userInputTF.placeholder  = @"请输入有名钱包账号/手机号";
        cell.userInputTF.keyboardType = UIKeyboardTypeNumberPad;
        cell.userInputTF.delegate     = self;
        cell.accessoryView            = [self addressBookButton];
        cell.isSetWidth               = YES;
        cell.userInputTF.text = self.accountString;
        self.countTextField          = cell.userInputTF;
        self.nextBtn.enabled = self.accountString.length>0?YES:NO;
        return cell;
    }
    else{
        static NSString *CellID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
            cell.textLabel.text = @"到账方式";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.detailTextLabel.text = @"实时到账";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREENWIDTH * ROWProportion;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERSECTION_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section==0?10:30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = VIEWGRAYCOLOR;
    if (section==1) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor redColor];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:[VUtilsTool fontWithString:12.0]];
        label.text = @"防范电信网络新型违法犯罪提示";
        [footView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, LEFTSPACE, 0, RIGHTSPACE));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapAction)];
        [label addGestureRecognizer:tap];
    }
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"到账方式"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"实时到账" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.type = @"0";
            cell.detailTextLabel.text = @"实时到账";
        }];
        UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"次日到账" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.type = @"1";
            cell.detailTextLabel.text = @"次日到账";
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
        [alertController addAction:button1];
        [alertController addAction:button2];
        [alertController addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
    }
}
//通讯录相关
//获取电话号码iOS9以上
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"%@",contactProperty.value);
    CNPhoneNumber *str = contactProperty.value;
    if ([str isKindOfClass:[CNPhoneNumber class]]) {
        NSString *phone = [str.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        YMLog(@" 电话号码 = %@",phone);
        //返回电话号码
        [self selectAddressBook:phone];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//获取电话号码（iOS8）
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phoneNumber = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phoneNumber, identifier);
    NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumber, index);
    if ([phone hasPrefix:@"+"]) {
        phone = [phone substringFromIndex:3];
    }
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    YMLog(@"电话号码 ---- %@",phone);
    if (phoneNumber) {
        //返回电话号码
        [self selectAddressBook:phone];
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSLog(@"跳转 --- ");
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

//取消选择（i0S9以上）
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消选择（<iOS8）
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        YMLog(@"跳转到手机系统设置界面");
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
        }
    }
}
#pragma mark - getters and setters          - Method -
- (YMRedBackgroundButton *)nextBtn
{
    if (!_nextBtn) { //下一步按钮
        _nextBtn = [[YMRedBackgroundButton alloc]init];
        _nextBtn.enabled = NO;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tableView addSubview:_nextBtn];
        
        CGFloat w = SCREENWIDTH * 0.9;
        CGFloat h = SCREENWIDTH * ROWProportion;
        CGFloat x = (SCREENWIDTH - w) /2;
        CGFloat y = 90 + (SCREENWIDTH *3*ROWProportion);
//        self.nextBtn.frame = CGRectMake(x, y, w, h);
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y);
            make.left.mas_equalTo(x);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(h);
        }];
    }
    return _nextBtn;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    YMLog(@"_dataArray = %@",_dataArray);
    [self.tableView reloadData];
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    [self nextBtn];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.countTextField) {
        return [UITextField textFieldWithPhoneFormat:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

@end
