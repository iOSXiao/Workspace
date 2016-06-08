//
//  BaseViewController.h
//  LimitFree
//
//  Created by Chaosky on 16/5/10.
//  Copyright © 2016年 1000phone. All rights reserved.
//
/**
 *  基类，所有视图控制器的基类
 */
#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

// 添加导航条的title
- (void)addNavigationTitle:(NSString *)title;
// 添加导航条上的按钮
- (void)addBarButtonItemWithTitle:(NSString *)title image:(UIImage *) image target:(id) target action:(SEL)selector isLeft:(BOOL)isLeft;
// 添加分类或者设置的按钮
- (void)addMainBarButtonItemWithTitle:(NSString *)title target:(id) target action:(SEL)selector isLeft:(BOOL)isLeft;
// 添加返回的按钮
- (void)addBackBarButtonItem;
- (void)backAction;

// 定制UINavigationItem
- (void)customNavigationItem;

@property (nonatomic, strong) AFHTTPSessionManager * httpManager; // 网络请求

@end
