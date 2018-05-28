//
//  UITableViewCell+HYBMasonryAutoCellHeight.m
//  CellAutoHeightDemo
//
//  Created by huangyibiao on 15/9/1.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "UITableViewCell+SFMasonryAutoCellHeight.h"
#import <objc/runtime.h>
#import "UITableView+SFCacheHeight.h"

NSString *const kHYBCacheUniqueKey = @"kHYBCacheUniqueKey";
NSString *const kHYBCacheStateKey = @"kHYBCacheStateKey";
NSString *const kHYBRecalculateForStateKey = @"kHYBRecalculateForStateKey";
NSString *const kHYBCacheForTableViewKey = @"kHYBCacheForTableViewKey";

const void *s_hyb_lastViewInCellKey = "hyb_lastViewInCellKey";
const void *s_hyb_bottomOffsetToCellKey = "hyb_bottomOffsetToCellKey";

@implementation UITableViewCell (SFMasonryAutoCellHeight)

#pragma mark - Public
///  通过此方法来计算行高
+ (CGFloat)sf_heightForTableView:(UITableView *)tableView config:(HYBCellBlock)config {
    /// 使用tableViewCell的类名作为key
  UITableViewCell *cell = [tableView.hyb_reuseCells objectForKey:[[self class] description]];
  
  if (cell == nil) {
      /// 相当于创建了个cell
    cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault
                       reuseIdentifier:nil];
      /// 缓存这个cell倒tableView的类别属性中
    [tableView.hyb_reuseCells setObject:cell forKey:[[self class] description]];
  }
  
  if (config) { /// 返回这个cell
    config(cell);
  }
  
  return [cell private_hyb_heightForTableView:tableView];
}

+ (CGFloat)sf_heightForTableView:(UITableView *)tableView
                           config:(HYBCellBlock)config
                            cache:(HYBCacheHeight)cache {
  if (cache)
  {
    NSDictionary *cacheKeys = cache();
    NSString *key = cacheKeys[kHYBCacheUniqueKey];
    NSString *stateKey = cacheKeys[kHYBCacheStateKey];
    NSString *shouldUpdate = cacheKeys[kHYBRecalculateForStateKey];
    
    NSMutableDictionary *stateDict = tableView.hyb_cacheCellHeightDict[key];
    NSString *cacheHeight = stateDict[stateKey];
 
    if (tableView == nil
        || tableView.hyb_cacheCellHeightDict.count == 0
        || shouldUpdate.boolValue
        || cacheHeight == nil)
    {
      CGFloat height = [self sf_heightForTableView:tableView config:config];
      
      if (stateDict == nil)
      {
        stateDict = [[NSMutableDictionary alloc] init];
        tableView.hyb_cacheCellHeightDict[key] = stateDict;
      }
      
      [stateDict setObject:[NSString stringWithFormat:@"%lf", height] forKey:stateKey];
      
      return height;
    }
    else if (tableView.hyb_cacheCellHeightDict.count != 0
               && cacheHeight != nil
               && cacheHeight.integerValue != 0)
    {
      return cacheHeight.floatValue;
    }
  }
  
  return [self sf_heightForTableView:tableView config:config];
}

- (void)setSf_lastViewInCell:(UIView *)hyb_lastViewInCell {
  objc_setAssociatedObject(self,
                           s_hyb_lastViewInCellKey,
                           hyb_lastViewInCell,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sf_lastViewInCell {
  return objc_getAssociatedObject(self, s_hyb_lastViewInCellKey);
}

- (void)setSf_bottomOffsetToCell:(CGFloat)hyb_bottomOffsetToCell {
  objc_setAssociatedObject(self,
                           s_hyb_bottomOffsetToCellKey,
                           @(hyb_bottomOffsetToCell),
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)sf_bottomOffsetToCell {
  NSNumber *valueObject = objc_getAssociatedObject(self, s_hyb_bottomOffsetToCellKey);
  
  if ([valueObject respondsToSelector:@selector(floatValue)]) {
    return valueObject.floatValue;
  }
  
  return 0.0;
}

#pragma mark - Private
- (CGFloat)private_hyb_heightForTableView:(UITableView *)tableView {
  NSAssert(self.sf_lastViewInCell != nil, @"您未指定cell排列中最后一个视图对象，无法计算cell的高度");
 [self layoutIfNeeded];
  CGFloat rowHeight = self.sf_lastViewInCell.frame.size.height + self.sf_lastViewInCell.frame.origin.y;
  rowHeight += self.sf_bottomOffsetToCell;
  
  NSLog(@"height=%f,y=%f,bottom=%f",self.sf_lastViewInCell.frame.size.height,self.sf_lastViewInCell.frame.origin.y,self.sf_bottomOffsetToCell);
  return rowHeight;
}



@end
