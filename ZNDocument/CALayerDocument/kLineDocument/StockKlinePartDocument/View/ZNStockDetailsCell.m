//
//  ZNStockDetailsCell.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/13.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNStockDetailsCell.h"


@interface ZNStockDetailsCell (){
    CGFloat _margin;
    CGFloat _unitWidth;
    CGFloat _keyY;
    CGFloat _valueY;
    CGFloat _keyHeight;
    CGFloat _valueHeight;
}

@property(nonatomic, strong)CATextLayer *key0;
@property(nonatomic, strong)CATextLayer *key1;
@property(nonatomic, strong)CATextLayer *key2;
@property(nonatomic, strong)CATextLayer *key3;

@property(nonatomic, strong)CATextLayer *value0;
@property(nonatomic, strong)CATextLayer *value1;
@property(nonatomic, strong)CATextLayer *value2;
@property(nonatomic, strong)CATextLayer *value3;






@end

@implementation ZNStockDetailsCell


- (CATextLayer *)key0{
    if (!_key0) {
        _key0 = [ZNBasedToolManager YukeToolGetTextLayerWithTextColor:MyColor(50, 50, 50) font:ZNCustomDinNormalFont(11) textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(_margin, _keyY, _unitWidth, _keyHeight)];
    }
    return _key0;
}


- (CATextLayer *)key1{
    if (!_key1) {
        _key1 = [ZNBasedToolManager YukeToolGetTextLayerWithTextColor:MyColor(50, 50, 50) font:ZNCustomDinNormalFont(11) textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.key0.frame), _keyY, _unitWidth, _keyHeight)];
    }
    return _key1;
}


- (CATextLayer *)key2{
    if (!_key2) {
        _key2 = [ZNBasedToolManager YukeToolGetTextLayerWithTextColor:MyColor(50, 50, 50) font:ZNCustomDinNormalFont(11) textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.key1.frame), _keyY, _unitWidth, _keyHeight)];
    }
    return _key2;
}

- (CATextLayer *)key3{
    if (!_key3) {
        _key3 = [ZNBasedToolManager YukeToolGetTextLayerWithTextColor:MyColor(50, 50, 50) font:ZNCustomDinNormalFont(11) textAlignment:NSTextAlignmentLeft isWrapped:NO orAttString:nil layerFrame:CGRectMake(CGRectGetMaxX(self.key2.frame), _keyY, _unitWidth, _keyHeight)];
    }
    return _key3;
}



- (CATextLayer *)value0{
    if (!_value0) {
        _value0 = [self YukeGetNormalTextlayerWithFrame:CGRectMake(_margin, _valueY, _unitWidth, _valueHeight)];
        
    }
    return _value0;
}

- (CATextLayer *)value1{
    if (!_value1) {
        _value1 = [self YukeGetNormalTextlayerWithFrame:CGRectMake(CGRectGetMaxX(self.value0.frame), _valueY, _unitWidth, _valueHeight)];
    }
    return _value1;
}

- (CATextLayer *)value2{
    if (!_value2) {
        _value2 = [self YukeGetNormalTextlayerWithFrame:CGRectMake(CGRectGetMaxX(self.value1.frame), _valueY, _unitWidth, _valueHeight)];
    }
    return _value2;
}

- (CATextLayer *)value3{
    if (!_value3) {
        _value3 = [self YukeGetNormalTextlayerWithFrame:CGRectMake(CGRectGetMaxX(self.value2.frame), _valueY, _unitWidth, _valueHeight)];
    }
    return _value3;
}

- (CATextLayer *)YukeGetNormalTextlayerWithFrame:(CGRect )frame{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.frame = frame;
    return textLayer;
}



- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}



- (void)configureUI{
    _margin = 15;
    _keyY = 7;
    _unitWidth = (SCREENT_WIDTH - _margin*2)/4;
    _keyHeight = 15;
    _valueHeight = 20;
    _valueY = _keyY + _keyHeight + 5;
    [self.layer addSublayer:self.key0];
    [self.layer addSublayer:self.key1];
    [self.layer addSublayer:self.key2];
    [self.layer addSublayer:self.key3];
    [self.layer addSublayer:self.value0];
    [self.layer addSublayer:self.value1];
    [self.layer addSublayer:self.value2];
    [self.layer addSublayer:self.value3];
 
}

- (void)setKeyValueArray:(NSArray<NSDictionary<NSString *,NSAttributedString *> *> *)keyValueArray{
    
    _keyValueArray = keyValueArray;
    

    for (int i = 0; i < keyValueArray.count; i++) {
        NSDictionary *dic = keyValueArray[i];
        
        NSString *key = [[dic allKeys] firstObject];
        NSAttributedString *value = [[dic allValues] firstObject];
        switch (i) {
            case 0:
                self.key0.string = key;
                self.value0.string = value;
                break;
            case 1:
                self.key1.string = key;
                self.value1.string = value;
                break;
            case 2:
                self.key2.string = key;
                self.value2.string = value;
                break;
            case 3:
                self.key3.string = key;
                self.value3.string = value;
                break;
            default:
                break;
        }
        
        
        
    }
    
}






@end
