//
//  CategoryViewController.h
//  LimitFree
//
//  Created by Chaosky on 16/5/12.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "BaseViewController.h"

// 分类页面传递数据到AppListViewController的block
typedef void(^CategoryValueBlock)(NSString * cateId);

@interface CategoryViewController : BaseViewController

@property (nonatomic, copy) NSString * categoryType; // 类型：限免、降价、免费、热榜
@property (nonatomic, copy) NSString * categoryTypeName; // 中文的类型名称
@property (nonatomic, copy) CategoryValueBlock  block; // block回调

@end
