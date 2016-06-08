//
//  SubjectAppView.m
//  LimitFree
//
//  Created by Chaosky on 16/5/13.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "SubjectAppView.h"
#import "StarView.h"
#import "SubjectModel.h"

@implementation SubjectAppView
{
    UIImageView * _iconImageView; // APP icon
    UILabel * _titleLabel;
    UILabel * _commentLabel;
    UILabel * _downloadLabel;
    StarView * _starView;
}

// 创建视图
- (void)createViews
{
    _iconImageView = [[UIImageView alloc] init];
    [self addSubview:_iconImageView];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _commentLabel = [[UILabel alloc] init];
    [self addSubview:_commentLabel];
    _commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _downloadLabel = [[UILabel alloc] init];
    [self addSubview:_downloadLabel];
    _downloadLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _starView = [[StarView alloc] init];
    [self addSubview:_starView];
    _starView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 建立约束
    __weak typeof(self) weakSelf = self;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 左对齐、顶部对齐
        make.left.top.equalTo(weakSelf);
        // 宽高相等，并且等于父视图的高度
        make.width.equalTo(_iconImageView.mas_height);
        make.height.equalTo(weakSelf.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView.mas_top);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.right.equalTo(weakSelf.mas_right).offset(-5);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        // 左对齐
        make.left.equalTo(_titleLabel.mas_left);
        make.centerY.equalTo(_iconImageView.mas_centerY);
    }];
    
    [_downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel.mas_right);
        make.centerY.equalTo(_iconImageView.mas_centerY);
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@65);
        make.height.equalTo(@23);
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_iconImageView.mas_bottom);
    }];
}


// 重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createViews];
    }
    return self;
}


- (void)setAppModel:(SubjectAppModel *)appModel
{
    _appModel = appModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_appModel.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    _titleLabel.text = _appModel.name;
    
    _commentLabel.attributedText = [self mixImage:[UIImage imageNamed:@"topic_Comment"] andText:_appModel.ratingOverall];
    
    _downloadLabel.attributedText = [self mixImage:[UIImage imageNamed:@"topic_Download"] andText:_appModel.downloads];
    
    _starView.starValue = [_appModel.starOverall floatValue];
}

// 封装图文混排方法
- (NSAttributedString *)mixImage:(UIImage *)image andText:(NSString *)text
{
    // 用富文本实现图文混排
    // 将图片转换为文本附件对象
    NSTextAttachment * commentAttachment = [[NSTextAttachment alloc] init];
    commentAttachment.image = image;
    // 将文本附件对象转换为富文本
    NSAttributedString * commentAttachAttr = [NSAttributedString attributedStringWithAttachment:commentAttachment];
    // 将文字转换为富文本
    NSAttributedString * commentCountAttr = [[NSAttributedString alloc] initWithString:text  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
    
    // 拼接所有富文本
    NSMutableAttributedString * commentAttr = [[NSMutableAttributedString alloc] init];
    [commentAttr appendAttributedString:commentAttachAttr];
    [commentAttr appendAttributedString:commentCountAttr];
    return [commentAttr copy];
}


@end
