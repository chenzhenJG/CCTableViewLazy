//
//  CCTableVIewCell.h
//  CCTableViewLazy
//
//  Created by chenzhen on 16/5/11.
//  Copyright © 2016年 站在巨人肩膀. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageModel;
@interface CCTableViewCell : UITableViewCell

@property (strong,nonatomic) UIImageView *imageViewicon;

+ (instancetype)cellWithUITableView : (UITableView *)tableView;


@end
