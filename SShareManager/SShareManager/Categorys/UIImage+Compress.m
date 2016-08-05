//
//  UIImage+Compress.m
//  SShareManager
//
//  Created by tongxuan on 16/8/4.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

+ (NSData *)zipImageWithImage:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    CGFloat maxFileSize = 30*1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    while ([compressedData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        compressedData = UIImageJPEGRepresentation(image, compression);
    }
    return compressedData;
}

@end
