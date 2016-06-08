//
//  SubjectModel.m
//  LimitFree
//
//  Created by Chaosky on 16/5/13.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "SubjectModel.h"

@implementation SubjectModel

// 当属性中为数组时，需要关联其他类，使得数组中存放该类的对象
// 字典中的key为当前类的属性，value为要关联的类的class
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"applications" : [SubjectAppModel class]};
}

@end

@implementation SubjectAppModel

@end


