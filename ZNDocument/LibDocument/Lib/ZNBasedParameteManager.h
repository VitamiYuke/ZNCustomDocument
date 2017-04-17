//
//  ZNBasedParameteManager.h
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNBasedParameteManager : NSObject

+ (NSMutableDictionary *)getPublicBasedParameters;
+(NSMutableDictionary *)getEncryptionBasedParameters;


@end
