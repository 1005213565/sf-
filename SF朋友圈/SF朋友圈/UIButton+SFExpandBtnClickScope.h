//
//  UIButton+SFExpandBtnClickScope.h
//  test
//  扩大按钮的点击范围
//  Created by mac on 2017/8/3.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SFExpandBtnClickScope)
/*!
 *  设置btn距离上下左右的位置，用于扩大按钮的点击范围
 *
 *  @param top    <#top description#>
 *  @param right  <#right description#>
 *  @param bottom <#bottom description#>
 *  @param left   <#left description#>
 */
- (void)setExpandBtnClickScopeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
