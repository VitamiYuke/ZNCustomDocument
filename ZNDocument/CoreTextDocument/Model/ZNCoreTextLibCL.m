//
//  ZNCoreTextLibCL.m
//  ZNDocument
//
//  Created by 张楠 on 16/10/14.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNCoreTextLibCL.h"

@implementation ZNCoreTextLibCL

+ (NSMutableAttributedString *)getRemoveHtmlContentWithHtml:(NSString *)htmlstring 
{
    NSError *error = nil;
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithData:[htmlstring dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:&error];
    //    [att addAttribute:NSFontAttributeName value:myFont(font) range:NSMakeRange(0, att.length)];
    MyLog(@"%@",[error localizedDescription]);
    return att;
}



@end
