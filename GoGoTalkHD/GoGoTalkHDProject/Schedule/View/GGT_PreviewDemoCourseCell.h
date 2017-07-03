//
//  GGT_PreviewDemoCourseCell.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/9.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGT_PreviewDemoCourseCellDelegate <NSObject>

- (void)previewDemoCourseCellHeightWithHeight:(CGFloat)height;

@end

@interface GGT_PreviewDemoCourseCell : UITableViewCell

@property (nonatomic, strong) WKWebView *xc_webView;

@property (nonatomic, strong) GGT_EvaReportModel *xc_reportModel;

@property (nonatomic, assign) CGFloat xc_height;

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id <GGT_PreviewDemoCourseCellDelegate> delegate;

@property (nonatomic, strong) GGT_ResultModel *xc_resultModel;

@end
