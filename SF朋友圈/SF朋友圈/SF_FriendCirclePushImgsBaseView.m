//
//  SF_FriendCirclePushImgsBaseView.m
//  SF朋友圈
//
//  Created by fly on 2018/5/27.
//  Copyright © 2018年 石峰(fly). All rights reserved.
//

#import "SF_FriendCirclePushImgsBaseView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZJImageViewBrowser.h"

@interface SF_FriendCirclePushImgsBaseView()


/// 发表图片数组
@property (nonatomic, strong) NSMutableArray *pushImgViewArr;


@end

@implementation SF_FriendCirclePushImgsBaseView

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


- (void) createUI {
    
    self.clipsToBounds = YES;
    {
        [self.pushImgViewArr removeAllObjects];
        for (int i = 0; i < 9; i++) {
            
            UIImageView *imgView = [UIImageView new];
            imgView.backgroundColor = [UIColor grayColor];
            imgView.tag = 9999 + i;
            imgView.userInteractionEnabled = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            [self addSubview:imgView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImgAction:)];
            [imgView addGestureRecognizer:tap];
            [self.pushImgViewArr addObject:imgView];
        }
    }
    
    [super layoutIfNeeded];
    /**********************设置图片frame************************/
    CGFloat widthOrHeight = ([UIScreen mainScreen].bounds.size.width - 20 - 20)/3.0;
    for (int i = 0; i < self.pushImgViewArr.count; i++) {
        
        UIImageView *imgView = self.pushImgViewArr[i];
        if (i < 3) {
            
            imgView.frame = CGRectMake((10 + widthOrHeight)*i,10,widthOrHeight, widthOrHeight);
        }else if (i < 6 && i >= 3) {
            
            imgView.frame = CGRectMake((10 + widthOrHeight)*(i - 3), 10 + widthOrHeight + 10, widthOrHeight, widthOrHeight);
        }else if (i >= 6) {
            
            imgView.frame = CGRectMake((10 + widthOrHeight)*(i - 6),10 + widthOrHeight + 10 + widthOrHeight + 10, widthOrHeight, widthOrHeight);
        }
    }
    /**********************设置图片frame************************/
}

#pragma mark ---set方法---
- (void)setPushImgArr:(NSMutableArray *)pushImgArr {
    
    _pushImgArr = pushImgArr;
    
    /**********************设置图片************************/
    for (int i = 0; i < self.pushImgViewArr.count; i++) {
        
        UIImageView *imgView = self.pushImgViewArr[i];
        imgView.hidden = YES;
    }
    
    NSInteger count = self.pushImgArr.count>9? self.pushImgViewArr.count:self.pushImgArr.count;
    
    for (int i = 0; i < count; i++) {
        
        UIImageView *imgView = self.pushImgViewArr[i];
        imgView.hidden = NO;
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.pushImgArr[i]] placeholderImage:nil];
    }
    
    /**********************设置图片************************/
}

#pragma mark ---点击方法---
- (void) showImgAction:(UITapGestureRecognizer *)sender {
    
    UIImageView *view = (UIImageView *)sender.view;
    
    NSMutableArray *tempImg = [NSMutableArray new];
    for (NSInteger i = 0; i < (self.pushImgArr.count>=9?9:self.pushImgArr.count); i++) {
        
        UIImageView *imgView = self.pushImgViewArr[i];
        [tempImg addObject:imgView];
    }
    
    ZJImageViewBrowser *browser = [[ZJImageViewBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds imageViewArray:tempImg imageViewContainView:self];
    browser.selectedImageView = view;
    [browser show];

    
}

#pragma mark ---懒加载---
- (NSMutableArray *)pushImgViewArr {
    if (!_pushImgViewArr) {
        
        _pushImgViewArr = [NSMutableArray new];
    }
    return _pushImgViewArr;
}
@end















