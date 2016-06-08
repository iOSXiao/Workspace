//
//  AppDelegate.m
//  LimitFree
//
//  Created by Chaosky on 16/5/10.
//  Copyright (c) 2016年 1000phone. All rights reserved.
//

#import "AppDelegate.h"
// 友盟分享的头文件
#import "UMSocial.h"
// 导入LeanCloud头文件
#import <AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 设置AppKey
    [UMSocialData setAppKey:UMSocialAppKey];
    
    
    
    // 请求用户权限、注册远程推送通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // iOS 8 之后
        // 请求用户权限
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 注册远程推送
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        // iOS 8 之前系统版本注册远程推送通知
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert];
    }
    
    return YES;
}

// 注册远程推送成功的回调，返回Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"device token = %@", deviceToken);
    // 需要将DeviceToken发送给自定义的服务器
    // 将NSData转换为字符串
    NSString * tokenStr = deviceToken.description;
    tokenStr = [tokenStr substringWithRange:NSMakeRange(1, tokenStr.length - 2)];
    NSLog(@"token str = %@", tokenStr);
    
    // 将DeviceToken发送给LeanCloud服务器
    
    
}

// 注册远程推送通知失败的回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error = %@", error.localizedDescription);
}

// 接受远程推送通知的回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
