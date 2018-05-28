//
//  SF_FriendCircleCell.h
//  SF自定义朋友圈
//
//  Created by fly on 2018/5/25.
//  Copyright © 2018年 fly(石峰). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SF_FriendCircleModel.h"

@interface SF_FriendCircleCell : UITableViewCell

/// 需要展示文字的行数 默认3行
@property (nonatomic, assign) NSInteger  needShowContentLines;

/// 单张图片的时候最大展示宽度，默认200
@property (nonatomic, assign) CGFloat  singleImgMaxWith;

/// 朋友圈数据model
@property (nonatomic, strong) SF_FriendCircleModel *friendCircleModel;


/// type： 0展开或收齐 1点赞或取消点赞  2点击了评论
@property (nonatomic, copy) void (^clickAction)(NSInteger type);

/// 回复某条评论
@property (nonatomic, copy) void (^commentReplyAction)(NSIndexPath *index);

@end
