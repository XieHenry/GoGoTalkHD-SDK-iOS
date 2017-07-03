//
//  GGT_PreviewCoursewareVC.h
//  GoGoTalk
//
//  Created by 辰 on 2017/5/5.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XCDeleteCourseBlock)();
typedef void(^XCChangeStatusBlock)(GGT_CourseCellModel *xc_model);

@interface GGT_PreviewCoursewareVC : BaseBackViewController

@property (nonatomic, strong) GGT_CourseCellModel *xc_model;

@property (nonatomic, copy) XCDeleteCourseBlock xc_deleteBlock;

@property (nonatomic, copy) XCChangeStatusBlock xc_changeStatusBlock;

@end
