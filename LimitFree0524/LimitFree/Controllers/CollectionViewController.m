//
//  CollectionViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/20.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import "LimitFreeCollection.h"

// 单元格复用标识
NSString * const CollectionCellIdentifier = @"CollectionCell";

@interface CollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray * collectionArray; // 数据源

@property (nonatomic, assign) BOOL isEditing; // 判断当前是否处于编辑状态

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configDataSource];
    [self configCollectionView];
}

- (void)customNavigationItem
{
    [self addBackBarButtonItem];
    [self addNavigationTitle:@"我的收藏"];
    [self addMainBarButtonItemWithTitle:@"编辑" target:self action:@selector(onEditAction:) isLeft:NO];
}

- (void)onEditAction:(UIButton *)sender
{
    if (self.isEditing) {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        self.isEditing = NO;
    }
    else {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.isEditing = YES;
    }
    // 刷新视图
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 配置CollectionView
- (void)configCollectionView
{
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:CollectionCellIdentifier];
    
    // 设置数据源和委托
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // 设置单元格size
    self.flowLayout.itemSize = CGSizeMake(80, 110);
    // 单元格间距
    self.flowLayout.minimumInteritemSpacing = 20;
    // 行间距
    self.flowLayout.minimumLineSpacing = 20;
    
    // 设置段的内边距
    self.flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
    
    // 刷新视图
    [self.collectionView reloadData];
}

// 设置数据源
- (void)configDataSource
{
    // 获取数据库表中所有数据
    NSArray * collectionArray = [[DatabaseManager defaultManger] selectAllObjectFromClass:[LimitFreeCollection class]];
    if (!self.collectionArray) {
        self.collectionArray = [NSMutableArray array];
    }
    [self.collectionArray removeAllObjects];
    
    // 添加数组中的数据
    [self.collectionArray addObjectsFromArray:collectionArray];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 复用
    CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellIdentifier forIndexPath:indexPath];
    // 取出模型数据
    LimitFreeCollection * model = self.collectionArray[indexPath.row];
    // 赋值
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    cell.appNameLabel.text = model.appName;
    
    // 判断单元格状态
    if (self.isEditing) {
        // 有动画效果，显示删除按钮
        cell.deleteButton.hidden = NO;
        // 动画效果
        cell.transform = CGAffineTransformMakeRotation(-0.05)
        ;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
            cell.transform = CGAffineTransformMakeRotation(0.05);
        } completion:nil];
    }
    else {
        // 取消动画，隐藏删除按钮
        cell.deleteButton.hidden = YES;
        // 形变置零
        cell.transform = CGAffineTransformIdentity;
        // 移除所有动画
        [cell.layer removeAllAnimations];
    }
    
    // 给删除按钮添加事件
    [cell.deleteButton addTarget:self action:@selector(deleteCellAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

// 删除
- (void)deleteCellAction:(UIButton *) sender
{
    // 找到单元格，button -> contentView -> Cell
    CollectionCell * cell;
    UIView * superView = sender.superview;
    while (superView) {
        // 判断父视图是否为CollectionCell
        if ([superView isKindOfClass:[CollectionCell class]]) {
            // 找到了
            cell = (id)superView;
            break;
        }
        else {
            // 继续找
            superView = superView.superview;
        }
    }
    // 删除UI？还是删除数据？为什么？
    // PS：先删除数据，后删除UI
    // 获取单元格所在的indexPath
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    
    
    // 获取模型数据
    LimitFreeCollection * model = self.collectionArray[indexPath.row];
    // 删除数据库中的数据
    [[DatabaseManager defaultManger] deleteObject:model];
    
    // 先删除数据
    [self.collectionArray removeObjectAtIndex:indexPath.row];
    
    // 后删除UI
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    // 延迟刷新动画
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
    
}


@end
