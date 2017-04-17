//
//  ZNSlideMenu.m
//  ZNDocument
//
//  Created by ZhangNanBoy on 16/8/22.
//  Copyright © 2016年 zhangnanboy. All rights reserved.
//

#import "ZNSlideMenu.h"
#import "ZNMenuCell.h"
#define SPACE 30
#define EXTRA_AREA 50 // 用于动画的过渡
#define BUTTON_HEIGHT 40
#define MARGIN 20


@interface ZNSlideMenu ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, assign)CGRect originRect;

@property(nonatomic, strong)CADisplayLink *displayLink;//定时器
@property NSInteger animationCount;//动画的数量


@end


@implementation ZNSlideMenu{
    UIView *helperCenterView;
    UIView *helperSideView;
    UIVisualEffectView *blurView;
    UIWindow *keyWindow;
    BOOL triggered;
    CGFloat diff;
    UIColor *_menuColor;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width - EXTRA_AREA, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width - EXTRA_AREA, self.frame.size.height) controlPoint:CGPointMake(keyWindow.frame.size.width/2+diff, keyWindow.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_menuColor set];
    CGContextFillPath(context);
    
    
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableFooterView:[[UIView alloc] init]];
        [_tableView setShowsVerticalScrollIndicator:NO];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (instancetype)initWithTitile:(NSArray *)titles
{
    return [self initWithTitile:titles withMenuColor:MyColor(0, 197, 255) withBackBlurStyle:UIBlurEffectStyleDark];
}


- (instancetype)initWithTitile:(NSArray *)titles withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style
{
    self = [super init];
    if (self) {
        keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];//模糊效果
        blurView.frame = keyWindow.frame;
        blurView.alpha = 0.0f;
        
        helperSideView = [[ UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
//        helperSideView.backgroundColor = [UIColor redColor];
        [keyWindow addSubview:helperSideView];
        
        
        helperCenterView = [[UIView alloc] initWithFrame:CGRectMake(-40, CGRectGetHeight(keyWindow.frame)/2 - 20, 40, 40)];
//        helperCenterView.backgroundColor = [UIColor yellowColor];
        [keyWindow addSubview:helperCenterView];
        
        self.frame = CGRectMake(-keyWindow.frame.size.width / 2 - EXTRA_AREA, 0, keyWindow.frame.size.width / 2 + EXTRA_AREA, keyWindow.frame.size.height);
        self.originRect = self.frame;
        self.backgroundColor = [UIColor clearColor];
        [keyWindow insertSubview:self aboveSubview:helperSideView];
        
        _menuColor = menuColor;// 颜色
        [self createButtonWithTitles:titles];
        
    }
    return self;
}


- (void)trigger{
    if (!triggered) {
        [keyWindow insertSubview:blurView belowSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
            
        }];
        
        [self beforeAnimation];
        
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            helperSideView.center = CGPointMake(keyWindow.center.x, helperSideView.frame.size.height/2);
            
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            blurView.alpha = 0.8f;
            
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            helperCenterView.center = keyWindow.center;
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUnTrigger)];
                [blurView addGestureRecognizer:tapGes];
                [self finishAnimation];
            }
        }];
        
        triggered = YES;
    } else {
        [self tapToUnTrigger];
    }
    
}

-(void)animateButtons{
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        UIView *menuButton = self.subviews[i];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        
        [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            menuButton.transform =  CGAffineTransformIdentity;
            
        } completion:NULL];
        
    }
    
    
}



- (void)tapToUnTrigger
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = self.originRect;
    }];
    if (self.delegate) {
        [self.delegate finishHidden];
    }
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        helperSideView.center = CGPointMake(-helperSideView.frame.size.width/2, helperSideView.frame.size.height/2);
        
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];

    
    [UIView animateWithDuration:0.3 animations:^{
        blurView.alpha = 0.0f;
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        helperCenterView.center = CGPointMake(-helperSideView.frame.size.width/2, CGRectGetHeight(keyWindow.frame)/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    triggered = NO;
}




//创建button
- (void)createButtonWithTitles:(NSArray *)titles
{

#warning mark -这的TableView显示和刷新有坑(并且UITableViewCell刚开始的宽度和uitableViw的frame不一致)
    [self.dataArray addObjectsFromArray:titles];
    CGFloat maxHeight = self.dataArray.count * kZNMenuCellDefaultHeight;
    self.tableView.frame = CGRectMake(MARGIN, MARGIN, keyWindow.frame.size.width/2 - MARGIN*2, maxHeight);
    if (maxHeight >= (keyWindow.frame.size.height - MARGIN * 2)) {//很多个菜单选项
        self.tableView.height = keyWindow.frame.size.height - MARGIN;
    } else {
        self.tableView.y = keyWindow.frame.size.height/2 - maxHeight/2;
        [self.tableView setScrollEnabled:NO];
    }
    MyLog(@"TableView宽度:%.0f",self.tableView.width);
    self.tableView.backgroundColor = _menuColor;
    [self addSubview:self.tableView];
    
}


#pragma mark -动画之前进行的操作
- (void)beforeAnimation{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

#pragma mark - 动画完成之后
- (void)finishAnimation{
    self.animationCount--;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma mark - 动画操作
- (void)displayLinkAction:(CADisplayLink *)dis{
    CALayer *sideHelperPresentationLayer = (CALayer *)[helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer = (CALayer *)[helperCenterView.layer presentationLayer];
    CGRect centerRect = [[centerHelperPresentationLayer valueForKey:@"frame"] CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKey:@"frame"] CGRectValue];
    diff = sideRect.origin.x - centerRect.origin.x;
//    MyLog(@"偏移量:%.0f",diff);
    [self setNeedsDisplay];
}

#pragma mark - UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZNMenuCell *cell = [ZNMenuCell getZNMenuCellWithTableView:tableView];
    cell.buttonTitle = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kZNMenuCellDefaultHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tapToUnTrigger];
    NSString *title = self.dataArray[indexPath.row];
    self.menuClickBlock(indexPath.row,title);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLog(@"MenuCell显示");
}




@end
