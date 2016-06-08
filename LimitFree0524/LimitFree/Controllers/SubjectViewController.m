//
//  SubjectViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/10.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "SubjectViewController.h"
#import "SubjectCell.h"
#import "SubjectModel.h"

NSString * const SubjectCellIdentifier = @"SubjectCell";

@interface SubjectViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView * subjectTableView; // 专题表格视图
@property (nonatomic, strong) NSMutableArray * subjectArray; // 数据源
@property (nonatomic, assign) NSUInteger currentPage; // 当前页

@end

@implementation SubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage = 1;
    [self createViews];
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
// 重写方法定制导航项
- (void)customNavigationItem
{
    [self addNavigationTitle:self.title];
}

- (void)createViews
{
    __weak typeof(self) weakSelf = self;
    _subjectTableView = [[UITableView alloc] init];
    [self.view addSubview:_subjectTableView];
    _subjectTableView.translatesAutoresizingMaskIntoConstraints = NO;
    // 建立约束
    [_subjectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    // 设置属性
    _subjectTableView.dataSource = self;
    // 设置行高
    _subjectTableView.rowHeight = 300;
    
    // header和footer
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf requestSubjectWithPage:weakSelf.currentPage];
        weakSelf.subjectTableView.mj_footer.hidden = YES;
    }];
    _subjectTableView.mj_header = header;
    // 配置header
    [header setTitle:@"爷爷等得好辛苦，快来扶我" forState:MJRefreshStateIdle];
    [header setTitle:@"爷爷摔倒了" forState:MJRefreshStatePulling];
    [header setTitle:@"开开心心扶老爷爷" forState:MJRefreshStateRefreshing];
    
    _subjectTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf requestSubjectWithPage:weakSelf.currentPage];
        weakSelf.subjectTableView.mj_header.hidden = YES;
    }];
    
    // 注册单元格
    [_subjectTableView registerNib:[UINib nibWithNibName:@"SubjectCell" bundle:nil] forCellReuseIdentifier:SubjectCellIdentifier];
    
    // 开始加载
    [_subjectTableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 复用单元格
    SubjectCell * cell = [tableView dequeueReusableCellWithIdentifier:SubjectCellIdentifier forIndexPath:indexPath];
    
    // 获取数据模型
    SubjectModel * model = self.subjectArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

#pragma mark - 数据相关
- (void)requestSubjectWithPage:(NSUInteger)page
{
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:kSubjectUrl, page];
    [self.httpManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (!weakSelf.subjectArray) {
            weakSelf.subjectArray = [NSMutableArray array];
        }
        
        // 解析数据
        NSArray * subjectModelArray = [NSArray yy_modelArrayWithClass:[SubjectModel class] json:responseObject];
        // 判断是否为首页
        if (page == 1) {
            [weakSelf.subjectArray removeAllObjects];
        }
        // 添加解析完成的数据
        [weakSelf.subjectArray addObjectsFromArray:subjectModelArray];
        
        // 刷新视图
        // 更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新UITableView
            [weakSelf.subjectTableView reloadData];
            // 更新Header和footer的状态
            [weakSelf.subjectTableView.mj_header endRefreshing];
            [weakSelf.subjectTableView.mj_footer endRefreshing];
            weakSelf.subjectTableView.mj_header.hidden = NO;
            weakSelf.subjectTableView.mj_footer.hidden = NO;
            // 处理全部加载完成的情况
            if (subjectModelArray.count < 5) {
                // 数据全部请求完毕
                [weakSelf.subjectTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                // 当当前请求的数据小于totalCount时，重置footer的状态
                [weakSelf.subjectTableView.mj_footer resetNoMoreData];
            }
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [KVNProgress showErrorWithStatus:error.localizedDescription];
        // 将自增的page减下来
        if (weakSelf.currentPage > 1) {
            weakSelf.currentPage--;
        }
    }];
}

@end
