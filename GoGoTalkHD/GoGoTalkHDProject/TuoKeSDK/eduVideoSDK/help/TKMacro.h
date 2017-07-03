//
//  TKMacro.h
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/28.
//  Copyright © 2017年 beijing. All rights reserved.
//

#ifndef TKMacro_h
#define TKMacro_h
#ifdef DEBUG
#define TKLog(...) NSLog(__VA_ARGS__)
#else
#define TKLog(...) do { } while (0)
#endif
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])
#define UIColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:a])
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]



#define RGBACOLOR_teacherTextColor_Red  RGBCOLOR(208, 59, 7)
#define RGBACOLOR_studentTextColor_Yellow  RGBCOLOR(244, 209, 12)


#define TKFont(s) [UIFont fontWithName:@"PingFang-SC-Light" size:s]

//屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width
// 状态栏高度
#define StatusH 20
//导航栏高度
#define NavigationH 44
//屏幕比例，相对pad 1024 * 768
#define Proportion (ScreenH/768.0)

#define TEXT_FONT TKFont(14)
#define Name_FONT TKFont(15)

#define BUNDLE_NAME @ "Resources.bundle"

#define BUNDLE [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: BUNDLE_NAME]]

#define LOADIMAGE(name) [UIImage imageWithContentsOfFile:[[BUNDLE resourcePath] stringByAppendingPathComponent:name]]

#define MTLocalized(s) [BUNDLE localizedStringForKey:s value:@"" table:nil]

 #define IS_CH_SYMBOL(chr) ((int)(chr)>127)
static NSString *const sAPP_ID = @"20170605000052251";
static NSString *const sSECURITY_KEY = @"sYlf3rTdnEGTOKr1FuT1";
static NSString *const sTRANS_API_HOST = @"http://api.fanyi.baidu.com/api/trans/vip/translate";


typedef NS_ENUM(NSInteger, SpeakStatus) {
    m_RequestSpeak_Disable= 0,//没发言
    m_RequestSpeak_Allow,//发言中
    m_RequestSpeak_Pending//申请发言状态，未决状态
};

typedef NS_ENUM(NSInteger, HostStatus) {
    m_RequestHost_Disable= 0,//非主讲
    m_RequestHost_Allow,//主讲中
    m_RequestHost_Pending//申请主讲中，等待主席同意
};

enum MeetingMode
{
    m_MeetingMode_Free,  //自由会议模式
    m_MeetingMode_ChairmanControl   //主席控制模式
};
enum SpeakMode
{
    m_SpeakMode_Free,  //自由发言模式
    m_SpeakMode_Chairman //主席控制模式
};
enum ControlMode
{
    m_ControlMode_Free,  //自由发言模式
    m_ControlMode_Chairman //主席控制模式
};
enum RecordMode
{
    m_RecordMode_Free,  //自由录制模式
    m_RecordMode_Chairman//主席控制模式，只有主席和主讲可录制
};
enum KickReason
{
    m_S2C_Kickout_ChairmanKickout,		    //主席剔出
    m_S2C_Kickout_Repeat                    //重复登录
};



//tuyy add
typedef NS_ENUM(NSInteger, UserVideoFocusStatus) {
    UserVideoFocusStatusNormal,
    UserVideoFocusStatusSip,
    UserVideoFocusStatusCloudRecord
};

typedef NS_ENUM(NSInteger, MessageType) {
    MessageType_Teacher,		    //老师
    MessageType_Me,                 //我
    MessageType_OtherUer,          //其他
    MessageType_Message		       //消息
};
typedef NS_ENUM(NSInteger, PublishState) {
    PublishState_NONE      = 0,		    //没有
    PublishState_AUDIOONLY =1,		    //只有音频
    PublishState_VIDEOONLY =2,		//只有视频
    PublishState_BOTH      =3		        //都有
};

typedef NS_ENUM(NSInteger, UserType) {
    UserType_Teacher   = 0,		    //老师
    UserType_Assistant =1,           //助教
    UserType_Student   =2            //学生
};
typedef NS_ENUM(NSInteger, RoomType) {
    RoomType_OneToOne   = 0,		    //小班
    RoomType_OneToMore  = 1,           //大班
};

typedef NS_ENUM(NSInteger, VideoViewTag) {
    VideoViewTag_TeacherVideoView       =0,		    //老师视频
    VideoViewTag_OurVideoView           =1,		    //我视频
    VideoViewTag_OurVideoBottomView     =2,		    //我
    VideoViewTag_Student1VideoView      =3,		    //学生1
    VideoViewTag_Student2VideoView      =4,		    //学生2
    VideoViewTag_Student3VideoView      =5,         //学生3
    VideoViewTag_Student4VideoView      =6,		    //学生4
    VideoViewTag_Student5VideoView      =7,		    //学生5
};

typedef NS_ENUM(NSInteger, EVideoRole)
{
    EVideoRoleTeacher,
    EVideoRoleOur,
    EVideoRoleOther
};

typedef NS_ENUM(NSInteger, MediaProgressAction) {
    MediaProgressAction_OtherNeedProgress     =-1,		    //别人向我要进度
    MediaProgressAction_PlayOrPause           =0,		    //播放或暂停
    MediaProgressAction_ChangeProgress        =1            //进度改变
   
};
typedef NS_ENUM(NSInteger, Playertype) {
    PlayertypeAudio,    // 播放音频
    PlayertypeVideo     // 播放视频
};
typedef NS_ENUM(NSInteger, FileListType) {
    FileListTypeAudioAndVideo,    //视频列表
    FileListTypeDocument,        // 文档列表
    FileListTypeUserList         //用户列表
};
static  NSString *const sChairmancontrol            = @"chairmancontrol";
static  NSString *const sClassBegin                 = @"ClassBegin";
static  NSString *const sWBPageCount                = @"WBPageCount";
static  NSString *const sShowPage                   = @"ShowPage";
static  NSString *const sDocumentFilePage_ShowPage  = @"DocumentFilePage_ShowPage";

static  NSString *const sSharpsChange          = @"SharpsChange";
static  NSString *const sDocumentChange        = @"DocumentChange";

static  NSString *const sUpdateTime          = @"UpdateTime";
static  NSString *const sMuteAudio           = @"MuteAudio";
static  NSString *const sRaisehand           = @"raisehand";
static  NSString *const sPublishstate        = @"publishstate";
static  NSString *const sTellAll             = @"__all";
static  NSString *const sTellNone            = @"__none";
static  NSString *const sTellAllExpectSender = @"__allExceptSender";
static  NSString *const sTellAllExpectAuditor = @"__allExceptAuditor";
static  NSString *const sGiftNumber          = @"giftnumber";
static  NSString *const sCandraw             = @"candraw";
static  NSString *const sSendBoardData       = @"sendBoardData";
static  NSString *const sDeleteBoardData     = @"deleteBoardData";
static  NSString *const sOnPageFinished      = @"onPageFinished";
static  NSString *const sPrintLogMessage     = @"printLogMessage";
static  NSString *const sfullScreenToLc      = @"fullScreenToLc";
//播放mp3，mp4
static  NSString *const sVideo_MediaFilePage_ShowPage   = @"Video_MediaFilePage_ShowPage";
static  NSString *const sAudio_MediaFilePage_ShowPage   = @"Audio_MediaFilePage_ShowPage";
static  NSString *const sMediaProgress                  = @"MediaProgress";
static  NSString *const sMediaProgress_video_1          = @"MediaProgress_video_1";
static  NSString *const sMediaProgress_audio_1          = @"MediaProgress_audio_1";
//#define Debug 1;
static  NSString *const sHttp   = @"https";




#define INVOKE_PARAM(x,i) (x)[[NSString stringWithFormat:@"__index__value__%d",(i)]]

#define SENDMSGTOALL_EXCEPT_ME			0
#define SENDMSGTOALL					0xFFFFFFFF
#define SENDMSGTOSERVER					0xFFFFFFFE

#define KEY_NAME     @"m_NickName"
#define KEY_THIRDID  @"m_BuddyID"
#define KEY_USERTYPE @"m_UserType"
#define KEY_HIDESELF @"m_HideSelf"
#define KEY_HASVIDEO @"m_HasVideo"
#define KEY_HASAUDIO @"m_HasAudio"

#endif /* TKMacro_h */
