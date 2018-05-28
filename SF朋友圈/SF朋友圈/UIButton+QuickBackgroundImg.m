//
//  UIButton+QuickBackgroundImg.m
//  OA
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIButton+QuickBackgroundImg.h"
#define HighlightedRatio 0.7
@implementation UIButton(QuickBackgroundImg)


-(void)setBackgroundImageWithColor:(UIColor*)color{
    if(color){
        
        CGFloat r,g,b,a;
        [color getRed:&r green:&g blue:&b alpha:&a];
        UIColor * highlightedColor =[UIColor colorWithRed:r*HighlightedRatio green:g*HighlightedRatio blue:b*HighlightedRatio alpha:a];
        
        UIImage * normalImg =[self imageWithColor:color Size:CGSizeZero];
        [self setBackgroundImage:normalImg forState:UIControlStateNormal];
        
        UIImage * highlightedImg =[self imageWithColor:highlightedColor Size:CGSizeZero];
        [self setBackgroundImage:highlightedImg forState:UIControlStateDisabled];
    }
}

- (void)setBackgroundImageNomalStateWithColor:(UIColor *)color {
    
    if(color){
    
        UIImage * normalImg =[self imageWithColor:color Size:CGSizeZero];
        [self setBackgroundImage:normalImg forState:UIControlStateNormal];
    }
}

- (void)setBackgroundImageHighlightStateWithColor:(UIColor *)color {
    
    if(color){
        
        UIImage * highlightedImg =[self imageWithColor:color Size:CGSizeZero];
        [self setBackgroundImage:highlightedImg forState:UIControlStateDisabled];
    }
}

- (UIImage*)imageWithColor:(UIColor*)color Size:(CGSize)size
{
    if (size.height == 0.0 && size.width == 0.0) {
        size.height = 1.0;
        size.width = 1.0;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
