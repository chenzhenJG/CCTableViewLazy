//
//  CCTableVIewCell.m
//  CCTableViewLazy
//
//  Created by chenzhen on 16/5/11.
//  Copyright © 2016年 站在巨人肩膀. All rights reserved.
//

#import "CCTableViewCell.h"
#import "ImageModel.h"
@implementation CCTableViewCell

+ (instancetype)cellWithUITableView:(UITableView *)tableView
{
    NSString *indentifier = NSStringFromClass(self);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell)
    {
        cell = [[[super class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    return (CCTableViewCell *)cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setupUI
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self addSubview:self.imageViewicon];
}


- (UIImageView *)imageViewicon
{
    if (!_imageViewicon) {
       _imageViewicon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,200)];
        _imageViewicon.backgroundColor = [self randomColor];
    }
    return _imageViewicon;
}

- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.8];
}
@end
