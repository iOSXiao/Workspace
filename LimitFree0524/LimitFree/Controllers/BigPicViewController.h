//
//  BigPicViewController.h
//  LimitFree
//
//  Created by Chaosky on 16/5/18.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "BaseViewController.h"

@interface BigPicViewController : BaseViewController

// 图片数组
@property (nonatomic, strong) NSArray * photosArray;

// 当前图片的位置
@property (nonatomic, assign) NSInteger currentPageIndex;

@end
