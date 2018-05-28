//
//  SF_FriendCircleModel.h
//  SF自定义朋友圈
//
//  Created by fly on 2018/5/25.
//  Copyright © 2018年 fly(石峰). All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark ----------------朋友圈model-------------------

@class SF_CommentsModel;
@interface SF_FriendCircleModel : NSObject<NSCopying>

/// 头像url
@property (nonatomic, copy) NSString *headerUrl;

/// 昵称
@property (nonatomic, copy) NSString *nickName;

/// 发布时间
@property (nonatomic, copy) NSString *pushTime;

/// 发布内容
@property (nonatomic, copy) NSString *pushContent;

/// 发布图片数组
@property (nonatomic, strong) NSMutableArray <NSString *> *pushImgArr;

/// 点赞昵称数组
@property (nonatomic, strong) NSMutableArray <NSString *> *likeNameArr;

/// 评论model数组
@property (nonatomic, strong) NSMutableArray <SF_CommentsModel *> *commentsModelArr;

#pragma mark ---是否展示所有内容---
/// 是否展示所有内容
@property (nonatomic, assign) BOOL isShow;

@end

#pragma mark ----------------朋友圈评论model-------------------
@interface SF_CommentsModel : NSObject

/// 评论人昵称
@property (nonatomic, copy) NSString *commentPersonName;

/// 被评论人昵称
@property (nonatomic, copy) NSString *commentedPersonName;

/// 评论内容
@property (nonatomic, copy) NSString *commentContent;

/// 评论人id
@property (nonatomic, copy) NSString *commentPersonId;

/// 被评论人id
@property (nonatomic, copy) NSString *commentedPersonId;
@end

