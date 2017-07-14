//
//  GGT_FocusImgModel.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/14.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_FocusImgModel : NSObject
//头像
@property (nonatomic, copy) NSString *ImageUrl;
//教师id
@property (nonatomic, assign) NSInteger TeacherId;
//教师姓名
@property (nonatomic, copy) NSString *TeacherName;

@end
