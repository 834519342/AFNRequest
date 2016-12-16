//
//  AFNRequest.h
//  AFNRequest
//
//  Created by 谭杰 on 2016/12/12.
//  Copyright © 2016年 谭杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#define BaseURL @"http://www.seeyoujia.com:8080/face/"

/*
 *  block回调传值
 *
 *  请求成功回调json数据
 */
typedef void (^Success)(id responseObject);

/*
 *请求失败回调错误信息
 *
 */
typedef void (^Failure)(NSError *error);


@interface AFNRequest : NSObject

//单例模式
+ (AFNRequest *)manager;

#pragma mark 网络请求
/**
 *  GET请求
 *  @param URLString    NSString 请求借口URL
 *  @param parameters   NSDictionary 请求借口参数
 *  @param success      void (^Success)(id responseObject)  请求成功回调
 *  @param failure      void (^Failure)(NSError *error) 请求错误信息回调
 */
- (void)Get:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure;

/**
 *  POST请求
 *  @param URLString    NSString 请求借口URL
 *  @param parameters   NSDictionary 请求借口参数
 *  @param success      void (^Success)(id responseObject)  请求成功回调
 *  @param failure      void (^Failure)(NSError *error) 请求错误信息回调
 */
- (void)Post:(NSString *)URLString parameters:(id)parameters success:(Success)success failure:(Failure)failure;


#pragma mark 拼接网址
/**
 *  @param frontURL     NSString 请求前缀
 *  @param backURL      NSString 请求路径
 */
- (NSString *)getURLFrontURL:(NSString *)frontURL BackURL:(NSString *)backURL;

@end
