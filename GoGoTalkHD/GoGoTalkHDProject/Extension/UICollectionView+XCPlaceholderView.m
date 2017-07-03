//
//  UICollectionView+XCPlaceholderView.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/7.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "UICollectionView+XCPlaceholderView.h"
#import "NSObject+XCMethodSwizzle.h"


@implementation UICollectionView (XCPlaceholderView)

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
        NSInteger sectionCount =  [self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)] ? [self.dataSource numberOfSectionsInCollectionView:self] : 1;
        NSInteger rowCount = 0;
        for (int i = 0; i < sectionCount; i++) {
            rowCount += [self.dataSource collectionView:self numberOfItemsInSection:i];
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


- (void)setEnablePlaceHolderView:(BOOL)enblePlaceHolderView
{
    objc_setAssociatedObject(self, @selector(enablePlaceHolderView), @(enblePlaceHolderView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enablePlaceHolderView
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(enablePlaceHolderView));
    return number.boolValue;
}

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
    return placeHolder;
}

@end
