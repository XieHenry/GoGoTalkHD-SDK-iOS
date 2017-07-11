//
//  GGT_FocusOnOfPageView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/6/19.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_FocusOnOfPageView.h"

@implementation GGT_FocusOnOfPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageScrollView = [[GGT_FocusOnOfPageScrollView alloc] init];
        [self.pageScrollView setPagingEnabled:YES];
        [self.pageScrollView setClipsToBounds:NO];
        [self addSubview:self.pageScrollView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self pointInside:point withEvent:event]) {
        return self.pageScrollView;
    }
    return [super hitTest:point withEvent:event];
}

@end
