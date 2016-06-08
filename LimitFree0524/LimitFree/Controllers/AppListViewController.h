//
//  AppListViewController.h
//  LimitFree
//
//  Created by Chaosky on 16/5/11.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "BaseViewController.h"

@interface AppListViewController : BaseViewController

@property (nonatomic, copy) NSString * requestURL; // 请求数据地址
@property (nonatomic, copy) NSString * searchKeyWord; // 搜索的字符串
@property (nonatomic, copy) NSString * categoryId; // 分类ID
@property (nonatomic, copy) NSString * categoryType; // 类型

@end
