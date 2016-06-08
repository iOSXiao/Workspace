//
//  BaseViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/10.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (AFHTTPSessionManager *)httpManager
{
    if (!_httpManager) {
        _httpManager = [AFHTTPSessionManager manager];
        // 设置JSON数据序列化，将JSON数据转换为字典或者数组
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 在序列化器中追加一个类型，text/html这个类型是不支持的，text/json, application/json
        _httpManager.responseSerializer.acceptableContentTypes = [_httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavigationTitle:(NSString *)title
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.textColor = [UIColor purpleColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    
    // 设置导航的titleView
    self.navigationItem.titleView = titleLabel;
}

- (void)addBarButtonItemWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft
{
    UIButton * barButton = [UIButton buttonWithType:UIButtonTypeSystem];
    barButton.frame = CGRectMake(0, 0, 51, 35);
    barButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [barButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    // 设置按钮标题
    [barButton setTitle:title forState:UIControlStateNormal];
    // 设置按钮背景
    [barButton setBackgroundImage:image forState:UIControlStateNormal];
    // 设置target-action
    [barButton addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    
    // 创建UIBarButtonItem
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    // 判断是否在左侧
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    else {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

- (void)addMainBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft
{
    UIImage * image = [UIImage imageNamed:@"buttonbar_action"];
    [self addBarButtonItemWithTitle:title image:image target:target action:selector isLeft:isLeft];
}

- (void)addBackBarButtonItem
{
    [self addBarButtonItemWithTitle:@"返回" image:[UIImage imageNamed:@"buttonbar_back"] target:self action:@selector(backAction) isLeft:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 约定大于配置，由子类重写
- (void)customNavigationItem
{
    
}

@end
