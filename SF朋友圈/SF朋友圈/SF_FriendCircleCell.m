//
//  SF_FriendCircleCell.m
//  SF自定义朋友圈
//
//  Created by fly on 2018/5/25.
//  Copyright © 2018年 fly(石峰). All rights reserved.
//

#import "SF_FriendCircleCell.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImgSize.h"
#import "UILabel+labelSize.h"
#import "UIButton+SFExpandBtnClickScope.h"
#import "UITableViewCell+SFMasonryAutoCellHeight.h"
#import "SF_FriendCirclePushImgsBaseView.h"
#import "OperationView.h"
#import "CommentView.h"

@interface SF_FriendCircleCell ()<CommentViewDelegate>

/// baseView
@property (nonatomic, strong) UIView *baseView;

/// 头像
@property (nonatomic, strong) UIImageView *headerImgView;

/// 昵称
@property (nonatomic, strong) UILabel *nickNameLabel;

/// 时间label
@property (nonatomic, strong) UILabel *timeLabel;

/// 发表文字
@property (nonatomic, strong) UILabel *pushContentLabel;

/// 展开收齐文字的按钮
@property (nonatomic, strong) UIButton *isShowContentBtn;

/// 图片baseview
@property (nonatomic, strong) SF_FriendCirclePushImgsBaseView *imgsBaseView;

/// 是否展示点赞和评论的操作view的按钮
@property (nonatomic, strong) UIButton *operationBtn;

/// 是否展示点赞和评论的操作view
@property (nonatomic, strong) OperationView *operationView;

/// 评论点赞view
@property (nonatomic, strong) CommentView *commentView;

@end


@implementation SF_FriendCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self friendCircleInitialize];
    [self createUI];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self friendCircleInitialize];
        [self createUI];
        return self;
    }else {
        
        return nil;
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) createUI {
    
    __weak typeof(self) weakSelf = self;
    {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
    }
    
    {
        _headerImgView = [UIImageView new];
        _headerImgView.backgroundColor = [UIColor grayColor];
        [_baseView addSubview:_headerImgView];
    }
    
    {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.font = [UIFont systemFontOfSize:15];
        [_baseView addSubview:_nickNameLabel];
    }
    
    {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [_baseView addSubview:_timeLabel];
    }
    
    {
        _pushContentLabel = [UILabel new];
        _pushContentLabel.font = [UIFont systemFontOfSize:14];
        _pushContentLabel.numberOfLines = 0;
        [_baseView addSubview:_pushContentLabel];
    }
    
    {
        _isShowContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_isShowContentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_isShowContentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [_isShowContentBtn setTitle:@"全文" forState:UIControlStateNormal];
        [_isShowContentBtn setTitle:@"收起" forState:UIControlStateSelected];
        _isShowContentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_isShowContentBtn addTarget:self action:@selector(isShowAllContentAction:) forControlEvents:UIControlEventTouchUpInside];
        [_isShowContentBtn setExpandBtnClickScopeWithTop:10 right:20 bottom:10 left:10];
        [_baseView addSubview:_isShowContentBtn];
    }
    
    /// 创建imgs
    {
        _imgsBaseView = [SF_FriendCirclePushImgsBaseView new];
        [_baseView addSubview:_imgsBaseView];
    }
    
    {
        _operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationBtn setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        _operationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_operationBtn addTarget:self action:@selector(isShowOperationViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_operationBtn setExpandBtnClickScopeWithTop:10 right:20 bottom:10 left:10];
        [_baseView addSubview:_operationBtn];
    }
    
    /// 创建操作view
    {
        _operationView = [OperationView new];
        _operationView.likeBtnClicked = ^{
            
            NSLog(@"点击了喜欢");
            if (weakSelf.clickAction) {
                
                weakSelf.clickAction(1);
            }
            weakSelf.operationView.isShowing = NO;
        };
        
        _operationView.commentBtnClicked = ^{
            
            NSLog(@"点击了评论");
            if (weakSelf.clickAction) {
                
                weakSelf.clickAction(2);
            }
            weakSelf.operationView.isShowing = NO;
        };
        [_baseView addSubview:_operationView];
    }
    
    {
        _commentView = [CommentView new];
//        _commentView.backgroundColor = [UIColor yellowColor];
        _commentView.delegate = self;
        [_baseView addSubview:_commentView];
    }
    
    /// 设置以上视图的frame
    [self setSubViewsFrame];
}

#pragma mark ----设置数据----
- (void)setFriendCircleModel:(SF_FriendCircleModel *)friendCircleModel {
    _friendCircleModel = friendCircleModel;
    
    
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:friendCircleModel.headerUrl]  placeholderImage:[UIImage imageNamed:@"place"]];
    
    self.nickNameLabel.text = friendCircleModel.nickName;
    self.timeLabel.text = [SF_FriendCircleCell sf_distanceTimeWithBeforeTime:friendCircleModel.pushTime];
    
    self.pushContentLabel.text = friendCircleModel.pushContent;
    
    self.isShowContentBtn.selected = friendCircleModel.isShow;
    
    if ([friendCircleModel.likeNameArr containsObject:@"石峰"]) {
        
        _operationView.praiseString = @"取消";
    }else {
        
        _operationView.praiseString = @"赞";
    }
    
    [self setChangeSubViewsFrame];
    
    self.imgsBaseView.pushImgArr = friendCircleModel.pushImgArr;
    
    [self.commentView configCellWithModel:friendCircleModel indexPath:nil];
}
#pragma mark ---按钮的点击方法---
- (void) isShowAllContentAction:(UIButton *)sender {
    
    if (self.clickAction) {
        
        self.clickAction(0);
    }
}

/// 是否展示操作view
- (void) isShowOperationViewAction:(UIButton *)sender {
    
    self.operationView.isShowing = !self.operationView.isShowing;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.operationView.isShowing = NO;
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    [window endEditing:YES];
}

- (void) hideOperationViewAction {
    
    self.operationView.isShowing = NO;
}

#pragma mark ----初始化----
- (void) friendCircleInitialize {
    
    self.needShowContentLines = 3;
    self.singleImgMaxWith = 200;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.backgroundColor = [UIColor grayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideOperationViewAction) name:@"ScrollViewRolling" object:nil];
}

#pragma mark ---设置改变frame---
- (void) setChangeSubViewsFrame {
    
    __weak typeof(self) weakSelf = self;
    if ([self.friendCircleModel.pushContent isEqualToString:@""] || self.friendCircleModel.pushContent == nil || [self.friendCircleModel.pushContent isEqual:[NSNull null]]) {
        
    
        [_pushContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.headerImgView.mas_bottom).offset(0.01);
            make.height.mas_equalTo(0);
        }];
    }else {
        
        [_pushContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.headerImgView.mas_bottom).offset(10);
        }];
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat singleHeight = [UILabel heightOfLabelWithString:@"单行" sizeOfFont:14 width:width];
    CGFloat pushContentHeight = [UILabel heightOfLabelWithString:self.friendCircleModel.pushContent sizeOfFont:14 width:width];
    if (pushContentHeight > singleHeight*self.needShowContentLines) {
        
        self.isShowContentBtn.hidden = NO;
        
        if (self.friendCircleModel.isShow) {
            
            self.pushContentLabel.numberOfLines = 0;
            [_pushContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(pushContentHeight);
            }];
        }else {
            
            self.pushContentLabel.numberOfLines = self.needShowContentLines;
            [_pushContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(self.needShowContentLines*singleHeight);
            }];
        }
        
        [_isShowContentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.pushContentLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(15);
        }];
    }else {
        
        [_pushContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(pushContentHeight);
        }];
        
        self.isShowContentBtn.hidden = YES;
        self.pushContentLabel.numberOfLines = self.needShowContentLines;
        [_isShowContentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.pushContentLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0.01);
        }];
    }
    
    
    CGFloat sigleRowImgWidth = ([UIScreen mainScreen].bounds.size.width - 40)/3.0 + 10;
    if (self.friendCircleModel.pushImgArr.count >= 1 && self.friendCircleModel.pushImgArr.count <= 3) {
        
        [_imgsBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.isShowContentBtn.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.headerImgView);
            make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
            make.height.mas_equalTo(sigleRowImgWidth);
        }];
    }else if (self.friendCircleModel.pushImgArr.count >= 4 && self.friendCircleModel.pushImgArr.count <= 6) {
        
        [_imgsBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.isShowContentBtn.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.headerImgView);
            make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
            make.height.mas_equalTo(sigleRowImgWidth*2);
        }];

    }else if (self.friendCircleModel.pushImgArr.count >= 7) {
        
        [_imgsBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.isShowContentBtn.mas_bottom).offset(10);
            make.left.equalTo(weakSelf.headerImgView);
            make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
            make.height.mas_equalTo(sigleRowImgWidth*3);
        }];

    }else if (self.friendCircleModel.pushImgArr.count == 0 || !self.friendCircleModel.pushImgArr) {
        
        [_imgsBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakSelf.isShowContentBtn.mas_bottom).offset(0);
            make.left.equalTo(weakSelf.headerImgView);
            make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
            make.height.mas_equalTo(0);
        }];
        
    }

}

#pragma mark ---设置首次frame---
- (void) setSubViewsFrame {
    
    __weak typeof(self) weakSelf = self;
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.contentView).offset(0);
        make.top.mas_equalTo(weakSelf.contentView).offset(0);
        make.right.mas_equalTo(weakSelf.contentView).offset(0);
        make.bottom.mas_equalTo(weakSelf.contentView).offset(0);
    }];
    
    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.baseView).offset(10);
        make.top.mas_equalTo(weakSelf.baseView).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.headerImgView.mas_right).offset(5);
        make.top.equalTo(weakSelf.headerImgView.mas_top);
        make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf.headerImgView.mas_right).offset(5);
        make.bottom.equalTo(weakSelf.headerImgView.mas_bottom);
        make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
    }];
    
    
    [_pushContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.headerImgView.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.headerImgView);
        make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
    }];
    
    
    [_isShowContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.pushContentLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.headerImgView);
    }];
    
    
    [_imgsBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakSelf.isShowContentBtn.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.headerImgView);
        make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
        make.height.mas_equalTo(0);
    }];
    
    [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakSelf.imgsBaseView.mas_bottom).offset(10);
        make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //喜欢和评论按钮
    [_operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_operationBtn);
        make.right.mas_equalTo(weakSelf.operationBtn.mas_left).offset(-3);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
    /// 评论和点赞view
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(weakSelf.operationBtn.mas_bottom).offset(10);
        make.right.mas_equalTo(weakSelf.baseView.mas_right).offset(-10);
        make.left.equalTo(weakSelf.headerImgView);
    }];
    
    weakSelf.sf_lastViewInCell = _commentView;
    weakSelf.sf_bottomOffsetToCell = 10;
}

#pragma mark ---CommentViewDelegate---
/// 点击了某个评论需要回复
-(void)didClickRowWithFirstIndexPath:(NSIndexPath *)firIndexPath secondIndex:(NSIndexPath *)secIndexPath {
    
    if (self.commentReplyAction) {
        
        self.commentReplyAction(secIndexPath);
    }
}

#pragma mark ---工具方法---
/*! 获取当前时间的时间戳 SF添加 */
+ (NSString*)sf_getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

/*!
 计算给定时间与当前时间的距离  SF_添加
 beTime 为传入的时间戳
 */
+ (NSString *)sf_distanceTimeWithBeforeTime:(NSString *)beTimeStamp {
    
    
    // 获取当前的时间戳
    NSString *currentTimeStamp = [self sf_getCurrentTimestamp];
    if (currentTimeStamp.length >= 13) {
        
        currentTimeStamp = [NSString stringWithFormat:@"%.f",currentTimeStamp.doubleValue / 1000];
    }
    
    if (beTimeStamp.length >= 13) {
        
        beTimeStamp = [NSString stringWithFormat:@"%.f",beTimeStamp.doubleValue / 1000];
    }
    NSLog(@"当前时间的时间戳===%@",beTimeStamp);
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTimeStamp.doubleValue];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    [df setDateFormat:@"dd"];
    
    
    CGFloat distanceTimeSeconds = currentTimeStamp.doubleValue -beTimeStamp.doubleValue;
    NSString *distanceStr = @"";
    if (distanceTimeSeconds < 60) { // 小于一分钟()
        
        distanceStr = @"刚刚";
    }else if (distanceTimeSeconds < 60*60) { // 时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTimeSeconds/60];
    }else if(distanceTimeSeconds <= 24*60*60*2 + 10){//时间小于二天 (10代表的是服务器返回的时间和手机时间的误差)
        
        if (distanceTimeSeconds <= 24*60*60 + 10) {
            
            distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
        }else {
            
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        
    }else if(distanceTimeSeconds < 24*60*60*365){
        
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}
@end

















