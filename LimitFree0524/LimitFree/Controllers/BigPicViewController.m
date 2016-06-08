//
//  BigPicViewController.m
//  LimitFree
//
//  Created by Chaosky on 16/5/18.
//  Copyright © 2016年 1000phone. All rights reserved.
//

#import "BigPicViewController.h"
#import "AppDetailModel.h"

@interface BigPicViewController ()<UIScrollViewDelegate>
#pragma mark - UI
@property (weak, nonatomic) IBOutlet UILabel *currentPageLabel;
- (IBAction)finishAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *bigPicScrollView;
- (IBAction)saveAction:(UIButton *)sender;
- (IBAction)shareAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *showOrHiddenViewArray;

@end

@implementation BigPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViews];
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

- (IBAction)finishAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveAction:(UIButton *)sender {
    
    // 提示用户
    [KVNProgress showWithStatus:@"正在保存图片中，请稍候，萌萌哒！"];
    
    UIImageView * currentImageView = self.bigPicScrollView.subviews[self.currentPageIndex];
    UIImage * saveImage = currentImageView.image;

    // 底层实现比较不是地址，而是hash值
    if ([saveImage isEqual:[UIImage imageNamed:@"egopv_photo_placeholder"]]) {
        
        // 获取数据模型
        AppDetailPhotoModel * photoModel = self.photosArray[self.currentPageIndex];
        
        __weak typeof(self) weakSelf = self;
        // 请求数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 耗时操作，同步请求数据
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoModel.originalUrl]];
            // 回到主队列中保存图片
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * image = [[UIImage alloc] initWithData:imageData];
                // 参数1：保存的图片对象
                // 参数2、3：当保存完成时的回调方法
                // 参数4：上下文环境为nil
                UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(bigPicImage:didFinishSavingWithError:contextInfo:), nil);
            });
            
        });
    }
    else {
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(bigPicImage:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

- (void)bigPicImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        // 保存失败
        [KVNProgress showErrorWithStatus:[NSString stringWithFormat:@"保存失败，错误为：%@", error.localizedDescription]];
    }
    else {
        [KVNProgress showSuccessWithStatus:@"保存图片成功，科科！"];
    }
}

- (IBAction)shareAction:(UIButton *)sender {
    UIImageView * currentImageView = self.bigPicScrollView.subviews[self.currentPageIndex];
    UIImage * shareImage = currentImageView.image;
    UIActivityViewController * activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareImage] applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

// 装载数据
- (void)setupViews
{
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.currentPageIndex+1, self.photosArray.count];
    // 添加图片添加到UIScrollView，图片的尺寸要让服务器返回
    CGFloat imageWidth = kScreenSize.width;
    CGFloat imageHeight = 480 / 853.0 * imageWidth;
    CGFloat imageY = (kScreenSize.height - 60 - 40 - imageHeight) / 2;
    for (int idx = 0; idx < self.photosArray.count; idx++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx*imageWidth, imageY, imageWidth, imageHeight)];
        [self.bigPicScrollView addSubview:imageView];
        
        // 取出模型数据
        AppDetailPhotoModel * model = self.photosArray[idx];
        // 设置图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.originalUrl] placeholderImage:[UIImage imageNamed:@"egopv_photo_placeholder"]];
    }
    
    self.bigPicScrollView.contentSize = CGSizeMake(self.photosArray.count * imageWidth, 0);
    // 按页显示
    self.bigPicScrollView.pagingEnabled = YES;
    // 关闭弹簧效果
    self.bigPicScrollView.bounces = NO;
    
    // 设置偏移量
    self.bigPicScrollView.contentOffset = CGPointMake(self.currentPageIndex*imageWidth, imageY);
    // 设置委托
    self.bigPicScrollView.delegate = self;
    
    // 添加Tap手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenTap:)];
    [self.bigPicScrollView addGestureRecognizer:tapGesture];
}

// 显示或隐藏手势回调
- (void)showOrHiddenTap:(UITapGestureRecognizer *) sender
{
    // 判断当前视图是否隐藏
    if ([self.currentPageLabel isHidden]) {
        // 显示视图
        for (UIView * view in self.showOrHiddenViewArray) {
            view.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha = 1;
            } completion:nil];
        }
        // 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    else {
        // 隐藏视图
        for (UIView * view in self.showOrHiddenViewArray) {
            // 渐渐隐藏
            [UIView animateWithDuration:0.3 animations:^{
                // 动画效果
                view.alpha = 0;
            } completion:^(BOOL finished) {
                view.hidden = YES;
            }];
        }
        // 隐藏状态栏
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
}


#pragma mark - UIScrollViewDelegate
// 减速完成时的回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 计算当前滚动的页数
    self.currentPageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld of %ld", self.currentPageIndex+1, self.photosArray.count];
}

@end
