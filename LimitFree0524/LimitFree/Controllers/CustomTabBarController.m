//
//  CustomTabBarController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/10.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "CustomTabBarController.h"
#import "BaseViewController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViewControllers];
    [self customTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  创建UITabBarController的子视图控制器
 */
- (void)createViewControllers
{
    // 获取Controllers.plist文件路径
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Controllers" ofType:@"plist"];
    // 读取plist数据
    NSArray * plistArray = [NSArray arrayWithContentsOfFile:plistPath];
    // 遍历数组
    NSMutableArray * controllers = [NSMutableArray array];
    [plistArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL * stop) {
        
        NSString * title = dict[@"title"];
        // 實現本地化
        // 參數1：key
        // 參數2：strings文件的名稱
        // 參數3：備註
        title = NSLocalizedStringFromTable(title, @"LimitFree", nil);
        
        NSString * iconName =dict[@"iconName"];
        NSString * className = dict[@"className"];
        
        // Runtime
        // 获取className对应的Class
        Class controllerClass = NSClassFromString(className);
        // 根据class创建对象
        BaseViewController * controller = [[controllerClass alloc] init];
        // 设置视图控制器的标题
        controller.title = title;
        
        // 将视图控制器放入UINavigationController中
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:controller];
        // 设置UITabBarItem
        // 获取图片
        UIImage * normalImage = [UIImage imageNamed:iconName];
        UIImage * selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_press", iconName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
        
        // 配置UINavigationBar，图片资源高度64px
        [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
        
        [controllers addObject:navi];
        
    }];
    // 设置UITabBarController的子视图控制器
    self.viewControllers = controllers;
}

/**
 *  定制UITabBar
 */
- (void)customTabBar
{
    // 获取UITabBar
    UITabBar * tabBar = self.tabBar;
    // 设置显示属性
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
}


@end



