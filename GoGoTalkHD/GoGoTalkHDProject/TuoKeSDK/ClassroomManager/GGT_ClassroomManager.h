//
//  GGT_ClassroomManager.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/9/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TKLeftClassroomBlock)();

@interface GGT_ClassroomManager : NSObject

+ (void)chooseClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_CourseCellModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock;

//+ (void)tk_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_CourseCellModel *)model leftRoomBlock:(TKLeftClassroomBlock)leftRoomBlock;
//
//+ (void)bjy_enterClassroomWithViewController:(UIViewController *)viewController courseModel:(GGT_CourseCellModel *)model;

@end
