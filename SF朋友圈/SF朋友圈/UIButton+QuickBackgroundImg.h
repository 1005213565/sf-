//
//  UIButton+QuickBackgroundImg.h
//  OA
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIButton(QuickBackgroundImg)
/*! 根据颜色同时设置背景图片和高亮背景图片 */
-(void)setBackgroundImageWithColor:(UIColor*)color;

/*! 设置普通状态下的按钮背景图 */
- (void)setBackgroundImageNomalStateWithColor:(UIColor *)color;

/*! 设置高亮状态下按钮背景图 */
- (void)setBackgroundImageHighlightStateWithColor:(UIColor *)color;
@end
