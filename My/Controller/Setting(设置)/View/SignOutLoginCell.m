//
//  SignOutLoginCell.m
//  WSYMPay
//
//  Created by W-Duxin on 16/9/20.
//  Copyright © 2016年 赢联. All rights reserved.
//

#import "SignOutLoginCell.h"

@implementation SignOutLoginCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType  = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = RGBColor(202, 48, 45);
    }

    return self;
}




@end
