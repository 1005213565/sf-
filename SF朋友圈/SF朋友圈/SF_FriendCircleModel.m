//
//  SF_FriendCircleModel.m
//  SF自定义朋友圈
//
//  Created by fly on 2018/5/25.
//  Copyright © 2018年 fly(石峰). All rights reserved.
//

#import "SF_FriendCircleModel.h"

@implementation SF_FriendCircleModel

-(id)copyWithZone:(NSZone *)zone {
    
    SF_FriendCircleModel *model = [[SF_FriendCircleModel allocWithZone:zone] init];
    model.isShow = self.isShow;
    model.headerUrl = self.headerUrl;
    model.nickName = self.nickName;
    model.pushTime = self.pushTime;
    model.pushImgArr = self.pushImgArr;
    
    model.likeNameArr = self.likeNameArr;
    model.pushContent = self.pushContent;

    model.commentsModelArr = self.commentsModelArr;
    return model;
}

- (NSMutableArray<NSString *> *)pushImgArr {
    
    if (!_pushImgArr) {
        
        _pushImgArr = [NSMutableArray new];
    }
    return _pushImgArr;
}

- (NSMutableArray<NSString *> *)likeNameArr {
    
    if (!_likeNameArr) {
    
        _likeNameArr = [NSMutableArray new];
    }
    return _likeNameArr;
}

- (NSMutableArray<SF_CommentsModel *> *)commentsModelArr {
    
    if (!_commentsModelArr) {
        
        _commentsModelArr = [NSMutableArray new];
    }
    
    return _commentsModelArr;
}

@end


#pragma mark ----------------朋友圈评论model-------------------
@implementation SF_CommentsModel

@end
