//
//  AppListCell.m
//  LimitFree
//
//  Created by Chaosky on 16/5/11.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "AppListCell.h"

@implementation AppListCell

// 当从nib文件中视图加载时的调用
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 设置圆角
    self.iconImageView.layer.cornerRadius = 50;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ApplicationModel *)model
{
    _model = model;
    // 加载数据
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    self.titleLabel.text = _model.name;
    self.dateLabel.text = _model.expireDatetime;
    // 在iOS使用富文本
//    NSMutableAttributedString
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    // 设置背景色
//    attributes[NSBackgroundColorAttributeName] = [UIColor purpleColor];
    // 设置前景色
//    attributes[NSForegroundColorAttributeName] = [UIColor redColor];
    // 设置删字符
    // 颜色
    attributes[NSStrikethroughColorAttributeName] = [UIColor purpleColor];
    // 样式
    attributes[NSStrikethroughStyleAttributeName] = @2;
    
    NSAttributedString * priceAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", _model.lastPrice] attributes:attributes];
    // 设置UILabel的富文本显示
    self.priceLabel.attributedText = priceAttr;
    
    self.categoryLabel.text = _model.categoryName;
    
    NSString * msg = [NSString stringWithFormat:@"分享：%@次 收藏：%@次 下载：%@次", _model.shares, _model.favorites, _model.downloads];
    self.msgLabel.text = msg;
    
    self.starView.starValue = [_model.starOverall floatValue];
}

@end
