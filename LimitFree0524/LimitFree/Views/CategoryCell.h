//
//  CategoryCell.h
//  LimitFree
//
//  Created by Chaosky on 16/5/12.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *categoryCountLabel;

@end
