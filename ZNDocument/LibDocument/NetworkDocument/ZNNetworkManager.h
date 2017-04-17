//
//  ZNNetworkManager.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/1.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNNetworkManager : NSObject


+ (NSURLSessionDataTask *)GET:(NSString *)urlString
                    parameter:(id)parameter
                 downProgress:(void(^)(NSProgress *downProgress))downProgress
                      success:(void (^)(NSURLSessionDataTask *task,id responseObject))success
                      failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;



+ (NSURLSessionDataTask *)POST:(NSString *)urlString
                    parameter:(id)parameter
               uploadProgress:(void(^)(NSProgress *uploadProgress))uploadProgress
                      success:(void (^)(NSURLSessionDataTask *task,id responseObject))success
                      failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;




@end
