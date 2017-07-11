//
//  OrderTimeTagsView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/9.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "OrderTimeTagsView.h"
#import <QuartzCore/QuartzCore.h>

#define LABEL_MARGIN 15.0f
#define BOTTOM_MARGIN 10.0f

@implementation OrderTimeTagsView
@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:view];
    }
    return self;
}

- (void)setTags:(NSArray *)array {
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color {
    lblBackgroundColor = color;
    [self display];
}

- (void)display {
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    float totalWidth = 0;
    float Width = 0;

    
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {

        UILabel *label = nil;
        if (!gotPreviousFrame) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LineW(54), LineH(24))];

            totalHeight = LineH(24);
            totalWidth = LineW(54);

        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + LineW(54) + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + LineH(24) + BOTTOM_MARGIN);
                totalHeight += totalHeight + BOTTOM_MARGIN;
                Width = self.frame.size.width;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
                totalWidth = previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN + LineW(54);
            }
            newRect.size = CGSizeMake(LineW(54), LineH(24));
            label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:[UIFont systemFontOfSize:self.textSize]];
        if (!lblBackgroundColor) {
            [label setBackgroundColor:self.textbackgroundColor];
        } else {
            [label setBackgroundColor:lblBackgroundColor];
        }
        [label setTextColor:self.textColor];
        [label setText:text];
        label.textAlignment = NSTextAlignmentCenter;
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:self.cornerRadius];
        [label.layer setBorderColor:self.bordColor.CGColor];
        [label.layer setBorderWidth:LineW(0.5)];
        label.userInteractionEnabled = self.allowClick;
        

        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, label.width, label.height)];
        control.tag = [textArray indexOfObject:text];
        [control addTarget:self action:@selector(clickTagWithControl:) forControlEvents:UIControlEventTouchUpInside];
        [label addSubview:control];
        [self addSubview:label];
        
    }
    if (Width > totalWidth) {
        sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);

    } else {
        sizeFit = CGSizeMake(totalWidth, totalHeight + 1.0f);

    }

}

- (CGSize)fittedSize {
    return sizeFit;
}

- (void)clickTagWithControl:(UIControl *)control {
    self.tagClickedBlock([self.textArray safe_objectAtIndex:control.tag]);
}
@end
