//
//  SF_CommentInputView.m
//  SF朋友圈
//  评论输入框
//  Created by fly on 2018/5/28.
//  Copyright © 2018年 石峰(fly). All rights reserved.
//

#import "SF_CommentInputView.h"
#import <Masonry.h>
#import "UIButton+QuickBackgroundImg.h"
#import "UIColor+ZJ.h"
#import "UILabel+labelSize.h"

@interface SF_CommentInputView ()

/// 内容框
@property (nonatomic, strong) UITextView *conentTV;

///
@property (nonatomic, strong) UIView *lineView;

/// 发送按钮
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation SF_CommentInputView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self createUI];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createUI];
    }
    return self;
}

#pragma mark ---创建UI---
- (void) createUI {
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 60);
    self.backgroundColor = [UIColor grayColor];
    {
        _conentTV = [UITextView new];
//        _conentTV.scrollEnabled = NO;
        _conentTV.showsVerticalScrollIndicator = NO;
        _conentTV.font = [UIFont systemFontOfSize:15];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentTVChange:) name:UITextViewTextDidChangeNotification object:_conentTV];
        [self addSubview:_conentTV];
    }
    
    {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor greenColor];
        [self addSubview:_lineView];
    }
    
    {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 4;
        _sendBtn.enabled = NO;
        [_sendBtn setBackgroundImageHighlightStateWithColor:SHOWCOLOR(240, 240, 240)];
        [_sendBtn setBackgroundImageNomalStateWithColor:[UIColor greenColor]];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateSelected];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_sendBtn];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-15);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [_conentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf).offset(10);
        make.right.mas_equalTo(weakSelf.sendBtn.mas_left).offset(-10);
        make.top.mas_equalTo(weakSelf).offset(10);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-11);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakSelf).offset(10);
        make.right.mas_equalTo(weakSelf.sendBtn.mas_left).offset(-10);
        make.top.mas_equalTo(weakSelf.conentTV.mas_bottom).offset(0);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark ---按钮的点击方法---
///
- (void) contentTVChange:(NSNotification *)sender {
    
    NSString *str = self.conentTV.text;
    /// 取出两边空格
    NSString *needDealStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (needDealStr.length != 0) {
        
        self.sendBtn.enabled = YES;
        [self layoutIfNeeded];
        CGFloat conentHeight = [UILabel heightOfLabelWithString:str sizeOfFont:self.conentTV.font.pointSize width:self.conentTV.frame.size.width edge:self.conentTV.textContainerInset];
        conentHeight += self.conentTV.textContainerInset.top + self.conentTV.textContainerInset.bottom;
        if (conentHeight > 39 && conentHeight < 100) {
//            self.conentTV.scrollEnabled = NO;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, conentHeight + 21);
        }else if (conentHeight >= 100) {
            
//            self.conentTV.scrollEnabled = YES;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 100 + 21);
        }else {
            
//            self.conentTV.scrollEnabled = NO;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 60);
        }
        
    }else {
        
        self.sendBtn.enabled = NO;
    }
}

#pragma mark ----------------------外部调用方法--------------------------
- (void)sf_tvBecomeFirstResponder {
    
    [self.conentTV becomeFirstResponder];
}

@end
