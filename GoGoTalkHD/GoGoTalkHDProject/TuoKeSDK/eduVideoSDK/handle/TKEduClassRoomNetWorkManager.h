//
//  TKEduClassRoomNetWorkManager.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
typedef int(^bCheckRoomdidComplete)( id _Nullable response ,NSString* _Nullable aPassWord);
typedef int(^bCheckRoomError)( NSError *_Nullable aError);
typedef void(^bGetGifInfoComplete)( id _Nullable response);
typedef int(^bGetGifInfoError)( NSError *_Nullable aError);
typedef int(^bTranslationComplete)( id _Nullable response ,NSString* _Nullable aTranslationString);
@interface TKEduClassRoomNetWorkManager : NSObject

+(void)checkRoom:(NSString *_Nonnull)aRoomId aPwd:(NSString *_Nonnull)aPwd aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aUserID:(NSString *_Nonnull)aUserID aDidComplete:(bCheckRoomdidComplete _Nullable  )aDidComplete aNetError:(bCheckRoomError _Nullable) aNetError;

+(void)getGiftinfo:(NSString *_Nonnull)aRoomId aParticipantId:(NSString *_Nonnull)aParticipantId aHost:(NSString*_Nonnull)aHost aPort:(NSString *_Nonnull)aPort aGetGifInfoComplete:(bGetGifInfoComplete _Nullable )aGetGifInfoComplete aGetGifInfoError:(bGetGifInfoError _Nullable)aGetGifInfoError;
+(void)translation:(NSString * _Nonnull )aTranslationString aTranslationComplete:(bTranslationComplete _Nonnull )aTranslationComplete;
@end
