//
//  AppListCell.h
//  LimitFree
//
//  Created by Chaosky on 16/5/11.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationModel.h"
#import "StarView.h"

@interface AppListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet StarView *starView;

// 绑定数据模型
@property (nonatomic, strong) ApplicationModel * model;

@end
