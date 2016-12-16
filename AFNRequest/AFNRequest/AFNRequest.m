//
//  AFNRequest.m
//  AFNRequest
//
//  Created by 谭杰 on 2016/12/12.
//  Copyright © 2016年 谭杰. All rights reserved.
//

#import "AFNRequest.h"

static AFNRequest *manager = nil;
//创建AFN管理者
static AFHTTPSessionManager *afnManager = nil;

@implementation AFNRequest

/**
 *  创建单例
 */
+ (AFNRequest *)manager
{
    //dispatch_once可以保证代码被执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[AFNRequest alloc] init];
        
        afnManager = [AFHTTPSessionManager manager];
        //设置请求参数为JSON类型
        afnManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置返回数据为JSON类型
        afnManager.responseSerializer = [AFJSONResponseSerializer serializer];
        //设置请求兼容HTTPS
        afnManager.securityPolicy.allowInvalidCertificates = YES;
        //设置请求等待时间
        afnManager.requestSerializer.timeoutInterval = 10.f;
        //如果接受数据类型不一致，请替换一致text/html或别的
        //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    });
    
    return manager;
}



- (void)Get:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure {
    
    URLString = [self getURLFrontURL:BaseURL BackURL:URLString];
    
    //GET请求
    [afnManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (success != nil) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        if (failure != nil) {
            //判断请求失败原因
            {
                
            }
            failure(error);
            NSLog(@"Error:%@",error);
        }
        
    }];
}

- (void)Post:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure {
    
    URLString = [self getURLFrontURL:BaseURL BackURL:URLString];
    
    //POST请求
    [afnManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if (success != nil) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        if (failure != nil) {
            //判断失败原因
            {
                
            }
            failure(error);
            NSLog(@"Error:%@",error);
        }
        
    }];
    
}


#pragma mark 拼接网址
- (NSString *)getURLFrontURL:(NSString *)frontURL BackURL:(NSString *)backURL {
    
    if (backURL == nil ||[backURL isEqualToString:@""]) {
        if (frontURL == nil || [frontURL isEqualToString:@""]) {
            return @"";
        }
        return frontURL;
    }
    
    if (frontURL == nil) {
        frontURL = @"";
    }
    
    if (backURL.length > 4) {
        if ([backURL hasPrefix:@"http"]) {
            return backURL;
        }else {
            return [frontURL stringByAppendingString:backURL];
        }
    }
    
    return nil;
}

@end
