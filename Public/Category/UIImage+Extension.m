//
//  UIImage+Extension.m
//  WX微博
//
//  Created by Jack on 15/10/29.
//  Copyright © 2015年 Jack. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+(UIImage*)stretchableImage:(NSString*)name
{
    UIImage*image=[UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
}
@end
