//
//  GGT_OrderClassPopVC.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/13.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^isOrderCourse)(BOOL  yes);
@interface GGT_OrderClassPopVC : BaseViewController

//因为3个地方需要改model，所以会造成混乱，现在暂时先单个赋值
//@property (nonatomic, strong) GGT_HomeTeachModel *xc_model;

@property (nonatomic, copy) NSString *ImageUrl;
@property (nonatomic, copy) NSString *TeacherName;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *LessonId;


@property (nonatomic, copy) isOrderCourse orderCourse;
@end
