//
//  ViewController.m
//  CCTableViewLazy
//
//  Created by chenzhen on 16/5/11.
//  Copyright © 2016年 站在巨人肩膀. All rights reserved.
//

#import "ImageModel.h"
#import "ViewController.h"
#import "CCTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray <ImageModel *> *imagesObject;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self request];
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imagesObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewCell *cell = [CCTableViewCell cellWithUITableView:tableView];
    [self setDataCell:cell indexPath:indexPath];
    return cell;
}

- (void)setImagesObject:(NSMutableArray<ImageModel *> *)imagesObject
{
    if (imagesObject) {
        _imagesObject = imagesObject;
        [_tableView reloadData];
    }
}


#pragma mark - scrollview delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //tableview停止滚动，开始加载图像
    if (!decelerate)
    {
        [self loadImageForCellRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //如果tableview停止滚动，开始加载图像
    [self loadImageForCellRows];
}


#pragma mark - setDataCell 
- (void)setDataCell : (CCTableViewCell *)cell
          indexPath : (NSIndexPath *)indexPath
{
    ImageModel *imageModel = _imagesObject[indexPath.row];
    if (imageModel.image == nil)
    {
        cell.imageViewicon.image = nil;
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [[SDWebImageDownloader sharedDownloader] setValue:@"Mozilla/5.0 (iPod; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1" forHTTPHeaderField:@"User-Agent"];
            [cell.imageViewicon sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 [imageModel setImage:image];
                 
             }];
        }
    }
    else
    {
        cell.imageViewicon.image = imageModel.image;
    }
}



#pragma mark - load UIImage到Cell上
- (void)loadImageForCellRows {
    NSArray *cells = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath * indexPath in cells)
    {
        CCTableViewCell *cell = (CCTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        ImageModel *imageModel = _imagesObject[indexPath.row];
        UIImage *_cacheImage = [self getImageThroughUrl:imageModel.imageUrl];
        //如果缓存中有就从缓存中拿去
        if (_cacheImage)
        {
            cell.imageViewicon.image = _cacheImage;
        }
        //进行下载
        else
        {
            //1.
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imageModel.imageUrl] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize)
            {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
            {
                cell.imageViewicon.image = image;
                imageModel.image = image;
            }];
//            [cell.imageViewicon sd_setImageWithURL:[NSURL URLWithString:imageModel.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                [imageModel setImage:image];
//            }];
        }
    }
}

#pragma mark -获取缓存中的UIImage
- (UIImage *)getImageThroughUrl : (NSString *)url
{
    UIImage *_cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:url];
    if (_cacheImage)
    {
        return _cacheImage;
    }
    return nil;
}

#pragma mark -initUI
- (void)initUI
{
    [self.view addSubview:self.tableView];
}


#pragma mark 请求
- (void)request
{
    ImageModel *imageModel = [ImageModel new];
    [imageModel requestHTTP:^(NSMutableArray<ImageModel *> *imageArray) {
        self.imagesObject = imageArray;
    }];
}
@end
