//
//  TKSplitScreenBaseView.m
//  EduClassPad
//
//  Created by lyy on 2017/11/23.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoOneView.h"
#import "TKVideoSmallView.h"

@interface TKVideoOneView()
@end

@implementation TKVideoOneView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (void)setVideoSmallViewArray:(NSMutableArray *)videoSmallViewArray{
    
    TKVideoSmallView *view =(TKVideoSmallView *) videoSmallViewArray[0];
    [self addSubview:view];
    view.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
 
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
