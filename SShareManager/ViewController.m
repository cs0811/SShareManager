//
//  ViewController.m
//  SShareManager
//
//  Created by tongxuan on 16/6/24.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ViewController.h"
#import "SShareHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    btn.frame = CGRectMake(100, 200, 100, 50);
    [btn addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)showShareView {
    SShareMessage *  message = [SShareMessage new];
    message.title = @"测试";
    message.content = @"测试小尾巴~~~~";
    message.image = [UIImage imageNamed:@"cat.jpg"];
    message.webUrl = @"http://www.baidu.com";
    [SShare showShareViewWithMessage:message completion:^(SShareReusltCode reusltCode, NSString *errorInfo) {
        NSLog(@"VC reusltCode -- %ld \n errorInfo -- %@",reusltCode,errorInfo);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
