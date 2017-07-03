//
//  XCStarView.m
//  EvaluationStar
//
//  Created by 辰 on 15/11/26.
//  Copyright © 2015年 Chn. All rights reserved.
//

#import "XCStarView.h"


//#define ImageMargin self.bounds.size.width/(self.totalStarCount * 2 - 1)                        // 两个星星之间的间距
//#define ImageWidth  (self.bounds.size.width - (self.starMargin) * (self.totalStarCount - 1))/(self.totalStarCount)



@interface XCStarView ()
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic, assign) NSInteger totalStarCount;
@property (nonatomic, assign) CGFloat starMargin;
@property (nonatomic, assign) CGFloat starWidth;
@end


@implementation XCStarView


- (instancetype)initWithEmptyImage:(NSString *)Empty StarImage:(NSString *)Star totalStarCount:(NSInteger)totalStarCount starMargin:(CGFloat)starMargin starWidth:(CGFloat)starWidth selectBlock:(XCSelectBlock)selectBlock
{
    self = [super init];
    if (self) {
        self.totalStarCount = totalStarCount;
        self.starMargin = starMargin;
        self.starWidth = starWidth;
        self.starBackgroundView = [self buidlStarViewWithImageName:Empty totalStarCount:totalStarCount];
        self.starForegroundView = [self buidlStarViewWithImageName:Star totalStarCount:totalStarCount];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        self.starForegroundView.frame = CGRectMake(0, 0, 0, 0);
        self.userInteractionEnabled = YES;
        
        // 点击手势
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:tapGR];
        
        // 滑动手势
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:panGR];
        
        self.frame = CGRectMake(0, 0, self.starBackgroundView.width, self.starBackgroundView.height);
        
        self.selectBlock = selectBlock;
        
    }
    return self;
}


- (UIView *)buidlStarViewWithImageName:(NSString *)imageName totalStarCount:(NSInteger)totalStarCount
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.starWidth*self.totalStarCount + self.starMargin*(self.totalStarCount-1), self.starWidth)];
    view.clipsToBounds = YES;
    
    for (int j = 0; j < totalStarCount; j ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(j*(self.starWidth + self.starMargin), 0, self.starWidth, self.starWidth);
        imageView.userInteractionEnabled = YES;
        [view addSubview:imageView];
        
    }
    
    view.userInteractionEnabled = YES;
    return view;
}

-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint point =[tapGR locationInView:self];
    if (point.x<0) {
        point.x = 0;
    }
    
    // 不允许半星
    int num = (int) point.x/(self.starWidth + self.starMargin);
    self.starForegroundView.frame = CGRectMake(0, 0, (num+1)*(self.starWidth+self.starMargin), self.starWidth);
    
    // 允许半星
    //    self.starForegroundView.frame = CGRectMake(0, 0, point.x, ImageWidth);
    
    self.selectedStatCount = num+1;
    
}

- (void)setSelectedStatCount:(NSInteger)selectedStatCount
{
    if (selectedStatCount > self.totalStarCount) {
        selectedStatCount = self.totalStarCount;
    }
    self.starForegroundView.frame = CGRectMake(0, 0, (selectedStatCount)*(self.starWidth+self.starMargin), self.starWidth);
    _selectedStatCount = selectedStatCount;
    
//    NSLog(@"---点击了%ld个---", selectedStatCount);
    
    if (self.selectBlock) {
        self.selectBlock(selectedStatCount);
    }
    
}



// 不能更改星星
- (instancetype)initWithEmptyImage:(NSString *)Empty StarImage:(NSString *)Star totalStarCount:(NSInteger)totalStarCount selectedStatCount:(NSInteger)selectedStatCount starMargin:(CGFloat)starMargin starWidth:(CGFloat)starWidth
{
    self = [super init];
    if (self) {
        self.totalStarCount = totalStarCount;
        self.starMargin = starMargin;
        self.starWidth = starWidth;
        self.starBackgroundView = [self buidlStarViewWithImageName:Empty totalStarCount:totalStarCount];
        self.starForegroundView = [self buidlStarViewWithImageName:Star totalStarCount:totalStarCount];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        self.starForegroundView.frame = CGRectMake(0, 0, (selectedStatCount)*(self.starWidth+self.starMargin), self.starWidth);
        self.frame = CGRectMake(0, 0, self.starBackgroundView.width, self.starBackgroundView.height);
    }
    return self;
}


@end
