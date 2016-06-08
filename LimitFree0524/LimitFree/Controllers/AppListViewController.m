//
//  AppListViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/11.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "AppListViewController.h"
#import "AppListCell.h"
#import "ApplicationModel.h"
#import "AppSearchViewController.h"
#import "CategoryViewController.h"
#import "AppDetailViewController.h"
#import "SettingViewController.h"

// 尽可能多的使用常量，少使用宏定义
NSString * const AppListCellIdentifier = @"AppListCell";

@interface AppListViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView * appListTableView; // 应用列表
@property (nonatomic, strong) NSMutableArray * appListArray; // 应用列表数据源
@property (nonatomic, strong) UISearchBar * searchBar; // 搜索框

@property (nonatomic, assign) NSUInteger currentPage; // 记录当前请求页数

@end

@implementation AppListViewController

// 懒加载
- (NSMutableArray *)appListArray
{
    if (!_appListArray) {
        _appListArray = [NSMutableArray array];
    }
    return _appListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置属性初始值
    self.currentPage = 1;
    
    [self createViews];
    
    [self firstLoad];
}

// 第一次加载
- (void)firstLoad
{
    self.currentPage = 1;
    [self.appListTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 重写定制NavigationItem
- (void)customNavigationItem
{
    // 左侧分类按钮
    [self addMainBarButtonItemWithTitle:@"分类" target:self action:@selector(categoryAction) isLeft:YES];
    // 右侧设置按钮
    [self addMainBarButtonItemWithTitle:@"设置" target:self action:@selector(settingAction) isLeft:NO];
    // 设置标题
    [self addNavigationTitle:self.title];
}

- (void)categoryAction
{
    CategoryViewController * categoryVC = [[CategoryViewController alloc] init];
    categoryVC.categoryType = self.categoryType;
    categoryVC.categoryTypeName = self.title;
    categoryVC.hidesBottomBarWhenPushed = YES;
    
    // 给block赋值
    __weak typeof(self) weakSelf = self;
    categoryVC.block = ^(NSString * cateId) {
        weakSelf.categoryId = cateId;
        // 加载数据
        [weakSelf firstLoad];
    };
    
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (void)settingAction
{
    SettingViewController * settingVC = [[SettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 视图相关
- (void)createViews
{
    self.appListTableView = [[UITableView alloc] init];
    self.appListTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.appListTableView];
    // 建立约束
    // 在block中使用self中的属性、成员变量方法需要使用弱引用
    __weak typeof(self) weakSelf = self;
    [self.appListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    // 设置数据源
    self.appListTableView.dataSource = self;
    // 设置委托
    self.appListTableView.delegate = self;
    
    // 设置行高
    self.appListTableView.rowHeight = 150;
    
    // 注册单元格，nib是xib文件编译后二进制的文件
    [self.appListTableView registerNib:[UINib nibWithNibName:@"AppListCell" bundle:nil] forCellReuseIdentifier:AppListCellIdentifier];
    
    // 添加下拉刷新和上拉加载
    self.appListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        // 隐藏footer
        weakSelf.appListTableView.mj_footer.hidden = YES;
        [weakSelf requestAppListWithPage:weakSelf.currentPage searchText:weakSelf.searchKeyWord categoryId:weakSelf.categoryId];
    }];
    
    self.appListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        // 隐藏header
        weakSelf.appListTableView.mj_header.hidden = YES;
        [weakSelf requestAppListWithPage:weakSelf.currentPage searchText:weakSelf.searchKeyWord categoryId:weakSelf.categoryId];
    }];
    
    // 创建UISearchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    self.appListTableView.tableHeaderView = self.searchBar;
    // 设置委托
    self.searchBar.delegate = self;
    // 设置占位符
    self.searchBar.placeholder = @"百万应用等你来搜哟";
    // 设置是否取消按钮
    self.searchBar.showsCancelButton = YES;
    // 设置returntype
    self.searchBar.returnKeyType = UIReturnKeySearch;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 复用单元格
    AppListCell * cell = [tableView dequeueReusableCellWithIdentifier:AppListCellIdentifier forIndexPath:indexPath];
//    [tableView dequeueReusableCellWithIdentifier:<#(nonnull NSString *)#>];
    
    // 获取指定位置的数据
    ApplicationModel * model = self.appListArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDetailViewController * appDetailVC = [[AppDetailViewController alloc] init];
    // 获取数据模型
    ApplicationModel * model = self.appListArray[indexPath.row];
    
    appDetailVC.applicationId = model.applicationId;
    
    appDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:appDetailVC animated:YES];
}

#pragma mark - 数据相关

- (void)requestAppListWithPage:(NSUInteger)page searchText:(NSString *)keyword categoryId:(NSString *)cateId
{
    // 拼接URL地址,nil格式化的时候会创建【(null)】
    NSString * url = [NSString stringWithFormat:self.requestURL, page, keyword.length > 0 ? keyword : @""];
    // 追加分类，判断是否为nil，是否为0
    if (cateId.length > 0 && ![cateId isEqualToString:@"0"]) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&cate_id=%@", cateId]];
    }
    // 百分号编码
    NSString * percentURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    // 请求数据
    [self.httpManager GET:percentURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 解析数据
        NSArray * appArray = responseObject[@"applications"];
        NSInteger totalCount = [responseObject[@"totalCount"] integerValue];
        // 转换为模型数组
        NSArray * appModelArray = [NSArray yy_modelArrayWithClass:[ApplicationModel class] json:appArray];
        NSLog(@"appModelArray count = %ld", appModelArray.count);
        // 判断是否为page=1，首次加载，下拉刷新
        if (page == 1) {
            // 移除数据源中所有数据
            [weakSelf.appListArray removeAllObjects];
        }
        [weakSelf.appListArray addObjectsFromArray:appModelArray];
        // 更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新UITableView
            [weakSelf.appListTableView reloadData];
            // 更新Header和footer的状态
            [weakSelf.appListTableView.mj_header endRefreshing];
            [weakSelf.appListTableView.mj_footer endRefreshing];
            weakSelf.appListTableView.mj_header.hidden = NO;
            weakSelf.appListTableView.mj_footer.hidden = NO;
            // 处理全部加载完成的情况
            if (totalCount <= weakSelf.appListArray.count) {
                // 数据全部请求完毕
                [weakSelf.appListTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                // 当当前请求的数据小于totalCount时，重置footer的状态
                [weakSelf.appListTableView.mj_footer resetNoMoreData];
            }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@", error.localizedDescription);
    }];
}

#pragma mark - UISearchBarDelegate
// 当点击键盘上搜索按钮时的回调方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    // 获取搜索的字符串@"       " @""
    NSString * searchText = searchBar.text;
    // 规避搜索字符串为空或者字符串中全为空格字符
    NSString * placeholderText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    // nil,空对象，NSNull,NULL
    if (searchText.length <= 0 || placeholderText.length == 0) {
        return;
    }
    // 创建搜索视图控制器
    AppSearchViewController * appSearchVC = [[AppSearchViewController alloc] init];
    appSearchVC.requestURL = self.requestURL;
    appSearchVC.categoryId = self.categoryId;
    appSearchVC.searchKeyWord = searchText;
    // 设置标题
    appSearchVC.title = searchText;
    
    appSearchVC.hidesBottomBarWhenPushed = YES;
    // push
    [self.navigationController pushViewController:appSearchVC animated:YES];
    
    // 第二种在当前页面搜索
//    self.searchKeyWord = searchText;
//    [self firstLoad];
}

// 第二种方式需要实现
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = nil;
//    self.searchKeyWord = nil;
//    [self firstLoad];
}

@end



