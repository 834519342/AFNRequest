//
//  AFNRequest.m
//  AFNRequest
//
//  Created by 谭杰 on 2016/12/12.
//  Copyright © 2016年 谭杰. All rights reserved.
//

#import "AFNRequest.h"

static AFNRequest *manager = nil;

//创建AFN请求管理者
static AFHTTPSessionManager *afnManager = nil;

//创建AFN网络监控管理者
static AFNetworkReachabilityManager *reachabilityManager = nil;

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
    [afnManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //请求进度
        NSLog(@"downloadProgress:%f",downloadProgress.fractionCompleted );
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [afnManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //请求进度
        NSLog(@"uploadProgress:%f",uploadProgress.fractionCompleted );
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

//查看当前网络状态
+ (void)getNetWorkingStatus:(void(^)(AFNetworkReachabilityStatus status))completion
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [reachabilityManager startMonitoring];
        
        __block AFNetworkReachabilityStatus copyStatus;
        
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"未连接");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"手机移动网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WIFI网络");
                    break;
                default:
                    break;
            }
            copyStatus = status;
        }];
        //GCD异步延时
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"GCD延时执行");
            if (completion) {
                completion(copyStatus);
            }
        });
    });
}


@end
