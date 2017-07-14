//
//  GGT_Request_URL.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/10.
//  Copyright © 2017年 Chn. All rights reserved.
//

#ifndef GGT_Request_URL_h
#define GGT_Request_URL_h

static NSString * const BASE_REQUEST_URL = @"http://learnapi.gogo-talk.com:9332";
//static NSString * const BASE_REQUEST_URL = @"http://yiyuanyan.f3322.org:8000/index.php/Index/index/get_categorys";

/*登录注册*/
//注册
static NSString * const URL_Resigt = @"/api/APP/AppRegist";
//登录
static NSString * const URL_Login = @"/api/APP/AppLogin";
//app 发送短信验证码
static NSString * const URL_GetChangePasswordSMS = @"/api/APP/AppSendChangePwdSMS";
//修改密码（根据手机号修改密码）
static NSString * const URL_ChangePwdByCode = @"/api/APP/AppChangePwdByCode";






/*约课*/
//获取学生关注的教师信息
static NSString * const URL_GetTeacherFollowApp = @"/api/APP/GetTeacherFollowApp";
//学员关注、取消关注 教师
static NSString * const URL_GetAttention = @"/api/APP/Attention";
//获取关注的老师一周的排课情况
static NSString * const URL_GetTimeByTeacherId = @"/api/APP/GetTimeByTeacherId";
//获取教师排课日历
static NSString * const URL_GetTeacherBulkApp = @"/api/APP/GetTeacherBulkApp";



/*我的*/
//修改密码（根据旧密码修改新密码）
static NSString * const URL_ChangePwdByOldPwd = @"/api/APP/AppChangePwdByOldPwd";
//获取学生信息列表
static NSString * const URL_GetStudentInfo = @"/api/APP/AppGetStudentInfo";
//修改学生信息列表
static NSString * const URL_UpdateStudentInfo = @"/api/APP/AppUpdateStudentInfo";
//获取课程统计信息
static NSString * const URL_GetLessonStatistics = @"/api/APP/GetLessonStatistics";
//获取我的课时
static NSString * const URL_GetMyClassHour = @"/api/APP/GetMyClassHour";
//意见反馈
static NSString * const URL_OpinionFeedback = @"/api/APP/OpinionFeedback";
//测评报告
static NSString * const URL_GetReportsList = @"/api/APP/AppGetReportsList";
//关于我们
static NSString * const URL_GetAboutUs = @"/ipad/abouts/wlh_about.html";
//检测token是否过期
static NSString * const URL_GetTokenInvalid = @"/api/APP/GetTokenInvalid";
//是否审核状态
static NSString * const URL_GetTesting = @"/api/APP/GetTesting";
//获取左侧选项数据
static NSString * const URL_GetInfo = @"/api/APP/GetInfo";




// 日历Calendar
static NSString * const URL_LessonList = @"api/APP/AppStuLessonList";

// 日历下面数据Course
static NSString * const URL_GetMyLesson = @"api/APP/AppGetMyLesson";

// 学生对教师的评价
static NSString * const URL_AppStudentEvaluateTeacher = @"api/APP/AppStudentEvaluateTeacher";

// 取消约课
static NSString * const URL_DelLesson = @"api/APP/DelLesson";

// 预约试听课
static NSString * const URL_AddDemoMsg = @"api/APP/AddDemoMsg";

// 获取课程详情
static NSString * const URL_GetLessonByLessonId = @"api/APP/GetLessonByLessonId";

// 获取最近上课信息
static NSString * const URL_AppStuLatelyLesson = @"api/APP/AppStuLatelyLesson";

// 获取常用语句
static NSString * const URL_GetContrastInfo = @"api/APP/GetContrastInfo";

// 发送log日志
static NSString * const URL_PostLog = @"api/APP/Applog";

// 获取上课日期
static NSString * const URL_GetDate = @"api/APP/GetDate";

// 获取时间
static NSString * const URL_GetTime = @"api/APP/GetTime";

// 获取所有教师列表
static NSString * const URL_GetPageTeacherLessonApp = @"api/APP/GetPageTeacherLessonApp";

// 约课
static NSString * const URL_GetBookList_Home = @"api/APP/GetBookList";

// 获得教材列表
static NSString * const URL_GetBookList = @"api/APP/GetBookList";

// 重上课程
static NSString * const URL_AgainLesson = @"api/APP/AgainLesson";


#endif /* GGT_Request_URL_h */
