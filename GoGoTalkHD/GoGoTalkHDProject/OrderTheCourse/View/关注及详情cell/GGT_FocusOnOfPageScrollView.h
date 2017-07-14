//
//  GGT_FocusOnOfPageScrollView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/6/19.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGT_FocusOnOfPageScrollView;
@protocol OTPageScrollViewDelegate <UIScrollViewDelegate>
@required
- (NSInteger)numberOfPageInPageScrollView:(GGT_FocusOnOfPageScrollView*)pageScrollView;
@optional
- (CGSize)sizeCellForPageScrollView:(GGT_FocusOnOfPageScrollView*)pageScrollView;
- (void)pageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index;
@end

@protocol OTPageScrollViewDataSource <UIScrollViewDelegate>
@required
- (UIView*)pageScrollView:(GGT_FocusOnOfPageScrollView *)pageScrollView viewForRowAtIndex:(int)index;
@end



@interface GGT_FocusOnOfPageScrollView : UIScrollView

@property (nonatomic, assign) CGSize  cellSize;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) float leftRightOffset;
@property (nonatomic, assign) NSInteger selectedIndex; //点击选中的第几个
@property (nonatomic, weak) id<OTPageScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<OTPageScrollViewDelegate> delegate;
@property BOOL isfirst;
//选中的状态
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger page;


- (void)reloadData;
- (UIView*)viewForRowAtIndex:(NSInteger)index;

@end
