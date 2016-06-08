//
//  AppDetailViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/17.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "AppDetailViewController.h"
#import "AppDetailModel.h"
// 定位服务
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Sino.h"
// 模型
#import "ApplicationModel.h"
// 友盟分享
#import "UMSocial.h"

// 大图页面
#import "BigPicViewController.h"

// 数据库表模型
#import "LimitFreeCollection.h"

// 小图浏览图片视图的开始标记值
const NSInteger SmallPicImageViewBeginTag = 100;
// 附近人正在使用App的图片视图开始标记值
const NSInteger NearAppImageViewBeginTag = 1000;

@interface AppDetailViewController ()<CLLocationManagerDelegate>
#pragma mark - UI
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cateLabel;
- (IBAction)shareAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
- (IBAction)favouriteAction:(UIButton *)sender;
- (IBAction)downloadAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *smallPicScrollView;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *nearAppScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallImageScrollViewHeightConstraint;

@property (nonatomic, strong) AppDetailModel * detailModel; // 应用详情模型数据

@property (nonatomic, strong) CLLocationManager * locationManager; // 定位管理对象

@property (nonatomic, strong) NSArray * nearAppArray; // 附近人正在使用的App列表

@end

@implementation AppDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestAppDetailWithId:self.applicationId];
    [self configLocationManger];
}

// 配置定位请求
- (void)configLocationManger
{
    self.locationManager = [[CLLocationManager alloc] init];
    // 精确度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // 刷新频率
    self.locationManager.distanceFilter = 100.0;
    // 设置委托
    self.locationManager.delegate = self;
    
    // 请求用户权限
    // 判断当前系统版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 请求WhenInUse权限
        [self.locationManager requestWhenInUseAuthorization];
        // 在info.plist文件中添加NSLocationWhenInUseUsageDescription
    }
    // 启动定位服务
    [self.locationManager startUpdatingLocation];
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

// 分享
- (IBAction)shareAction:(UIButton *)sender {
    
    // 分享文字
    NSString * shareText = [NSString stringWithFormat:@"应用名称：%@ 简介：%@ 下载地址：%@", _detailModel.name, _detailModel.desc, _detailModel.itunesUrl];
    
    // 分享图片
    UIImage * shareImage = self.iconImageView.image;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMSocialAppKey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:nil
                                       delegate:nil];
}
// 收藏按钮点击响应
- (IBAction)favouriteAction:(UIButton *)sender {
    LimitFreeCollection * model = [[LimitFreeCollection alloc] init];
    model.appName = _detailModel.name;
    model.appImage = _detailModel.iconUrl;
    model.appId = _detailModel.applicationId;
    BOOL isSuccess = [[DatabaseManager defaultManger] insertObject:model];
    if (isSuccess) {
        [KVNProgress showSuccessWithStatus:@"收藏成功"];
        sender.enabled = NO;
    }
    else {
        [KVNProgress showErrorWithStatus:@"收藏失败"];
        sender.enabled = YES;
    }
}

- (IBAction)downloadAction:(UIButton *)sender {
    // 下载App只能在真机上有效
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_detailModel.itunesUrl]];
}

// 重写方法
- (void)customNavigationItem
{
    [self addBackBarButtonItem];
    [self addNavigationTitle:@"应用详情"];
}

// 刷新视图
- (void)setupUI
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_detailModel.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    self.titleLabel.text = _detailModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"原价：￥%@，文件大小：%@M", _detailModel.lastPrice, _detailModel.fileSize];
    self.cateLabel.text = [NSString stringWithFormat:@"分类：%@，评分：%@", _detailModel.categoryName, _detailModel.starOverall];
    
    // 将图片添加到UIScrollView中
    CGFloat imageHeight = self.smallImageScrollViewHeightConstraint.constant;
    CGFloat imageWidth = 188/106.0 * imageHeight;
    
    __weak typeof(self) weakSelf = self;
    [_detailModel.photos enumerateObjectsUsingBlock:^(AppDetailPhotoModel * photoModel, NSUInteger idx, BOOL *stop) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx*imageWidth, 0, imageWidth, imageHeight)];
        [weakSelf.smallPicScrollView addSubview:imageView];
        // 加载图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.smallUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
        // 设置tag值
        imageView.tag = SmallPicImageViewBeginTag + idx;
        // 100~n
        // 添加手势识别器，UILabel和UIImageView用户交互默认关闭
        imageView.userInteractionEnabled = YES;
        // 创建点击手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSmallPicTap:)];
        // 将手势添加到视图上
        [imageView addGestureRecognizer:tapGesture];
    }];
    // 设置contentSize
    self.smallPicScrollView.contentSize = CGSizeMake(_detailModel.photos.count * imageWidth, imageHeight);
    // 关闭弹簧效果
    self.smallPicScrollView.bounces = NO;
    
    self.descTextView.text = _detailModel.desc;
    // 判断是否已收藏
    NSArray * collectionArray = [[DatabaseManager defaultManger] selectAllObjectFromClass:[LimitFreeCollection class]];
    for (LimitFreeCollection * model in collectionArray) {
        if ([model.appId isEqualToString:_detailModel.applicationId]) {
            // 已存在
            self.favouriteButton.enabled = NO;
            break;
        }
    }
}

// 小图点击响应方法
- (void)onSmallPicTap:(UITapGestureRecognizer *) sender
{
    // 获取手势点击的视图
    UIView * tapView = sender.view;
    // 点击位置
    NSInteger tapIndex = tapView.tag - SmallPicImageViewBeginTag;
    
    BigPicViewController * bigPicVC = [[BigPicViewController alloc] init];
    bigPicVC.photosArray = _detailModel.photos;
    bigPicVC.currentPageIndex = tapIndex;
    
    // 设置动画效果
    bigPicVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:bigPicVC animated:YES completion:nil];
}


// 加载附近人正在使用的App数据
- (void)setupNearApp
{
    // 获取UIScrollView的frame，调用该方法时，视图早已显示完成
    CGFloat imageHeight = self.nearAppScrollView.frame.size.height;
    CGFloat imageWidth = imageHeight;
    
    // 加载数据
    for (int idx = 0; idx < self.nearAppArray.count; idx++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx*imageWidth, 0, imageWidth, imageHeight)];
        [self.nearAppScrollView addSubview:imageView];
        // 获取数据模型
        ApplicationModel * model = self.nearAppArray[idx];
        // 加载图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
        // 设置tag值
        imageView.tag = NearAppImageViewBeginTag + idx;
        // 1000~n
        // 添加手势
        imageView.userInteractionEnabled = YES;
        // 创建手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNearAppImageTap:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    // 设置属性
    self.nearAppScrollView.contentSize = CGSizeMake(self.nearAppArray.count * imageWidth, imageHeight);
    self.nearAppScrollView.bounces = NO;
    
}

// tap手势回调方法
- (void)onNearAppImageTap:(UITapGestureRecognizer *) sender
{
    NSInteger tapIndex = sender.view.tag - NearAppImageViewBeginTag;
    // 取出对应位置的模型数据
    ApplicationModel * model = self.nearAppArray[tapIndex];
    // 创建应用详情
    AppDetailViewController * appDetailVC = [[AppDetailViewController alloc] init];
    appDetailVC.applicationId = model.applicationId;
    // Push显示
    [self.navigationController pushViewController:appDetailVC animated:YES];
}

#pragma mark - 数据相关

- (void)requestAppDetailWithId:(NSString *)appId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:kDetailUrl, appId];
    [self.httpManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 解析数据
        weakSelf.detailModel = [AppDetailModel yy_modelWithJSON:responseObject];
        // 加载数据，刷新视图
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupUI];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 先找到已添加的HUD
        MBProgressHUD * hud = [MBProgressHUD HUDForView:weakSelf.view];
        // 设置显示文本信息
        hud.labelText = error.localizedDescription;
        // 1秒钟之后隐藏HUD
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES afterDelay:1.0];
        });
    }];
}

// 请求附近人正在使用的App
- (void)requestNearApp:(CLLocation *) location
{
    __weak typeof(self) weakSelf = self;
    // 拼接URL
    NSString * url = [NSString stringWithFormat:kNearAppUrl, location.coordinate.longitude, location.coordinate.latitude];
    // 请求
    [self.httpManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * appsArray = responseObject[@"applications"];
        weakSelf.nearAppArray = [NSArray yy_modelArrayWithClass:[ApplicationModel class] json:appsArray];
        // 加载数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupNearApp];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - CLLocationManagerDelegate
// 授权状态改变时的回调，第一次进入App或者第一次请求用户权限
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // 当授权完成时，启动定位服务，获取定位信息
    if (status >= kCLAuthorizationStatusAuthorizedAlways) {
        [manager startUpdatingLocation];
    }
    else if (status == kCLAuthorizationStatusDenied)
    {
        // 不允许定位服务
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您已关闭定位，App的部分功能可能无法使用，请在设置中开启，么么哒" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

// 当定位服务返回定位信息时的回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        // 停止定位服务
        [manager stopUpdatingLocation];
        
        CLLocation * location = [locations lastObject];
        // 将地球坐标转换为火星坐标
        CLLocation * marsLocation = [location locationMarsFromEarth];
        [self requestNearApp:marsLocation];
    }
}

@end
