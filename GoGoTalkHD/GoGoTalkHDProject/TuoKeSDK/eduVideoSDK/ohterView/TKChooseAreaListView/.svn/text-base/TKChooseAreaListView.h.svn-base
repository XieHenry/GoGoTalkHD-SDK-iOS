//
//  TKChooseAreaListView.h
//  EduClassPad
//
//  Created by tom555cat on 2017/11/18.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKAreaChooseModel;

@protocol TKChooseAreaDelegate <NSObject>
- (void)chooseArea:(TKAreaChooseModel *)areaModel;
@end

@interface TKChooseAreaListView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<TKChooseAreaDelegate> delegate;
- (void)showView;
- (void)hideView;
- (void)setServerName:(NSString *)serverName;

@end
