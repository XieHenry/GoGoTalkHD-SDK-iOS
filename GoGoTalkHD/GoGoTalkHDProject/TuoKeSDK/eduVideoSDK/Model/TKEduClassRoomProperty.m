//
//  TKEduClassRoomProperty.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduClassRoomProperty.h"

@implementation TKEduClassRoomProperty

-(void)parseMeetingInfo:(NSDictionary*) params
{
  
    
    _iRoomName    = [params objectForKey:@"roomname"]?[params objectForKey:@"roomname"]:@"";
    _iRoomId      = [params objectForKey:@"serial"]?[params objectForKey:@"serial"]:@"";
    _sWebIp       = [params objectForKey:@"host"]?[params objectForKey:@"host"]:@"global.talk-cloud.com";
    _sWebPort     = [params objectForKey:@"port"]?[params objectForKey:@"port"]:@"443";
    _sNickName    = [params objectForKey:@"nickname"]?[params objectForKey:@"nickname"]:@"";
    _sDomain      = [params objectForKey:@"domain"]?[params objectForKey:@"domain"]:@"www";
    _sCmdPassWord = [params objectForKey:@"password"]?[params objectForKey:@"password"]:@"";
    _iUserId      = [params objectForKey:@"userid"]?[params objectForKey:@"userid"]:@"0";
    _sCmdUserRole = [params objectForKey:@"userrole"]?[[params objectForKey:@"userrole"]intValue]:0;
  
}

@end
