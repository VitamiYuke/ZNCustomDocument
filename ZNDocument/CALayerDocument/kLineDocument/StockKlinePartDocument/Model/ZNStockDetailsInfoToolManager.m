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
        
        //振幅
        if (infoModel.close.floatValue == 0 || !infoModel.close) {
            infoModel.rate = @"0.00%";
        }else{
            CGFloat rateFloat = (infoModel.maxPrice.floatValue - infoModel.minPrice.floatValue)/infoModel.close.floatValue * 100;
            NSString *rate = [self configureFloatStringWithOriginValue:rateFloat];
            infoModel.rate = [rate stringByAppendingString:@"%"];
        }
        
        if (componentArray.count > 30) {
            infoModel.appointThan = [self calculationStringPlusString:componentArray[16] buy2:componentArray[17] buy3:componentArray[18] buy4:componentArray[19] buy5:componentArray[20] sell1:componentArray[26] sell2:componentArray[27] sell3:componentArray[28] sell4:componentArray[29] sell5:componentArray[30] string:@"委比"];
            infoModel.committeePoor = [self calculationStringPlusString:componentArray[16] buy2:componentArray[17] buy3:componentArray[18] buy4:componentArray[19] buy5:componentArray[20] sell1:componentArray[26] sell2:componentArray[27] sell3:componentArray[28] sell4:componentArray[29] sell5:componentArray[30] string:@"委差"];
        }else{
            infoModel.appointThan = @"0.00";
            infoModel.committeePoor = @"0.00";
        }
        

        return infoModel;
    }
    return originalModel;
}


//委比委差
+ (NSString*) calculationStringPlusString:(NSString*)buy1 buy2:(NSString*)buy2 buy3:(NSString*)buy3 buy4:(NSString*)buy4 buy5:(NSString*)buy5 sell1:(NSString*)sell1 sell2:(NSString*)sell2 sell3:(NSString*)sell3 sell4:(NSString*)sell4 sell5:(NSString*)sell5 string:(NSString*)string
{
    CGFloat buy = [buy1 floatValue]+[buy2 floatValue]+[buy3 floatValue]+[buy4 floatValue]+[buy5 floatValue];
    CGFloat sell = [sell1 floatValue]+[sell2 floatValue]+[sell3 floatValue]+[sell4 floatValue]+[sell5 floatValue];
    if ([string isEqualToString:@"委比"]) {
        return [NSString stringWithFormat:@"%.2f",((buy-sell)/(buy+sell))*100];
    }
    
    if ([string isEqualToString:@"委差"]) {
        return [NSString stringWithFormat:@"%.0f",(fabs (buy-sell))];
    }
    return @"";
    
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
