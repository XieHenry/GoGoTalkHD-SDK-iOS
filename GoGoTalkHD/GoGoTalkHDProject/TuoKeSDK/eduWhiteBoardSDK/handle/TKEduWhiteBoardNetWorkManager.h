//
//  TKEduWhiteBoardNetWorkManager.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TKEduWhiteBoardNetWorkDelegate <NSObject>

@optional
- (void)uploadProgress:(int)req totalBytesSent:(int64_t)totalBytesSent bytesTotal:(int64_t)bytesTotal;
- (void)uploadFileResponse:(id)Response req:(int)req;
- (void)deleteFileResponse:(id)Response req:(int)req;
- (void)getMeetingFileResponse:(id)Response;

@end
@interface TKEduWhiteBoardNetWorkManager : NSObject<NSURLSessionTaskDelegate>
@property (nonatomic, weak) id<TKEduWhiteBoardNetWorkDelegate> iRequestDelegate;

+ (TKEduWhiteBoardNetWorkManager *)wbRequsetManagerWithDelegate:(id<TKEduWhiteBoardNetWorkDelegate>)delegate;
- (int)uploadWithRequestURL:(NSString*)requestURL meetingID:(int)meetingid fileData:(NSData *)fileData fileName:(NSString *)fileName userName:(NSString *)userName;
- (void)deleteDocumentByFileID:(int)fileID meetingID:(int)meetingid requestURL:(NSString *)requestURL;
- (void)getmeetingfile:(int)meetingid requestURL:(NSString *)requestURL;
@end
