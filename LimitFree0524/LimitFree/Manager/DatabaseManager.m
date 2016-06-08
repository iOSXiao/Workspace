//
//  DatabaseManager.m
//  LimitFree
//
//  Created by Chaosky on 16/5/19.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDB.h>
// 运行时的头文件
#import <objc/runtime.h>

@implementation DatabaseManager
{
    FMDatabase * _fmDatabase; // 数据库管理对象
}

// 重写init
- (instancetype)init
{
    // 抛出异常，不允许调用init方法
    @throw [NSException exceptionWithName:@"不允许调用init方法" reason:@"DatabaseManager是一个单例，只能通过defaultManger方法获取对象" userInfo:nil];
}

// 私有方法创建
- (instancetype)initPrivate
{
    if (self = [super init]) {
        // 干些事情
        [self createDB];
    }
    return self;
}

+ (instancetype)defaultManger
{
    static DatabaseManager * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[DatabaseManager alloc] initPrivate];
        }
    });
    return instance;
}

// 创建数据库
- (void)createDB
{
    // 参数1：找寻目录的名字
    // 参数2：在哪个目录下查找，用户目录
    // 参数3：是否展开波浪号
    NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = [searchPaths lastObject];
    // 拼接数据库保存路径
    NSString * dbPath = [documentPath stringByAppendingPathComponent:@"LimitFree.db"];
    NSLog(@"db path = %@", dbPath);
    
    // 创建数据库管理对象
    _fmDatabase = [[FMDatabase alloc] initWithPath:dbPath];
    // 打开数据库
    if (![_fmDatabase open]) {
        NSLog(@"数据库打开失败");
        @throw [NSException exceptionWithName:@"数据库打开失败" reason:@"未知" userInfo:nil];
    }
}

- (BOOL)createTableFromClass:(Class)tableClass
{
    // 从Class中获取类名
    NSString * tableName = NSStringFromClass(tableClass);
    // 获取所有属性
    NSArray * propertyArray = [self getAllPropertiesFromClass:tableClass];
    // [a, b, c]
    // SQLite无类型数据库
    NSString * filedStr = [propertyArray componentsJoinedByString:@","];
    // "a,b,c"
    
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE t_%@ (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, %@);", tableName, filedStr];
    // 执行SQL
    return [_fmDatabase executeUpdate:sql];
}

- (BOOL)insertObject:(id)obj
{
    // 创建数据库表
    [self createTableFromClass:[obj class]];
    // 获取表名
    Class tableClass = [obj class];
    NSString * tableName = NSStringFromClass(tableClass);
    // 获取属性
    NSArray * propertyArray = [self getAllPropertiesFromClass:tableClass];
    
    // 获取属性的值
    NSArray * propValuesArray = [self getAllPropertyValuesFromObject:obj];
    
    NSString * propStr = [propertyArray componentsJoinedByString:@","];
    
    NSMutableArray * placeholderArray = [NSMutableArray array];
    
    for (NSString * prop in propertyArray) {
        [placeholderArray addObject:@"?"];
    }
    // 拼接?
    NSString * placeholderStr = [placeholderArray componentsJoinedByString:@","];
    
    // 利用SQL语句中statement占位符
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO t_%@ (%@) VALUES (%@);", tableName, propStr, placeholderStr];
    NSLog(@"insert sql = %@", insertSql);
    // 执行sql语句
    NSError * error = nil;
    return [_fmDatabase executeUpdate:insertSql values:propValuesArray error:&error];
}

- (BOOL)deleteObject:(id)obj
{
    NSString * tableName = NSStringFromClass([obj class]);
    NSString * ID = [obj valueForKey:@"ID"];
    NSString * deleteSql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE ID=%@;", tableName, ID];
    return [_fmDatabase executeUpdate:deleteSql];
}

- (NSArray *)selectAllObjectFromClass:(Class)tableClass
{
    NSString * tableName = NSStringFromClass(tableClass);
    NSString * selectAllSql = [NSString stringWithFormat:@"SELECT * FROM t_%@", tableName];
    // 返回结果集
    FMResultSet * resultSet = [_fmDatabase executeQuery:selectAllSql];
    // 遍历结果集
    // 获取所有属性名称
    NSArray * propertyArray = [self getAllPropertiesFromClass:tableClass];
    
    // 创建数组存储所有取出的数据
    NSMutableArray * objectArray = [NSMutableArray array];
    
    while ([resultSet next]) {
        // 根据Class信息创建对象
        id object = [[tableClass alloc] init];
        // 遍历所有属性
        for (NSString * prop in propertyArray) {
            // 从结果集中取出数据并为对象赋值
            id columnValue = [resultSet objectForColumnName:prop];
            // 通过KVC方式为对象的属性赋值
            [object setValue:columnValue forKey:prop];
        }
        
        // 取出ID值
        NSInteger ID = [resultSet intForColumn:@"ID"];
        
        [object setValue:[NSNumber numberWithInteger:ID] forKey:@"ID"];
        
        [objectArray addObject:object];
    }
    return [objectArray copy];
}

- (BOOL)isExistWithObject:(id)obj
{
    NSString * tableName = NSStringFromClass([obj class]);
    NSNumber * ID = [obj valueForKey:@"ID"];
    NSString * selectSql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM t_%@ WHERE ID=%@", tableName, ID];
    // 执行SQL
    FMResultSet * resultSet = [_fmDatabase executeQuery:selectSql];
    while ([resultSet next]) {
        // 判断取出的数据大小
        int columnNum = [resultSet intForColumnIndex:0];
        if (columnNum == 0) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Runtime
// 通过运行时获取Class中的所有属性
- (NSArray *)getAllPropertiesFromClass:(Class)tableClass
{
    NSMutableArray * propArray = [NSMutableArray array];
    // 获取class中的属性名称
    unsigned int propCount = 0;
    // 返回值为存储着【objc_property_t 】的数组
    objc_property_t * propertyTypeArray = class_copyPropertyList(tableClass, &propCount);
    // 循环遍历数组
    for (int idx = 0; idx < propCount; idx++) {
        // 从数组中取出数据
        objc_property_t propertyType = propertyTypeArray[idx];
        // 获取属性名称
        const char * propertyName = property_getName(propertyType);
        NSString * propStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propArray addObject:propStr];
    }
    return [propArray copy];
}

// 获取对象中所有属性的值
- (NSArray *)getAllPropertyValuesFromObject:(id)object
{
    NSArray * propertyArray = [self getAllPropertiesFromClass:[object class]];
    NSMutableArray * propValuesArray = [NSMutableArray array];
    
    for (NSString * prop in propertyArray) {
        // 通过KVC方式访问获取对象的属性值
        id propValue = [object valueForKey:prop];
        if (!propValue) {
            [propValuesArray addObject:[NSNull null]];
        }
        else {
            [propValuesArray addObject:propValue];
        }
    }
    return [propValuesArray copy];
}


@end
