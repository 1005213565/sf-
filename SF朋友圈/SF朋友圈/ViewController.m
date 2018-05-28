//
//  ViewController.m
//  SF朋友圈
//
//  Created by fly on 2018/5/26.
//  Copyright © 2018年 石峰(fly). All rights reserved.
//

#import "ViewController.h"
#import "SF_FriendCircleVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    SF_FriendCircleVC *vc = [SF_FriendCircleVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
