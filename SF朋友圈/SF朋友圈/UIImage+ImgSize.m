//
//  UIImage+ImgSize.m
//  CDDStoreDemo
//
//  Created by fly on 2018/5/25.
//  Copyright © 2018年 RocketsChen. All rights reserved.
//

#import "UIImage+ImgSize.h"
#import <ImageIO/ImageIO.h>

/*!
 
 ImageIO框架提供了读取与写入图片数据的基本方法，使用它可以直接获取到图片文件的内容数据，ImageIO框架中包含6个头文件，其中完成主要功能的是前两个头文件中定义的方法：
 
 1.CGImageSource.h:负责读取图片数据。
 
 2.CGImageDestination.h:负责写入图片数据。
 
 3.CGImageMetadata.h:图片文件元数据类。
 
 4.CGImageProperties:定义了框架中使用的字符串常量和宏。
 
 5.ImageIOBase.h:预处理逻辑，无需关心。
 */
@implementation UIImage (ImgSize)

+ (CGSize)getImageSizeWithUrl:(id)URL {
    
    NSURL *url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        
        url = URL;
    }
    
    if ([URL isKindOfClass:[NSString class]]) {
        
        url = [NSURL URLWithString:URL];
    }
    
    if (!URL) {
        
        return CGSizeZero;
    }
    
    CGImageSourceRef imgSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    
    CGFloat width = 0, height = 0;
    
    if (imgSourceRef) {
        
        /// 获取图像属性
        CFDictionaryRef imgProperties = CGImageSourceCopyPropertiesAtIndex(imgSourceRef, 0, NULL);
        
        /// 以下是对手机32位和64位的处理
        if (imgProperties != NULL) {
            /// kCGImagePropertyPixelWidth获取像素宽
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imgProperties, kCGImagePropertyPixelWidth);
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imgProperties, kCGImagePropertyPixelHeight);
#if defined(__LP64__) && __LP64__
           
            if (widthNumberRef != NULL) {
                
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            if (heightNumberRef != NULL) {
                
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            
#else
            
            if (widthNumberRef != NULL) {
                
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            if (heightNumberRef != NULL) {
                
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            
            
            /**********************************此处解决返回图片宽高相反的问题**********************************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imgProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) { // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            
            /*********************************此处解决返回图片宽高相反的问题**************************************/
            
            CFRelease(imgProperties);
        }
        
        CFRelease(imgSourceRef);
    }
    
    
    return CGSizeMake(width, height);
}

@end




















