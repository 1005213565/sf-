//
//  UIButton+SFExpandBtnClickScope.m
//  test
//  扩大按钮的点击范围
//  Created by mac on 2017/8/3.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "UIButton+SFExpandBtnClickScope.h"
#import <objc/runtime.h>

@implementation UIButton (SFExpandBtnClickScope)
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    CGRect bounds = self.bounds;
//    // 若原区域小于44*44,则放大点击区域，否则保持原来大小不变
//    CGFloat deltaW = MAX(44 - bounds.size.width, 0);
//    CGFloat deltaH = MAX(44 - bounds.size.height, 0);
//    bounds = CGRectInset(bounds, -deltaW * 0.5, -deltaH * 0.5);
//    return CGRectContainsPoint(bounds, point);
//    
//}

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setExpandBtnClickScopeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden) {
        
        return nil;
    }
    
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}
@end
