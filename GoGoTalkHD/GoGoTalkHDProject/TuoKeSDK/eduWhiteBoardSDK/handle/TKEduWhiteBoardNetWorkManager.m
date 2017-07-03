//
//  TKEduWhiteBoardNetWorkManager.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduWhiteBoardNetWorkManager.h"
static int req = 1000;
static NSString * const FORM_FLE_INPUT = @"filedata";
@implementation TKEduWhiteBoardNetWorkManager
+ (TKEduWhiteBoardNetWorkManager *)wbRequsetManagerWithDelegate:(id<TKEduWhiteBoardNetWorkDelegate>)delegate;
{
    TKEduWhiteBoardNetWorkManager *manager = nil;
    if (manager == nil) {
        manager = [[TKEduWhiteBoardNetWorkManager alloc] init];
        manager.iRequestDelegate = delegate;
    }
    return manager;
}
- (int)uploadWithRequestURL:(NSString*)requestURL meetingID:(int)meetingid fileData:(NSData *)fileData fileName:(NSString *)fileName userName:(NSString *)userName
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    NSMutableData *myRequestData=[NSMutableData data];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSMutableString *body=[[NSMutableString alloc]init];
    NSDictionary *dataDic = @{@"serial" : @(meetingid),
                              @"sender" : userName,
                              @"conversion" : @1,
                              @"alluser" : @1};
    for (NSString *key in dataDic.allKeys)
    {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",dataDic[key]];
    }
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", FORM_FLE_INPUT,fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpge, image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if (fileData) {
        [myRequestData appendData:fileData];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc] initWithFormat:@"\r\n%@",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(uploadFileResponse:req:)]) {
                    NSDictionary *tResponseDic = @{@"result":@(-1)};
                    [_iRequestDelegate uploadFileResponse:tResponseDic req:req];
                }
            });
        }else{
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (json) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(uploadFileResponse:req:)]) {
                        [_iRequestDelegate uploadFileResponse:json req:req];
                    }
                });
            }
        }
        
    }];
    req++;
    [dataTask resume];
    return req;
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(uploadProgress:totalBytesSent:bytesTotal:)]) {
        [_iRequestDelegate uploadProgress:req totalBytesSent:totalBytesSent bytesTotal:totalBytesExpectedToSend];
    }
}

- (void)deleteDocumentByFileID:(int)fileID meetingID:(int)meetingid requestURL:(NSString *)requestURL
{
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSDictionary *post = @{@"serial" : @(meetingid),
                           @"fileid" : @(fileID)};
    
    NSMutableString * postString = [[NSMutableString alloc] init];
    if (post && [post isKindOfClass:[NSDictionary class]])
    {
        for (id key in [post allKeys])
        {
            [postString appendFormat:@"%@=%@&", key, [post objectForKey:key]];
        }
        [postString deleteCharactersInRange:NSMakeRange([postString length] - 1, 1)];
    }
    //将请求参数字符串转成NSData类型
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id json = nil;
        if (data) {
            json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        if (json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(deleteFileResponse:req:)]) {
                    [_iRequestDelegate deleteFileResponse:json req:fileID];
                }
            });
        }
    }];
    //req++;
    [dataTask resume];
}
- (void)getmeetingfile:(int)meetingid requestURL:(NSString *)requestURL
{
    NSURL *url = [NSURL URLWithString:requestURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSDictionary *post = @{@"serial" : @(meetingid)};
    
    NSMutableString * postString = [[NSMutableString alloc] init];
    if (post && [post isKindOfClass:[NSDictionary class]])
    {
        for (id key in [post allKeys])
        {
            [postString appendFormat:@"%@=%@&", key, [post objectForKey:key]];
        }
        [postString deleteCharactersInRange:NSMakeRange([postString length] - 1, 1)];
    }
    //将请求参数字符串转成NSData类型
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    request.HTTPMethod = @"POST";
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id json = nil;
        if (data) {
            json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        if (json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_iRequestDelegate && [_iRequestDelegate respondsToSelector:@selector(getMeetingFileResponse:)]) {
                    [_iRequestDelegate getMeetingFileResponse:json];
                }
            });
        }
    }];
    //req++;
    [dataTask resume];
}
@end
