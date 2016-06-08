//
//  SettingViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/19.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "MySettingViewController.h"
#import "CollectionViewController.h"

NSString * const SettingCellIdentifier = @"SettingCell";

@interface SettingViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *settingCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray * settingImageNameArray; // 图片名字数组
@property (nonatomic, strong) NSArray * settingNameArray; // 设置名称数组

@end

@implementation SettingViewController

// 懒加载
- (NSArray *)settingImageNameArray
{
    if (!_settingImageNameArray) {
        _settingImageNameArray = @[@"account_setting",  @"account_favorite", @"account_user", @"account_collect", @"account_download", @"account_comment", @"account_help", @"account_candou"];
    }
    return _settingImageNameArray;
}

- (NSArray *)settingNameArray
{
    if (!_settingNameArray) {
        _settingNameArray = @[@"我的设置", @"我的关注", @"我的账号", @"我的收藏", @"我的下载", @"我的评论", @"我的帮助", @"蚕豆应用"];
    }
    return _settingNameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 重写方法
- (void)customNavigationItem
{
    [self addNavigationTitle:@"设置"];
    [self addBackBarButtonItem];
}

// 设置视图
- (void)configCollectionView
{
    // 注册单元格
    [self.settingCollectionView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellWithReuseIdentifier:SettingCellIdentifier];
    // 设置数据源和委托
    self.settingCollectionView.dataSource = self;
    self.settingCollectionView.delegate = self;
    // 设置单元格size
    self.flowLayout.itemSize = CGSizeMake(70, 100);
    // 单元格间距
    self.flowLayout.minimumInteritemSpacing = 30;
    // 行间距
    self.flowLayout.minimumLineSpacing = 30;
    
    // 设置段的内边距
    self.flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
    
    // 刷新视图
    [self.settingCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.settingImageNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SettingCellIdentifier forIndexPath:indexPath];
    cell.settingImageView.image = [UIImage imageNamed:self.settingImageNameArray[indexPath.row]];
    cell.settingNameLabel.text = self.settingNameArray[indexPath.row];
    return cell;
}

#pragma mark - UICollcetionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            // 获取StoryBoard对象
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            // 根据StoryBoard ID创建视图控制器
            MySettingViewController * mySettingVC = [sb instantiateViewControllerWithIdentifier:@"MySettingViewController"];
            [self.navigationController pushViewController:mySettingVC animated:YES];
        }
            break;
        case 3:
        {
            CollectionViewController * collectionVC = [[CollectionViewController alloc] init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
