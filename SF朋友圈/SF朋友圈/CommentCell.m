//
//  CommentCell.m
//  ZJFriendLineDemo
//
//  Created by ZJ on 16/6/20.
//  Copyright © 2016年 ZJ. All rights reserved.
//

#import "CommentCell.h"
#import "UITableViewCell+SFMasonryAutoCellHeight.h"
#import "MLLinkLabel.h"
#import <Masonry.h>

@interface CommentCell ()<MLLinkLabelDelegate>
@property (nonatomic, strong) MLLinkLabel *contentLabel;
@end
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentLabel = [[MLLinkLabel alloc] init];
        self.contentLabel.delegate = self;
        self.contentLabel.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:92/255.0 green:140/255.0 blue:255/255.0 alpha:1.0]};
        self.contentLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
        [self.contentView addSubview:self.contentLabel];
        
        
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:14.0];
        
        
        self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 80;;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(0);
        }];
        
        
        self.sf_lastViewInCell = self.contentLabel;
        self.sf_bottomOffsetToCell = 5.0;
    }
    return self;
}
- (void)configCellWithModel:(SF_CommentsModel *)model
{
    NSString *string =[NSString stringWithFormat:@"%@:%@",model.commentPersonName,model.commentContent];
    if(model.commentedPersonName.length != 0)
    {
        string =[NSString stringWithFormat:@"%@回复%@:%@",model.commentPersonName,model.commentedPersonName ,model.commentContent];
    }
     NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    [text setAttributes:@{NSLinkAttributeName : model.commentPersonName} range:[string rangeOfString:model.commentPersonName]];
    
    
    if(model.commentedPersonName.length != 0)
    {
        [text setAttributes:@{NSLinkAttributeName : model.commentedPersonName} range:[string rangeOfString:model.commentedPersonName]];
    }
    self.contentLabel.attributedText = text;
}
- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel
{
    NSLog(@"点击了：%@",link.linkValue);
}

@end
