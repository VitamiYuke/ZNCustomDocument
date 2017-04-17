//
//  ZNTableViewCell.m
//  ZNDocument
//
//  Created by 张楠 on 16/10/10.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNTableViewCell.h"


@interface ZNTableViewCell()

@property(nonatomic, strong)UILabel *znTitle;

@end


@implementation ZNTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)znTitle
{
    if (!_znTitle) {
        _znTitle = [[UILabel alloc] init];
        _znTitle.font = MyFont(17);
        _znTitle.textColor = MyColor(240, 70, 80);
    }
    return _znTitle;
}


+ (instancetype )getZNTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"ZNTableViewCellIndentifier";
    ZNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[ZNTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    [self addSubview:self.znTitle];
    [self.znTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [self.znTitle autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

- (void)setTestTitle:(NSString *)testTitle
{
    _testTitle = testTitle;
    self.znTitle.text = testTitle;
}


@end
