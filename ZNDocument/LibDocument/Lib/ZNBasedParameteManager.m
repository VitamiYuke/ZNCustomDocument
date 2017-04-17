//
//  ZNBasedParameteManager.m
//  ZNDocument
//
//  Created by 张楠 on 17/3/2.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNBasedParameteManager.h"


typedef NS_ENUM(NSUInteger, ParameterType) {
    ParameterTypePublic = 1,//共工
    ParameterTypeEncryption =2,//加密的参数
};



@interface ZNBasedParameteManager ()

@property(nonatomic, strong)NSMutableDictionary *mutableParameter;

@end

@implementation ZNBasedParameteManager

#pragma mark - 对外方法

+ (NSMutableDictionary *)getPublicBasedParameters{
    ZNBasedParameteManager *manager = [[ZNBasedParameteManager alloc] initWithParameterType:ParameterTypePublic];
    return manager.mutableParameter;
}


+ (NSMutableDictionary *)getEncryptionBasedParameters{
    ZNBasedParameteManager *manager = [[ZNBasedParameteManager alloc] initWithParameterType:ParameterTypeEncryption];
    return manager.mutableParameter;
}


#pragma mark - 内部

- (NSMutableDictionary *)mutableParameter{
    if (!_mutableParameter) {
        _mutableParameter = @{}.mutableCopy;
    }
    return _mutableParameter;
}

- (instancetype)initWithParameterType:(ParameterType )parameterType{
    if ([super init]) {
        [self configureParameterWithtype:parameterType];
    }
    return self;
}


- (void)configureParameterWithtype:(ParameterType )type{
    
    switch (type) {
        case ParameterTypePublic:
            
            break;
        case ParameterTypeEncryption:
            [self configureEncryption];
            break;
            
        default:
            break;
    }
}


//配置加密的参数
- (void)configureEncryption{
    
    
    
    
    
    
    
    
}







@end
