//
//  ZNNetworkRequestCL.h
//  ZNDocument
//
//  Created by 张楠 on 16/9/29.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNNetworkRequestCL : NSObject



+ (NSURLSessionDataTask *)postWithUrl:(NSString *)urlString parameter:(id)parameters succFinish:(void(^)(id responseObject))succRequest faile:(void(^)(NSError *error))failRequset;


+ (NSURLSessionDataTask *)getWithUrl:(NSString *)urlString parameter:(id)parameters succFinish:(void(^)(id responseObject))succRequest faile:(void(^)(NSError *error))failRequset;



- (void)getWithUrlWithDelegate:(NSString *)urlString parameter:(id)parameters succFinish:(void(^)(id responseObject))succRequest faile:(void(^)(NSError *error))failRequset;





@end
