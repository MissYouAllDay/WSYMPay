//
//  VersionNotesViewController.h
//  WSYMPay
//
//  Created by jey on 2019/5/4.
//  Copyright © 2019 赢联. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface versionModel : NSObject
@property (nonatomic,copy) NSString *ymqbURL;
@property (nonatomic,copy) NSString *ymqbURL_ios;
@property (nonatomic,copy) NSString *ymqbVerStatus;
@property (nonatomic,copy) NSString *ymqb_ver_ios;
@end
@interface VersionNotesViewController : UITableViewController

@end

NS_ASSUME_NONNULL_END
