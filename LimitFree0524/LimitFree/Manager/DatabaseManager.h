//
//  DatabaseManager.h
//  LimitFree
//
//  Created by Chaosky on 16/5/19.
//  Copyright © 2016年 1000phone. All rights reserved.
//
// 数据库管理类：单例
// 利用Runtime机制，实现通用数据库操作
#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

+ (instancetype)defaultManger;

// 创建数据库表
- (BOOL)createTableFromClass:(Class) tableClass;
// 添加数据
- (BOOL)insertObject:(id) obj;
// 删除数据
- (BOOL)deleteObject:(id) obj;
// 查询所有数据
- (NSArray *)selectAllObjectFromClass:(Class)tableClass;
// 判断某个数据在数据库表中是否存在
- (BOOL)isExistWithObject:(id) obj;

@end
