//
//  MySettingViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/19.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "MySettingViewController.h"
// SDWebImage图片缓存的相关信息
#import <SDImageCache.h>

@interface MySettingViewController ()

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2) {
        // 获取缓存信息
        // 获取缓存的图片数量
        NSInteger imageCount = [[SDImageCache sharedImageCache] getDiskCount];
        // 获取缓存的图片大小
        NSUInteger imageSize = [[SDImageCache sharedImageCache] getSize]; // 单位：字节
        NSString * msg = [NSString stringWithFormat:@"缓存文件个数：%ld，大小：%.2fM，是否清除？", imageCount, (imageSize/1024.0)/1024.0];
        
        
        // 清除缓存
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:msg preferredStyle:UIAlertControllerStyleAlert];
        // 添加AlertAction
        // 取消按钮
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        // 清除按钮
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *  action) {
            // 清除缓存
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            // 清除已过期的图片
            [[SDImageCache sharedImageCache] cleanDisk];
        }];
        
        // 将Action添加到AlertController中
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        // present
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}


@end
