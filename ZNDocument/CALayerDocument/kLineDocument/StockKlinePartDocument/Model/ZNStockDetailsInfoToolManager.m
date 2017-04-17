//
//  ZNStockDetailsInfoToolManager.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/10.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockDetailsInfoToolManager.h"
#import "ZNStockDetailsInfoModel.h"

@implementation ZNStockDetailsInfoToolManager



+ (ZNStockDetailsInfoModel *)configureStockDetailsInfoWithDataString:(NSString *)dataString originalData:(ZNStockDetailsInfoModel *)originalModel{

    NSArray *componentArray = [dataString componentsSeparatedByString:@","];
    if (componentArray.count) {
        ZNStockDetailsInfoModel *infoModel = originalModel;
        if (!infoModel) {
            infoModel = [[ZNStockDetailsInfoModel alloc] init];
        }
        infoModel.currentPrice = componentArray[0];
        infoModel.close = componentArray[1];
        infoModel.forehead = componentArray[2];
        infoModel.applies = componentArray[3];
        infoModel.opening = componentArray[4];
        infoModel.maxPrice = componentArray[5];
        infoModel.minPrice = componentArray[6];
        
        infoModel.volume = componentArray[9];
        infoModel.turnover = componentArray[10];
        
        infoModel.sellVolume = componentArray[31];
        infoModel.buyVolume = componentArray[32];
        infoModel.nowTheHand = componentArray[33];
        
        infoModel.dataStringArray = componentArray;
        

        return infoModel;
    }
    return originalModel;
}


+ (NSString *)configureAppliesAndForeheadWithOriginValue:(NSString *)forehead applies:(NSString *)applies{
    
    CGFloat forValue = forehead.floatValue;
    CGFloat appliesValue= applies.floatValue;
    
    NSString *tempForString = forValue > 0 ? [NSString stringWithFormat:@"+%@",[self configureFloatStringWithOriginValue:forValue]]:[self configureFloatStringWithOriginValue:forValue];
    NSString *tempAppString = appliesValue > 0 ? [NSString stringWithFormat:@"+%@",[self configureFloatStringWithOriginValue:appliesValue]]:[self configureFloatStringWithOriginValue:appliesValue];;

    
    return [[NSString stringWithFormat:@"%@  %@",tempForString,tempAppString] stringByAppendingString:@"%"];
}


+ (NSMutableAttributedString *)configureTurnoverShowWithTurnoverValue:(NSString *)turnover{
    CGFloat turnoverFloatValue = [turnover floatValue];
    NSString *tempValue = turnover;
    NSString *tempUnitString = nil;
    if (turnoverFloatValue>10000&& turnoverFloatValue<99999999) {
        tempValue  = [NSString stringWithFormat:@"%.2f",turnoverFloatValue/10000];
        tempUnitString = @"万";
    }
    if (turnoverFloatValue > 100000000) {
        tempValue = [NSString stringWithFormat:@"%.2f",turnoverFloatValue/100000000];
        tempUnitString = @"亿";
    }
    
    NSMutableAttributedString *valueAtt = [[NSMutableAttributedString alloc] initWithString:tempValue];
    if (tempUnitString.length && tempUnitString) {
        [valueAtt appendAttributedString:[[NSAttributedString alloc] initWithString:tempUnitString attributes:@{NSFontAttributeName:ZNCustomDinNormalFont(11)}]];
    }
    return valueAtt;
}





@end
