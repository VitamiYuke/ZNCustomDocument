//
//  ZNNetworkManager.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/1.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNNetworkManager.h"
#import <AFNetworking.h>




@implementation ZNNetworkManager


static AFHTTPSessionManager *manager;

+(NSURLSessionDataTask *)GET:(NSString *)urlString parameter:(id)parameter downProgress:(void (^)(NSProgress *))downProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    if (urlString.length == 0 || !urlString) {
        MyLog(@"没有请求的接口");
        return nil;
    }
    
    
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    NSURLSessionDataTask *dateTask =  [manager GET:urlString parameters:parameter progress:downProgress success:success failure:failure];
    MyLog(@"当前请求的地址:%@, 原始请求的地址:%@",dateTask.currentRequest.URL.absoluteString,dateTask.originalRequest.URL.absoluteString);
    return dateTask;
    
}


+ (NSURLSessionDataTask *)POST:(NSString *)urlString parameter:(id)parameter uploadProgress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    if (urlString.length == 0 || !urlString) {
        MyLog(@"没有请求的接口");
        return nil;
    }
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    NSURLSessionDataTask *dateTask =   [manager POST:urlString parameters:parameter progress:uploadProgress success:success failure:failure];
    MyLog(@"当前请求的地址:%@, 原始请求的地址:%@",dateTask.currentRequest.URL.absoluteString,dateTask.originalRequest.URL.absoluteString);
    return dateTask;

}

















@end
