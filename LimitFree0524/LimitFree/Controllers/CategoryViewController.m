//
//  CategoryViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/12.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryCell.h"
#import "CategoryModel.h"

// 复用标识
NSString * const CategoryCellIdentifier = @"CategoryCell";

@interface CategoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * categoryTableView;
@property (nonatomic, strong) NSArray * categoryArray; // 数据源

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}

- (void)customNavigationItem
{
    [self addNavigationTitle:[NSString stringWithFormat:@"%@分类", self.categoryTypeName]];
    [self addBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createViews
{
    __weak typeof(self) weakSelf = self;
    _categoryTableView = [[UITableView alloc] init];
    [self.view addSubview:_categoryTableView];
    _categoryTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    _categoryTableView.dataSource = self;
    _categoryTableView.delegate = self;
    _categoryTableView.rowHeight = 100;
    
    _categoryTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestCategoryData];
    }];
    // 注册单元格
    [_categoryTableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:CategoryCellIdentifier];
    
    [_categoryTableView.mj_header beginRefreshing];
}

// 请求分类数据
- (void)requestCategoryData
{
    __weak typeof(self) weakSelf = self;
    [self.httpManager GET:kCateUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 数据解析
        weakSelf.categoryArray = [NSArray yy_modelArrayWithClass:[CategoryModel class] json:responseObject];
        // 加载数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.categoryTableView reloadData];
            [weakSelf.categoryTableView.mj_header endRefreshing];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.categoryTableView.mj_header endRefreshing];
            [KVNProgress showErrorWithStatus:error.localizedDescription];
        });
        
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 复用单元格
    CategoryCell * cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier forIndexPath:indexPath];
    // 填充数据
    CategoryModel * model = self.categoryArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"category_All.jpg"]];
    cell.categoryName.text = model.categoryCname;
    cell.categoryCountLabel.text = [NSString stringWithFormat:@"共%@款应用，其中%@有%@款", model.categoryCount, self.categoryTypeName, [model valueForKey:self.categoryType]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取选中单元格的数据
    CategoryModel * model = self.categoryArray[indexPath.row];
    // 调用block
    if (self.block) {
        self.block(model.categoryId);
    }
    // Pop
    [self.navigationController popViewControllerAnimated:YES];
}

@end
