//
//  TKSplitScreenView.m
//  EduClassPad
//
//  Created by lyy on 2017/11/21.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKSplitScreenView.h"
#import "TKVideoOneView.h"
#import "TKVideoSecondView.h"
#import "TKVideoThreeView.h"
#import "TKVideoFourView.h"
#import "TKVideoFiveView.h"
#import "TKVideoSixView.h"
#import "TKVideoSevenView.h"

@interface TKSplitScreenView()
@property (nonatomic, strong) NSMutableArray *videoSmallViewBackArray;
@property (nonatomic, strong) UIView *videoOneView;
@property (nonatomic, strong) UIView *videoSecondView;
@property (nonatomic, strong) UIView *videoThreeView;
@property (nonatomic, strong) UIView *videoFourView;
@property (nonatomic, strong) UIView *videoFiveView;
@property (nonatomic, strong) UIView *videoSixView;
@property (nonatomic, strong) UIView *videoSevenView;
@end

@implementation TKSplitScreenView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initVideoView];
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)layoutSubviews{
    [self refreshUI];
}
- (void)initVideoView{
    _videoOneView = [[UIView alloc]init];
    _videoSecondView = [[UIView alloc]init];
    _videoThreeView = [[UIView alloc]init];
    _videoFourView = [[UIView alloc]init];
    _videoFiveView = [[UIView alloc]init];
    _videoSixView = [[UIView alloc]init];
    _videoSevenView = [[UIView alloc]init];
}

- (void)addVideoSmallView:(TKVideoSmallView *)view{
    
    
    for (TKVideoSmallView *videoView in self.videoSmallViewArray) {
        if (view.iVideoViewTag == videoView.iVideoViewTag ) {
            return;
        }
    }
   
    [self.videoSmallViewArray addObject:view];
    [self refreshUI];
    
}
- (void)refreshUI{
    
    CGFloat splitViewWidth = self.frame.size.width;
    CGFloat splitViewHeight = self.frame.size.height;
    
    
    NSInteger count = self.videoSmallViewArray.count;
    
    switch (count) {
        case 0:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
        }
            break;
        case 1:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoOneView *videoOneView = [[TKVideoOneView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoOneView];
            videoOneView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 2:
        {
            
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoSecondView *videoSecondView = [[TKVideoSecondView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoSecondView];
            videoSecondView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 3:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoThreeView *videoThreeView = [[TKVideoThreeView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoThreeView];
            videoThreeView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 4:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoFourView *videoFourView = [[TKVideoFourView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoFourView];
            videoFourView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 5:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoFiveView *videoFiveView = [[TKVideoFiveView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoFiveView];
            videoFiveView.videoSmallViewArray = self.videoSmallViewArray;
        }
            break;
        case 6:
        {
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoSixView *videoSixView = [[TKVideoSixView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoSixView];
            videoSixView.videoSmallViewArray = self.videoSmallViewArray;
            
        }
            break;
        case 7:
        {
            
            for(UIView *subv in [self subviews])
            {
                [subv removeFromSuperview];
            }
            TKVideoSevenView *videoSevenView = [[TKVideoSevenView alloc]initWithFrame:CGRectMake(0, 0, splitViewWidth, splitViewHeight)];
            [self addSubview:videoSevenView];
            videoSevenView.videoSmallViewArray = self.videoSmallViewArray;
           
        }
            break;
        default:
            break;
    }
}

- (void)deleteVideoSmallView:(TKVideoSmallView *)view{
    
    NSArray *array = [NSArray arrayWithArray:self.videoSmallViewArray];
    
    for (TKVideoSmallView *videoView in array) {
        if (videoView.iVideoViewTag == view.iVideoViewTag) {
            [self.videoSmallViewArray removeObject:videoView];
        }
    }
    [self refreshUI];
}

- (void)deleteAllVideoSmallView{
    
    [self.videoSmallViewArray removeAllObjects];
    
}

- (NSMutableArray *)videoSmallViewArray{
    if (!_videoSmallViewArray) {
        self.videoSmallViewArray = [NSMutableArray array];
    }
    return _videoSmallViewArray;
}
- (NSMutableArray *)videoSmallViewBackArray{
    if (!_videoSmallViewBackArray) {
        self.videoSmallViewBackArray = [NSMutableArray array];
    }
    return _videoSmallViewBackArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
