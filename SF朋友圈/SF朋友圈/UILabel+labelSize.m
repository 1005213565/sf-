//
//  UILabel+labelSize.m
//  Travel For HuaBin
//
//  Created by henry.y.yang on 16/7/26.
//  Copyright © 2016年 henry.y.yang. All rights reserved.
//

#import "UILabel+labelSize.h"

#define STRING_IS_NOT_NULL !(string == nil || [string isEqualToString:@""] || [string isEqual:[NSNull null]])

@implementation UILabel (labelSize)

+ (CGFloat)heightOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
                             width:(CGFloat)width {
    if (STRING_IS_NOT_NULL) {
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        
        NSAttributedString *attString = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:style}];
        CGRect rect = [attString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        
//        CGRect rect = [attString boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:
//                       @{NSFontAttributeName :[UIFont systemFontOfSize:fontSize]} context:nil];
        return rect.size.height + 1;
    } else {
        return 0;
    }
}

+ (CGFloat)heightOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
                             width:(CGFloat)width edge:(UIEdgeInsets)edge {
    if (STRING_IS_NOT_NULL) {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(width - edge.left - edge.right, 0)
                                           options:NSStringDrawingUsesLineFragmentOrigin attributes:
                       @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
        return rect.size.height;
    } else {
        return 0;
    }
}

+ (CGFloat)widthOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
                           height:(CGFloat)height edge:(UIEdgeInsets)edge {
    if (STRING_IS_NOT_NULL) {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:
                       @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
        return rect.size.width + edge.left + edge.right;
    } else {
        return 0;
    }
}

+ (CGFloat)widthOfLabelWithString:(NSString *)string sizeOfFont:(CGFloat)fontSize
                           height:(CGFloat)height {
    if (STRING_IS_NOT_NULL) {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:
                       @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
        return rect.size.width;
    } else {
        return 0;
    }
}
@end
