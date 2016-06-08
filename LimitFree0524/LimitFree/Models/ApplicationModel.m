//
//  ApplicationModel.m
//  LimitFree
//
//  Created by Chaosky on 16/5/11.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "ApplicationModel.h"

@implementation ApplicationModel

// 关联JSON数据中的key和类中的属性
// 字典中的key为属性，value为JSON数据中的key
// 当属性和JSON数据中的key不一致时会用到该方法，做映射
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc":@"description"};
}

@end
