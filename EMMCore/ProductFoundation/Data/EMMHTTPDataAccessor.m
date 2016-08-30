//
//  EMMHTTPDataAccessor.m
//  EMMKitDemo
//
//  Created by Chenly on 16/7/11.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "EMMHTTPDataAccessor.h"
#import "AFNetworking.h"
#import "EMMApplicationContext.h"

@implementation EMMHTTPDataAccessor

- (instancetype)initWithModule:(NSString *)module request:(NSString *)request args:(NSDictionary *)args {

    if (self = [super initWithModule:module request:request args:args]) {
        _URLString = args[@"url"];
    }
    return self;
}

- (void)sendRequestWithParams:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure {

    NSString *URLString = params[@"url"] ?: self.URLString;
    URLString = [[EMMApplicationContext defaultContext] parserText:URLString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    
    NSString *httpMehod = params[@"httpMehod"];
    if ([httpMehod isEqualToString:@"POST"]) {
        
        [sessionManager POST:URLString parameters:params[@"parameters"] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
        }];
    }
    else {
        [sessionManager GET:URLString parameters:params[@"parameters"] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
        }];
    }
}

// 上传图片
- (void)sendImageWithParams:(NSDictionary *)params success:(void (^)(id result))success failure:(void (^)(NSError *error))failure {
    NSString *URLString = params[@"url"] ?: self.URLString;
    URLString = [[EMMApplicationContext defaultContext] parserText:URLString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    UIImage *image = params[@"image"];
    NSString *imageName = params[@"imageName"];
    NSString *name = params[@"name"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [sessionManager POST:URLString parameters:params[@"parameters"] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:name fileName:imageName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
