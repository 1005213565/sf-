//
//  UILabel+labelSize.h
//  Travel For HuaBin
//
//  Created by henry.y.yang on 16/7/26.
//  Copyright © 2016年 henry.y.yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (labelSize)


/**
*  @author henry.y.yang, 16-07-26 13:07:31
*
*  @return  label的高度
*/
+ (CGFloat)heightOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
width:(CGFloat)width;

/**
 *  @author henry.y.yang, 16-07-26 13:07:31
 *
 *  @param edge the blank size for label's top, left, bottom, right label的上、左、下、右空白大小
 *
 *  @return the height of label label的高度
 */
+ (CGFloat)heightOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
width:(CGFloat)width edge:(UIEdgeInsets)edge;


/**
 *  @author henry.y.yang, 16-07-26 13:07:31
 *
 *  @return the width of label lable的宽度
 */
+ (CGFloat)widthOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
height:(CGFloat)height;


/**
 *  @author henry.y.yang, 16-07-26 13:07:31
 *
 *  @brief Calculate the width according to the text attribute
 *
 *  @return the width of label lable的宽度
 */
+ (CGFloat)widthOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
height:(CGFloat)height edge:(UIEdgeInsets)edge;


@end
