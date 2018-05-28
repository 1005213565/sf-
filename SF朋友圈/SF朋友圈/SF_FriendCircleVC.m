//
//  SF_FriendCircleVC.m
//  SF自定义朋友圈
//
//  Created by fly on 2018/5/25.
//  Copyright © 2018年 fly(石峰). All rights reserved.
//

#import "SF_FriendCircleVC.h"
#import "SF_FriendCircleCell.h"
#import "SF_FriendCircleModel.h"
#import "ALFPSStatus.h"
#import "UITableViewCell+SFMasonryAutoCellHeight.h"
#import "SF_CommentInputView.h"
#import "ChatKeyBoard.h"

@interface SF_FriendCircleVC ()<UITableViewDelegate,UITableViewDataSource,ChatKeyBoardDelegate, ChatKeyBoardDataSource>

@property (weak, nonatomic) IBOutlet UITableView *friendCircleTableView;

///
@property (nonatomic, strong) NSMutableArray *sf_mArr;

/// 评论输入框（自己写的）
@property (nonatomic, strong) SF_CommentInputView *inputView;

/// 评论输入框 (第三方的)
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

/// 选中的当前cell的位置
@property (nonatomic, strong)  NSIndexPath *commentIndexpath;

/// 回复的人的评论的位置
@property (nonatomic, strong)  NSIndexPath *replyCommentIndexpath;

/// 评论类型 1评论发布人 2回复
@property (nonatomic, assign) NSInteger commentType;

@property (nonatomic,assign)float totalKeybordHeight;
@end

@implementation SF_FriendCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"朋友圈";
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ALFPSStatus shareInstance] start];
    
    _chatKeyBoard =[ChatKeyBoard keyBoardWithParentViewBounds:[UIScreen mainScreen].bounds];
    _chatKeyBoard.delegate = self;
    _chatKeyBoard.dataSource = self;
    _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    _chatKeyBoard.allowVoice = NO;
    _chatKeyBoard.allowMore = NO;
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    [window addSubview:_chatKeyBoard];
}

- (void) createUI {
    
    self.friendCircleTableView.delegate = self;
    self.friendCircleTableView.dataSource = self;
    self.friendCircleTableView.estimatedSectionHeaderHeight = 0;
    self.friendCircleTableView.estimatedSectionFooterHeight = 0;
    self.friendCircleTableView.estimatedRowHeight = 400;
    [self.friendCircleTableView registerClass:[SF_FriendCircleCell class] forCellReuseIdentifier:@"SF_FriendCircleCell"];
    
    NSArray *imgArr = @[@"http://file.5odj.com/APP/rent/1527145124669.jpg",@"http://summer.image.alimmdn.com/6debdc4746f44c389b0c65ef1eb1cdd9.png",@"http://gfs6.gomein.net.cn/T1.iJvBXVT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T10_LvBjLv1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1ALVvBXZg1RCvBVdK.jpg",@"http://gfs8.gomein.net.cn/T1RbW_BmdT1RCvBVdK.gif",@"http://summer.image.alimmdn.com/6debdc4746f44c389b0c65ef1eb1cdd9.png",@"http://file.5odj.com/APP/rent/1527145124669.jpg",@"http://summer.image.alimmdn.com/6debdc4746f44c389b0c65ef1eb1cdd9.png",@"http://gfs6.gomein.net.cn/T1.iJvBXVT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T10_LvBjLv1RCvBVdK.jpg"];
    NSString *contentStr = @"我打开手机垫付按实际电费家就的撒缴费爱的世界付款家电极法近代史可把速度快 不v 金坷垃时代峻峰拉三等奖发氨基酸掉了房间傻得可怜垃圾爱的方式卡的设计开发阿喀琉斯就知道付款加速度快发酵\n饲料大跨世纪的法律加快俯拾地芥拉进方式了石峰科技楼上的积分刷卡机数据发看撒娇的发看撒娇付款坚实的解放军涉及到附近看阿斯加德房间爱看电视大概房管局对方过后婕拉发过火阿拉基都很反感好冬季恋歌阿里国际化的风格和锐仍会铺货\n速度快减肥开始敬爱的福建省大姐夫卡时间段附近卡健身房的点击分开发电视剧";
    NSArray *timeStampArr = @[@"1527471970",@"1527457570",@"1527371170",@"1524779170",@"1493243170",@"1461707170"];
    
    NSArray *nickArr = @[@"战三",@"李四",@"王玛丽子",@"二狗子",@"小顺子",@"哈哈"];
    NSArray *commentContentArr = @[@"你好吗？",@"我生气了，快点来哄我!",@"我不好",@"你们在讨论什么呢，说好的一起呢，咋就不一起呢",@"哈哈哈发哈涣发大号；打款发货；啊速度快放假开始点"];
    for (int i = 0; i < 20; i++) {
        
        int index = arc4random()%imgArr.count;
        
        SF_FriendCircleModel *model = [SF_FriendCircleModel new];
        model.headerUrl = imgArr[index];
        
        model.nickName = nickArr[arc4random()%nickArr.count];
        model.pushTime = timeStampArr[arc4random()%timeStampArr.count];

        if (i%3 == 0) {
            
            model.pushContent = @"";
        }else {
            
            model.pushContent = [contentStr substringWithRange:NSMakeRange(0, arc4random()%(contentStr.length - 1) + 1)];
        }
        
        if (i%4==0) {
            
            for (int j = 0; j < imgArr.count; j++) {

                [model.pushImgArr addObject:imgArr[j]];
            }
            
        }else {
            
            for (int j = 0; j < arc4random()%imgArr.count; j++) {
                
                [model.pushImgArr addObject:imgArr[j]];
            }
        }
        
        /// 点赞数
        for (int i = 0; i < arc4random()%5; i++) {
            
            [model.likeNameArr addObject:nickArr[arc4random()%nickArr.count]];
        }
        
        /// 评论数
        for (int i = 0; i < arc4random()%7; i++) {
            
            SF_CommentsModel *commentModel = [SF_CommentsModel new];
            commentModel.commentContent = commentContentArr[arc4random()%commentContentArr.count];
            commentModel.commentPersonName = nickArr[arc4random()%nickArr.count];
            commentModel.commentedPersonName = nickArr[arc4random()%nickArr.count];
            
            
            [model.commentsModelArr addObject:commentModel];
        }
        
        [self.sf_mArr addObject:model];
    }
}

#pragma mark ---UITableViewDelegate,UITableViewDataSource---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sf_mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SF_FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SF_FriendCircleCell"];
    if (!cell) {
        
        cell = [[SF_FriendCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SF_FriendCircleCell"];
    }
    SF_FriendCircleModel *model = self.sf_mArr[indexPath.row];
    cell.friendCircleModel = model;
    
    cell.clickAction = ^(NSInteger type) {
      
        if (type == 0) { // 是否展示多余文字
            
            model.isShow = !model.isShow;
            
            //关闭隐式动画
            [UIView performWithoutAnimation:^{
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }else if (type == 1) { // 是否点赞
            
            if ([model.likeNameArr containsObject:@"石峰"]) {
                
                [model.likeNameArr removeObject:@"石峰"];
            }else {
                
                [model.likeNameArr addObject:@"石峰"];
            }
            
            //关闭隐式动画
            [UIView performWithoutAnimation:^{
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }else if (type == 2) { // 点击了评论
            
            self.commentType = 1;
            self.commentIndexpath = indexPath;
            [self.chatKeyBoard keyboardUpforComment];
        }
    };
    
    
    cell.commentReplyAction = ^(NSIndexPath *index) {
      
        SF_CommentsModel *replyModel = model.commentsModelArr[index.row];
        if ([replyModel.commentPersonName isEqualToString:@"石峰"]) {
            
            UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil  message:@"是否删除该条评论" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [model.commentsModelArr removeObjectAtIndex:index.row];
                //关闭隐式动画
                [UIView performWithoutAnimation:^{
                    
                    [self.friendCircleTableView reloadRowsAtIndexPaths:@[self.commentIndexpath] withRowAnimation:UITableViewRowAnimationNone];
                }];
                
            }];
            [controller addAction:cancelAction];
            [controller addAction:okAction];
            [self presentViewController:controller animated:YES completion:nil];
            return ;
        }
        self.commentType = 2;
        self.commentIndexpath = indexPath;
        self.replyCommentIndexpath = index;
        [self.chatKeyBoard keyboardUpforComment];
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat h = [SF_FriendCircleCell sf_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        
        SF_FriendCircleModel *model = self.sf_mArr[indexPath.row];
        SF_FriendCircleCell *cell = (SF_FriendCircleCell *)sourceCell;
        cell.friendCircleModel = model;
    }];
    
    NSLog(@"我indexPath.row=%ld得到cell的高度==%f",indexPath.row,h);
    return h;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewRolling" object:nil];
    
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    [window endEditing:YES];
}

#pragma mark ---通知回调---
- (void) keyBoardFrameWillChange:(NSNotification *)sender {
    
    NSDictionary *dict = sender.userInfo;
    CGRect rect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (rect.origin.y < [UIScreen mainScreen].bounds.size.height) {
        
        self.totalKeybordHeight  = rect.size.height + 49;
        
        UITableViewCell *cell = [self.friendCircleTableView cellForRowAtIndexPath:self.commentIndexpath];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //坐标转换
        CGRect rect = [cell.superview convertRect:cell.frame toView:window];
        
        CGFloat dis = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
        CGPoint offset = self.friendCircleTableView.contentOffset;
        offset.y += dis;
        if (offset.y < 0) {
            offset.y = 0;
        }
        
        [self.friendCircleTableView setContentOffset:offset animated:YES];
        [self.chatKeyBoard keyboardUpforComment];
    }
}


#pragma mark -- ChatKeyBoardDelegate
- (void)chatKeyBoardSendText:(NSString *)text;
{

    if (self.commentType == 1) {
        
        if (self.commentIndexpath == nil) {
            
            return;
        }
        
        SF_FriendCircleModel *model = self.sf_mArr[self.commentIndexpath.row];
        SF_CommentsModel *commentModel = [SF_CommentsModel new];
        commentModel.commentPersonName = @"石峰";
        commentModel.commentContent = text;
        
        [model.commentsModelArr addObject:commentModel];
        
        //关闭隐式动画
        [UIView performWithoutAnimation:^{
            
            [self.friendCircleTableView reloadRowsAtIndexPaths:@[self.commentIndexpath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else if (self.commentType == 2) {
        
        if (self.commentIndexpath == nil) {
            
            return;
        }
        
        SF_FriendCircleModel *model = self.sf_mArr[self.commentIndexpath.row];
        SF_CommentsModel *replyModel = model.commentsModelArr[self.replyCommentIndexpath.row];
        
        
        SF_CommentsModel *commentModel = [SF_CommentsModel new];
        commentModel.commentPersonName = @"石峰";
        commentModel.commentContent = text;
        commentModel.commentedPersonName = replyModel.commentPersonName;
        
        
        [model.commentsModelArr addObject:commentModel];
        
        //关闭隐式动画
        [UIView performWithoutAnimation:^{
            
            [self.friendCircleTableView reloadRowsAtIndexPaths:@[self.commentIndexpath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    [self.chatKeyBoard keyboardDownForComment];
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    return nil;
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}
//- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
//{
//    return [FaceSourceManager loadFaceSource];
//}



#pragma mark ---懒加载---
- (NSMutableArray *)sf_mArr {
    
    if (!_sf_mArr) {
        
        _sf_mArr = [NSMutableArray new];
    }
    
    return _sf_mArr;
}

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [SF_CommentInputView new];
    }
    return _inputView;
}






@end













