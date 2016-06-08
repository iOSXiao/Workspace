//
//  SubjectCell.h
//  LimitFree
//
//  Created by Chaosky on 16/5/13.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

@interface SubjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *subjectImageView;
@property (weak, nonatomic) IBOutlet UIView *appListView;
@property (weak, nonatomic) IBOutlet UIImageView *descImageView;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;

// 关联数据模型
@property (nonatomic, strong) SubjectModel * model;

@end
