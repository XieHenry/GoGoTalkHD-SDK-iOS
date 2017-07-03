//
//  UITableView+XCPlaceholderView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/7.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "UITableView+XCPlaceholderView.h"
#import "NSObject+XCMethodSwizzle.h"


@implementation UITableView (XCPlaceholderView)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(reloadData) withMethod:@selector(xc_reloadData)];
    });
}

- (void)xc_reloadData
{
    if (self.enablePlaceHolderView) {
        NSInteger sectionCount = self.numberOfSections;
        NSInteger rowCount = 0;
        for (int i = 0; i < sectionCount; i++) {
            rowCount += [self.dataSource tableView:self numberOfRowsInSection:i];
        }
        if (rowCount == 0) {
            [self addSubview:self.xc_PlaceHolderView];
        }
        else
        {
            [self.xc_PlaceHolderView removeFromSuperview];
        }
    }
    [self xc_reloadData];
}

// 是否开启占位图
- (void)setEnablePlaceHolderView:(BOOL)enblePlaceHolderView
{
    objc_setAssociatedObject(self, @selector(enablePlaceHolderView), @(enblePlaceHolderView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enablePlaceHolderView
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(enablePlaceHolderView));
    return number.boolValue;
}


// 占位图
- (void)setXc_PlaceHolderView:(UIView *)xc_PlaceHolderView
{
    objc_setAssociatedObject(self, @selector(xc_PlaceHolderView), xc_PlaceHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)xc_PlaceHolderView
{
    UIView *placeHolder = objc_getAssociatedObject(self, @selector(xc_PlaceHolderView));
    if (!placeHolder) {
        placeHolder  = [[UIView alloc] initWithFrame:self.bounds];
        self.xc_PlaceHolderView = placeHolder;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [placeHolder addGestureRecognizer:tap];
    
    return placeHolder;
}

// 点击事件
- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.xc_clickBlock) {
        self.xc_clickBlock();
    }
}


// 点击空白处的回调
- (void)setXc_clickBlock:(XCClickBlock)xc_clickBlock
{
    objc_setAssociatedObject(self, @selector(xc_clickBlock), xc_clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (XCClickBlock)xc_clickBlock
{
    return objc_getAssociatedObject(self, _cmd);
//    return objc_getAssociatedObject(self, @selector(xc_clickBlock));
}

- (void)xc_clickPlaceholderWithClickBlock:(XCClickBlock)clickBlock
{
    self.xc_clickBlock = clickBlock;
}




@end
