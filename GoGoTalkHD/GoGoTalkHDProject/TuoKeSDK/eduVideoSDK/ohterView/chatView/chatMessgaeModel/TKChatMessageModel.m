//
//  TKChatMessageModel.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/12.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKChatMessageModel.h"

#import "TKMacro.h"

@implementation TKChatMessageModel
- (instancetype)initWithFromid:(NSString *)aFromid aTouid:(NSString*)aTouid iMessageType:(MessageType)aMessageType aMessage:(NSString*) aMessage aUserName:(NSString*)aUserName aTime:(NSString*)aTime
{
    if (self = [super init]) {
        
        _iUserName    = aUserName;
        _iToUid       = aTouid;
        _iFromid      = aFromid;
        _iMessageType = aMessageType;
        _iMessage     = aMessage;
        _iTime        = aTime;
        switch (aMessageType) {
            case MessageType_Teacher:
            {
                
                 _iUserName     = [NSString stringWithFormat:@"%@(%@)",_iUserName,MTLocalized(@"Role.Teacher")];
                _iMessageTypeColor = RGBACOLOR_teacherTextColor_Red;
                 break;
            }
            case MessageType_Me:
            {
                _iUserName     = [NSString stringWithFormat:@"%@(%@)",_iUserName,MTLocalized(@"Role.Me")];
                _iMessageTypeColor = RGBACOLOR_studentTextColor_Yellow;
                break;
            }
            case MessageType_OtherUer:{
                _iUserName         = aUserName;
                _iMessageTypeColor = RGBACOLOR_studentTextColor_Yellow;
            }
            default:{
                
                _iUserName     = aUserName;
                //_iMessageTypeColor = RGBACOLOR_studentTextColor_Yellow;
                 break;
            }
               
        }
    }
    return self;
}
@end
