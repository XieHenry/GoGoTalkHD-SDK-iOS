//
//  GGT_PreviewCoursewareCell.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/22.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGT_PreviewCoursewareCellDelegate <NSObject>

- (void)previewCoursewareCellHeightWithHeight:(CGFloat)height;

@end

@interface GGT_PreviewCoursewareCell : UITableViewCell

@property (nonatomic, strong) WKWebView *xc_webView;

@property (nonatomic, strong) GGT_CourseCellModel *xc_model;

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, assign) CGFloat xc_height;

@property (nonatomic, weak) id <GGT_PreviewCoursewareCellDelegate> delegate;

@end
