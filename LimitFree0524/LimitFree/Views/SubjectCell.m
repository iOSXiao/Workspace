//
//  SubjectCell.m
//  LimitFree
//
//  Created by Chaosky on 16/5/13.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "SubjectCell.h"
#import "SubjectAppView.h"

@implementation SubjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SubjectModel *)model
{
    _model = model;
    // 刷新视图
    _subjectTitleLabel.text = _model.title;
    
    [_subjectImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"topic_TopicImage_Default"]];
    
    [_descImageView sd_setImageWithURL:[NSURL URLWithString:_model.desc_img] placeholderImage:[UIImage imageNamed:@"topic_Header"]];
    
    _descTextView.text = _model.desc;
    
    // 移除AppListView中所有的子视图
    if (self.appListView.subviews.count > 0) {
        [self.appListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    // 设置AppListView，填充SubjectAppView
    // 记录上一个视图
    UIView * prefixView = self.appListView;
    __weak typeof(self) weakSelf = self;
    for (int idx = 0; idx < _model.applications.count; idx++) {
        // 取出数组中的数据
        SubjectAppModel * appModel = _model.applications[idx];
        // 创建视图
        SubjectAppView * appView = [[SubjectAppView alloc] init];
        [self.appListView addSubview:appView];
        appView.appModel = appModel;
        
        // 建立约束
        [appView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.appListView.mas_left);
            make.right.equalTo(weakSelf.appListView.mas_right);
            make.height.equalTo(weakSelf.appListView.mas_height).multipliedBy(1/4.0);
            // 第一个
            if (idx == 0) {
                make.top.equalTo(prefixView.mas_top);
            } else {
                make.top.equalTo(prefixView.mas_bottom);
            }
        }];
        // 更新前一个视图
        prefixView = appView;
        
    }
}

@end
