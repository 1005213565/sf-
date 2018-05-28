//
//  CommentCell.h
//  ZJFriendLineDemo
//
//  Created by ZJ on 16/6/20.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SF_FriendCircleModel.h"

@interface CommentCell : UITableViewCell
- (void)configCellWithModel:(SF_CommentsModel *)model;
@end
