//
//  ImageModel.h
//  CCTableViewLazy
//
//  Created by chenzhen on 16/5/11.
//  Copyright © 2016年 站在巨人肩膀. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageModel : NSObject
@property (strong,nonatomic) UIImage *image;

@property (strong,nonatomic) NSString *imageUrl;

@property (assign,nonatomic) CGFloat width;

@property (assign,nonatomic) CGFloat height;

- (void) requestHTTP : (void(^)(NSMutableArray <ImageModel *> *imageArray)) imageArray;


@end
