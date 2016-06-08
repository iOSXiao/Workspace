//
//  CollectionCell.h
//  LimitFree
//
//  Created by Chaosky on 16/5/20.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
