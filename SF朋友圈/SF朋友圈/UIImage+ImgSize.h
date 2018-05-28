//
//  UIImage+ImgSize.h
//  CDDStoreDemo
//
//  Created by fly on 2018/5/25.
//  Copyright © 2018年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImgSize)

/// 根据url获取图片大小
+ (CGSize) getImageSizeWithUrl:(id)URL;

@end
