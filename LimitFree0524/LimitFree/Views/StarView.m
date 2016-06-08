//
//  StarView.m
//  LimitFree
//
//  Created by Chaosky on 16/5/12.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "StarView.h"

@implementation StarView
{
    UIImageView * _foregroundImageView; // 前景图
    UIImageView * _backgroundImageView; // 背景图
}

// 创建视图
- (void)createViews
{
    _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsBackground"]];
    [self addSubview:_backgroundImageView];
    // 设置图片属性
    _backgroundImageView.contentMode = UIViewContentModeLeft;
    
    // 创建前景图
    _foregroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsForeground"]];
    [self addSubview:_foregroundImageView];
    // 设置内容显示模式
    _foregroundImageView.contentMode = UIViewContentModeLeft;
    // 裁剪视图
    _foregroundImageView.clipsToBounds = YES;
}

// 当自定义的视图和xib或者StoryBoard中对应的视图关联后，xib或者StoryBoard会调用该方法创建对象
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect customRect = CGRectMake(frame.origin.x, frame.origin.y, 65, 23);
    if (self = [super initWithFrame:customRect]) {
        [self createViews];
    }
    return self;
}

- (void)setStarValue:(CGFloat)starValue
{
    _starValue = starValue;
    if (_starValue < 0 || _starValue > 5) {
        return;
    }
    // 处理前景图
    CGRect rect = _backgroundImageView.frame;
    rect.size.width = rect.size.width * (_starValue / 5.0);
    // 设置前景图的frame
    _foregroundImageView.frame = rect;
}


@end
