//
//  ZNLiveCell.m
//  ZNDocument
//
//  Created by 张楠 on 16/11/7.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNLiveCell.h"
#import "ZNLiveItem.h"
#import "ZNCreatorItem.h"
#import <Masonry.h>
@interface ZNLiveCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *chaoyangLabel;



@end

@implementation ZNLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    _liveLabel.layer.cornerRadius = 5;
    _liveLabel.layer.masksToBounds = YES;
    
    
    self.bigPicView.tag = 101;
    
    // 代码添加playerBtn到imageView上
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.bigPicView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bigPicView);
    }];
    
    
}

- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLive:(ZNLiveItem *)live
{
    _live = live;
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",live.creator.portrait]];
    
    [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    if (live.city.length == 0) {
        _addressLabel.text = @"难道在火星?";
    }else{
        _addressLabel.text = live.city;
    }
    
    self.nameLabel.text = live.creator.nick;
    
    [self.bigPicView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    // 设置当前观众数量
    NSString *fullChaoyang = [NSString stringWithFormat:@"%zd人在看", live.online_users];
    NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%zd", live.online_users]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:MyColor(216, 41, 116) range:range];
    self.chaoyangLabel.attributedText = attr;
    
    
}




@end
