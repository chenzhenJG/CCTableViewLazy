//
//  ImageModel.m
//  CCTableViewLazy
//
//  Created by chenzhen on 16/5/11.
//  Copyright © 2016年 站在巨人肩膀. All rights reserved.
//

#import "ImageModel.h"
#import "AFNetworking.h"
@implementation ImageModel
- (void)requestHTTP:(void (^)(NSMutableArray <ImageModel *> *imageArray)) imageArray
{
    static NSString *apiURL = @"http://image.baidu.com/search/acjson?tn=resultjson_com&ipn=rj&ie=utf-8&oe=utf-8&word=cat&queryWord=dog";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    [serializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = serializer;
    
    [manager GET:apiURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
    {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSString *responseString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (responseDictionary) {
           NSMutableArray <ImageModel *>*imageList = [ImageModel parseJson:responseDictionary].mutableCopy;
           imageArray(imageList);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        
    }];
}

+ (NSMutableArray *)parseJson:(NSDictionary *)json
{
    NSArray *originalData = [json objectForKey:@"data"];
    NSMutableArray *imageList = [NSMutableArray array];
    for (NSDictionary *item in originalData) {
        if ([item isKindOfClass:[NSDictionary class]] && [item[@"middleURL"] length] > 0)
        {
            ImageModel *_imageModel = [ImageModel new];
            _imageModel.imageUrl = item[@"middleURL"];
            _imageModel.width = [item[@"width"] floatValue];
            _imageModel.height = [item[@"height"] floatValue];
            [imageList addObject:_imageModel];
        }
        
    }
    return imageList;
}
@end
