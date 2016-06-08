//
//  LimitFreeCollection.h
//  LimitFree
//
//  Created by Chaosky on 16/5/20.
//  Copyright © 2016年 1000phone. All rights reserved.
//

// 数据库的收藏表
#import <Foundation/Foundation.h>

@interface LimitFreeCollection : NSObject
{
    NSInteger _ID;
}

@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * appName;
@property (nonatomic, copy) NSString * appImage;

@end
