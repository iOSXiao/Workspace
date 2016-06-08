//
//  AppDetailModel.m
//  LimitFree
//
//  Created by Chaosky on 16/5/17.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "AppDetailModel.h"

@implementation AppDetailModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc":@"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"photos":[AppDetailPhotoModel class]};
}

@end
@implementation AppDetailPhotoModel

@end


