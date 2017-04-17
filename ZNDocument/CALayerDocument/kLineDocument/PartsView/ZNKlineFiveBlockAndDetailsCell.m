//
//  ZNKlineFiveBlockAndDetailsCell.m
//  ZNDocument
//
//  Created by 张楠 on 17/4/6.
//  Copyright © 2017年 zhangnanboy. All rights reserved.
//

#import "ZNKlineFiveBlockAndDetailsCell.h"

@interface ZNKlineFiveBlockAndDetailsCell ()

@property(nonatomic, strong)UILabel *leftLabel;
@property(nonatomic, strong)UILabel *middleLabel;
@property(nonatomic, strong)UILabel *rightLabel;
@property(nonatomic, strong)NSDateFormatter *dateFormatter;

@end


@implementation ZNKlineFiveBlockAndDetailsCell


-(NSDateFormatter*)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_dateFormatter setDateFormat:@"HH:mm"];
    }
    return _dateFormatter;
}

- (UILabel *)configureLabelWithTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment )alignment {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.font = ZNCustomDinMediumFont(10);
    return label;
}


- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [self configureLabelWithTextColor:MyColor(130, 130, 130) textAlignment:NSTextAlignmentLeft];
    }
    return _leftLabel;
}

- (UILabel *)middleLabel{
    if (!_middleLabel) {
        _middleLabel = [self configureLabelWithTextColor:MyColor(130, 130, 130) textAlignment:NSTextAlignmentCenter];
    }
    return _middleLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [self configureLabelWithTextColor:MyColor(130, 130, 130) textAlignment:NSTextAlignmentRight];
    }
    return _rightLabel;
}

+ (instancetype)getZNKlineFiveBlockAndDetailsCellWithTableView:(UITableView *)tableView{
    static NSString *indentifier = @"ZNKlineFiveBlockCellIndentifier";
    ZNKlineFiveBlockAndDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[ZNKlineFiveBlockAndDetailsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.leftLabel];
    [self addSubview:self.middleLabel];
    [self addSubview:self.rightLabel];
    [self.leftLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.leftLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.leftLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.rightLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.rightLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.rightLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.middleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.middleLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.middleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.leftLabel];
    [self.rightLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.middleLabel];
    [self.middleLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.leftLabel];
    [self.rightLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.middleLabel];
    [self.leftLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.rightLabel];
}

- (void)setFiveBlockModel:(ZNStockFiveBlockModel *)fiveBlockModel{
    
    if (!fiveBlockModel) {
        return;
    }
    
    _fiveBlockModel = fiveBlockModel;
    self.leftLabel.text = fiveBlockModel.title;
    self.middleLabel.text = fiveBlockModel.price;
    self.middleLabel.textColor = fiveBlockModel.color;
    self.rightLabel.text = [NSString stringWithFormat:@"%ld",[fiveBlockModel.volum integerValue]/100];
    self.rightLabel.textColor = MyColor(130, 130, 130);
    
}

- (void)setDetailsModel:(ZNStockDetailsModel *)detailsModel{
    
    if (!detailsModel) {
        return;
    }
    
    _detailsModel = detailsModel;
    
    if (detailsModel.time) {
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[detailsModel.time integerValue]];
        NSString *confromTimespStr = [self.dateFormatter stringFromDate:confromTimesp];
        self.leftLabel.text = confromTimespStr;
    }
    
    self.middleLabel.text = detailsModel.price;
    self.middleLabel.textColor = detailsModel.color;
    
    self.rightLabel.text = [NSString stringWithFormat:@"%ld",[detailsModel.volum integerValue]/100];
    if ([detailsModel.kind isEqualToString:@"B"]) {
        self.rightLabel.textColor = MyColor(233, 47, 68);
    }else if ([detailsModel.kind isEqualToString:@"S"])
    {
        self.rightLabel.textColor = MyColor(33, 179, 77);
    }else
    {
        self.rightLabel.textColor = [UIColor grayColor];
    }
 
}






@end
