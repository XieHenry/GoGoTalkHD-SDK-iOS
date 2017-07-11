//
//  GGT_CourseCellModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/24.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_CourseCellModel : NSObject
@property (nonatomic, strong) NSString *FilePath;
@property (nonatomic, assign) NSInteger IsDemo;
@property (nonatomic, strong) NSString *LessonId;
@property (nonatomic, strong) NSString *LessonName;
@property (nonatomic, strong) NSString *StartTime;
@property (nonatomic, strong) NSString *StartTimeStamp;
@property (nonatomic, strong) NSString *Status;
@property (nonatomic, strong) NSString *TeacherName;

@property (nonatomic, assign) NSInteger CountDown; // 倒计时
@property (nonatomic, strong) NSString *Remark;     // 学生评价内容
@property (nonatomic, assign) NSInteger StuLikeTchStar; //学生对老师的好评
@property (nonatomic, assign) NSInteger SturememberStar;    // 学生对上课的记忆程度
@property (nonatomic, assign) NSInteger StuScore;       //老师对学生的评价
@property (nonatomic, strong) NSString *ImageUrl;   // 老师头像
@property (nonatomic, strong) NSString *LateTime;

@property (nonatomic, strong) NSString *Age;
@property (nonatomic, strong) NSString *Gender;

@property (nonatomic, assign) NSInteger IsComment;
@property (nonatomic, assign) NSInteger IsStuComment;

// 直播上课的信息
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *serial;
@property (nonatomic, strong) NSString *stuPwd;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *userrole;

@property (nonatomic, strong) NSString *StuRemark;
@property (nonatomic, assign) NSInteger IsShowBooking;

@end

/*
 IsComment      外教是否评价 0 未评价 1 评价
 IsStuComment   学生是否评价 0 未评价 1 评价
 "LessonId": "65450",  （课程ID）
 "LessonName": "Phonics FFPhonics1_12", （课程名称）
 "StartTime": "2017-05-25 17:30",   （课程时间）
 "Status": 1,    （0：已经预约 1：即将上课 2：正在上课 3：已经结束 待评价 4：已经结束 已评价 5：已经结束 缺席）
 "IsDemo":0,        （上课类型 0:正课 1：体验课）
 "TeacherName": "qe1",    （教师名称）
 "StartTimeStamp": "2017-05-25T09:30:00Z",
 "FilePath": "/UploadFiles/Book/201702192138146543.pdf"（课程文件路径）
 "CountDown":0  倒计时
 
 Remark = 123321;   学生评价内容
 StuLikeTchStar = 3;  学生对老师的好评
 StuScore = 0;      老师对学生的评价
 SturememberStar = 3;
 TotalStar = 5;     老师对学生评价的总星星个数
 
 
 host = "global.talk-cloud.com";
 nickname = student;
 port = 443;
 serial = 495009715;
 stuPwd = 2222;
 userid = 413508;
 userrole = 2;

 */
