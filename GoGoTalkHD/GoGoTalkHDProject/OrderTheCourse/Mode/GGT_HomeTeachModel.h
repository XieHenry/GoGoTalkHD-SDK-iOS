//
//  GGT_HomeTeachModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/14.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_HomeTeachModel : NSObject

@property (nonatomic, assign) NSInteger Age;
@property (nonatomic, strong) NSString *BookingId;
@property (nonatomic, strong) NSString *FileTittle;
@property (nonatomic, strong) NSString *ImageUrl;
@property (nonatomic, strong) NSString *IsFollow;
@property (nonatomic, assign) NSInteger LessonCount;
@property (nonatomic, strong) NSString *LessonId;
@property (nonatomic, strong) NSString *Sex;
@property (nonatomic, strong) NSString *StartTime;
@property (nonatomic, assign) NSInteger TeacherId;
@property (nonatomic, strong) NSString *TeacherName;

@end

/*
 Age = 22;
 BookingId = 57;
 FileTittle = "HXG3Kids Box2_2";
 ImageUrl = "http://manage.gogo-talk.com:9332";
 IsFollow = 0;
 LessonCount = 937;
 LessonId = 5979539;
 Sex = "男";
 StartTime = "17-07-14 19:00";
 TeacherId = 69919;
 TeacherName = liu2;
 */
