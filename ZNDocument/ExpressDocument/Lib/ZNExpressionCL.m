//
//  ZNExpressionCL.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNExpressionCL.h"
//图片正则
#define Emoticons_Regular @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"
#import "TYTextContainer.h"

@implementation ZNExpressionCL


//根据文件名称获取表情包得plist文件路径
+ (NSString *)ObtainFilePath:(NSString *)name{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ZNEmoticons" ofType:@"bundle"];
    //获取emoticon.plist文件
    NSString *emticonPath = [NSString stringWithFormat:@"%@/%@/info.plist",path,name];
    return emticonPath;
}

//根据文件夹名称获取表情路径
+ (NSString *)ObtainExpressionPatn:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ZNEmoticons" ofType:@"bundle"];
    NSString *emoticonsPath = [NSString stringWithFormat:@"%@/%@",path,name];
    return emoticonsPath;
}

/**
 *获取所有sina默认表情
 */
+ (NSArray *)ObtainAllSinaDefaultExpression
{
    NSString *filePath = [self ObtainFilePath:@"com.5igupiao.default"];
    NSDictionary *fileDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    //获取表情
    NSArray *expressionArray = fileDic[@"emoticons"];
    return expressionArray;
}
/**
 *获取所有浪小花表情
 */
+ (NSArray *)ObtainAllSinaLxhExpression{
    NSString *filePath = [self ObtainFilePath:@"com.5igupiao.lxh"];
    
    //获取文件内容
    NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    //获取表情
    NSArray *expressionArry = [fileDict objectForKey:@"emoticons"];
    
    return expressionArry;
}

/**
 *根据图片名获取sina默认表情图片
 */
+ (UIImage *)ObtainPictureDefault:(NSString *)name{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self ObtainExpressionPatn:@"com.5igupiao.default"],name];
    UIImage *defauleImg = [UIImage imageWithContentsOfFile:filePath];
    return defauleImg;
}
/**
 *根据图片名获取浪小花表情图片
 */
+ (UIImage *)ObtainPictureLxh:(NSString *)name
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self ObtainExpressionPatn:@"com.5igupiao.lxh"],name];
    UIImage *lxhImg = [UIImage imageWithContentsOfFile:filePath];
    return lxhImg;
}

/**
 *根据表情名称获取sina默认表情图片
 */
+ (UIImage *)ObtainPictureNameDefault:(NSString *)name{
    NSArray *sinaArry = [self ObtainAllSinaDefaultExpression];
    for (int i=0; i<sinaArry.count; i++) {
        NSDictionary *dict = sinaArry[i];
        if([dict[@"chs"] isEqual:name]){
            return [self ObtainPictureDefault:dict[@"png"]];
        }
    }
    return nil;
}

/**
 *根据表情名称获取浪小花表情图片
 */
+ (UIImage *)ObtainPictureNameLxh:(NSString *)name{
    NSArray *lxhArry = [self ObtainAllSinaLxhExpression];
    for (int i=0; i<lxhArry.count; i++) {
        NSDictionary *dict = lxhArry[i];
        if([dict[@"chs"] isEqual:name]){
            return [self ObtainPictureLxh:dict[@"png"]];
        }
    }
    return nil;
}

/**
 *根据表情名称获取表情图片
 */
+ (UIImage *)ObtainPictureName:(NSString *)name{
    UIImage *image = [self ObtainPictureNameDefault:name];
    if(!image){
        image = [self ObtainPictureNameLxh:name];
    }
    return image;
}


+ (UIImage *)ObtainDeleteImage
{
    UIImage *deleteImg = [UIImage imageNamed:@"EmoticonDelete"];
    return deleteImg;
}


// 处理正则匹配出来的表情图片
+ (NSMutableAttributedString *)operationEmoticonsWithContent:(NSString *)content{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];

    if (content.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSRegularExpression *emoticonsRegular = [NSRegularExpression regularExpressionWithPattern:Emoticons_Regular options:NSRegularExpressionCaseInsensitive error:&error];
    if (!emoticonsRegular) {
        MyLog(@"表情匹配错误%@",[error localizedDescription]);
        return attString;
    }
    
    NSArray *emoticonsArray = [emoticonsRegular matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    if (emoticonsArray.count == 0) {
        MyLog(@"没有表情符号");
        return attString;
    }
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:emoticonsArray.count];
    //根据匹配范围来用图片进行替换
    for (NSTextCheckingResult *match in emoticonsArray) {
        
        //图片的范围
        NSRange range = [match range];
        //获取原字符串对应的值
        NSString *subStr = [content substringWithRange:range];
        //新建立文字附件来存储图片 ios7才有的新对象
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //给附件添加图片
        textAttachment.image = [self ObtainPictureName:subStr];
        //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
        textAttachment.bounds=CGRectMake(0, -8,textAttachment.image.size.width, textAttachment.image.size.height);
        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        
        [imageDic setObject:imageStr forKey:@"image"];
        
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        [imageArray addObject:imageDic];
        
    }
    
    
    //4、从后往前替换，否则会引起位置问题
    for(int i = (int)imageArray.count-1; i >=0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        
        //进行替换
        
        [attString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    
    return attString;
}


+ (void)operationTYTextContainerEmoticonsWith:(TYTextContainer *)textContainer andContent:(NSString *)content
{
    if (content.length == 0) {
        return ;
    }
    
    NSError *error = nil;
    NSRegularExpression *emoticonsRegular = [NSRegularExpression regularExpressionWithPattern:Emoticons_Regular options:NSRegularExpressionCaseInsensitive error:&error];
    if (!emoticonsRegular) {
        MyLog(@"表情匹配错误%@",[error localizedDescription]);
        return ;
    }
    
    NSArray *emoticonsArray = [emoticonsRegular matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    if (emoticonsArray.count == 0) {
        MyLog(@"没有表情符号");
        return;
    }
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:emoticonsArray.count];
    //根据匹配范围来用图片进行替换
    for (NSTextCheckingResult *match in emoticonsArray) {
        
        //图片的范围
        NSRange range = [match range];
        //获取原字符串对应的值
        NSString *subStr = [content substringWithRange:range];
        //把图片和图片对应的位置存入字典中
        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [imageDic setObject:[self ObtainPictureName:subStr] forKey:@"image"];
        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
        //把字典存入数组中
        [imageArray addObject:imageDic];
        
    }
    
    
    //4、从后往前替换，否则会引起位置问题
    for(int i = (int)imageArray.count-1; i >=0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];

        //进行替换
//        [textContainer addImage:imageArray[i][[@"image"] range:range size:CGSizeMake(20, 20) alignment:TYDrawAlignmentCenter];
        UIImage *img = imageArray[i][@"image"];
        [textContainer addImage:img range:range size:CGSizeMake(20, 20) alignment:TYDrawAlignmentCenter];
        
    }
    
}






@end
