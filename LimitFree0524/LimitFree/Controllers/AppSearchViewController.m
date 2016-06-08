//
//  AppSearchViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/12.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "AppSearchViewController.h"

@interface AppSearchViewController ()

@end

@implementation AppSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 重写自定制UINavigationItem
- (void)customNavigationItem
{
    [self addBackBarButtonItem];
    [self addNavigationTitle:self.title];
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
