//
//  TKEduClassRoomNetWorkManager.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class RoomUser;
#import "TKMacro.h"
typedef int(^bCheckRoomdidComplete)( id _Nullable response ,NSString* _Nullable aPassWord);
typedef int(^bCheckRoomError)( NSError *_Nullable aError);
typedef void(^bGetGifInfoComplete)( id _Nullable response);
typedef int(^bGetGifInfoError)( NSError *_Nullable aError);
typedef int(^bTranslationComplete)( id _Nullable response ,NSString* _Nullable aTranslationString);
typedef int(^bComplete)( id _Nullable response);
typedef void(^bSendGifInfoComplete)( id _Nullable response);
typedef int(^bSendGifInfoError)( NSError *_Nullable aError);
@protocol TKEduNetWorkDelegate <NSObject>

@optional
- (void)uploadProgress:(int)req totalBytesSent:(int64_t)totalBytesSent bytesTotal:(int64_t)bytesTotal;
- (void)uploadFileResponse:(id _Nullable )Response req:(int)req;
- (void)getMeetingFileResponse:(id _Nullable )Response;

@end

@interface TKEduNetManager : NSObject

+(void)checkRoom:(NSString *_Nonnull)aRoomId aPwd:(NSString *_Nonnull)aPwd aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aUserID:(NSString *_Nonnull)aUserID aUserRole:(UserType)aUserRole  aDidComplete:(bCheckRoomdidComplete _Nullable )aDidComplete aNetError:(bCheckRoomError _Nullable) aNetError;
+(void)getGiftinfo:(NSString *_Nonnull)aRoomId aParticipantId:(NSString *_Nonnull)aParticipantId aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aGetGifInfoComplete:(bGetGifInfoComplete _Nullable )aGetGifInfoComplete aGetGifInfoError:(bGetGifInfoError _Nullable)aGetGifInfoError;
+(void)translation:(NSString * _Nonnull )aTranslationString aTranslationComplete:(bTranslationComplete _Nonnull )aTranslationComplete;
+(void)delRoomFile:(NSString * _Nonnull )roomID docid:(NSString *_Nonnull)docid isMedia:(bool)isMedia    aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aDelComplete:(bComplete _Nonnull )aDelComplete;
+(void)sendGifForRoomUser:(NSArray *_Nonnull)aRoomUserArray  roomID:(NSString * _Nonnull )roomID   aMySelf:(RoomUser *_Nonnull)aMySelf aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aSendComplete:(bSendGifInfoComplete _Nonnull )aSendComplete;
#pragma mark 上传文档暂时无用
- (int)uploadWithRequestURL:(NSString*_Nullable)requestURL meetingID:(int)meetingid fileData:(NSData *_Nullable)fileData fileName:(NSString *_Nullable)fileName userName:(NSString *_Nullable)userName;
- (void)getmeetingfile:(int)meetingid requestURL:(NSString *_Nullable)requestURL;
#pragma mark 下课
+(void)classBeginEnd:(NSString * _Nonnull )roomID companyid:(NSString *_Nonnull)companyid  aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aComplete:(bComplete _Nonnull )aComplete;




@end
