//
//  XCLogManager.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/4.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "XCLogManager.h"

@implementation XCLogManager

// 将LOG日志写入文件
// 将NSlog打印信息保存到Document目录下的文件中
+ (void)xc_redirectNSlogToDocumentFolder
{
    
#ifdef DEBUG
    // 不做处理
    
//#else
    // 记录日志
    //document文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //
    NSString *foldPath = [documentDirectory stringByAppendingFormat:@"/appLog"];
    
    //文件保护等级
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:NSFileProtectionNone
                                                          forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] createDirectoryAtPath:foldPath withIntermediateDirectories:YES attributes:attribute error:nil];
    NSString *logFilePath = [foldPath stringByAppendingFormat:@"/123.log"];
    
    [self checkFlieProtection:logFilePath];
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
#endif
    
}
+ (void)checkFlieProtection:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathSqlite = path;
    NSDictionary *attributeSql = [fileManager attributesOfItemAtPath:pathSqlite error:nil];
    if ([[attributeSql objectForKey:NSFileProtectionKey] isEqualToString:NSFileProtectionComplete]) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObject:NSFileProtectionCompleteUntilFirstUserAuthentication
                                                              forKey:NSFileProtectionKey];
        [fileManager setAttributes:attribute ofItemAtPath:pathSqlite error:nil];
        NSLog(@"改变文件权限 %@ : %@",path,attribute);
    }
}

// 读取日志文件
+ (void)xc_readDataFromeFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //
    NSString *foldPath = [documentDirectory stringByAppendingFormat:@"/appLog"];
    NSString *logFilePath = [foldPath stringByAppendingFormat:@"/123.log"];
    
    NSData* data = [[NSData alloc] init];
    NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:logFilePath];
    data = [fh readDataToEndOfFile];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    // 发送网络请求
    [self sendLogNetworkWithContent:result];
}


// 删除日志文件
+ (void)xc_deleteLogData
{
    //document文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *foldPath = [documentDirectory stringByAppendingFormat:@"/appLog"];
    NSString *logFilePath = [foldPath stringByAppendingFormat:@"/123.log"];
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:logFilePath];
    if (!blHave) {
        NSLog(@"文件不存在");
        return ;
    }else {
        NSLog(@"存在");
        BOOL blDele= [fileManager removeItemAtPath:logFilePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}

/// 发送日志的网络请求
+ (void)sendLogNetworkWithContent:(NSString *)content
{
    
    content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"strContent"] = content;
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[BaseService share] sendPostRequestWithPath:URL_PostLog parameters:nil token:YES viewController:vc showMBProgress:NO success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}


@end
