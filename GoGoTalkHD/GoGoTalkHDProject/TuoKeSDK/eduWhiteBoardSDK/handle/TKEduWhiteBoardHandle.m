//
//  eduWhiteBoardView.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/9.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduWhiteBoardHandle.h"
#import <WebKit/WebKit.h>
#import "TKWeakScriptMessageDelegate.h"
#import "TKMacro.h"
#import "TKEduClassRoomProperty.h"
#import "TKEduClassRoomSessionHandle.h"
#import "TKMediaDocModel.h"
#import "TKVideoPlayerHandle.h"
#import "TKUtil.h"
#import "TKDocmentDocModel.h"

static NSString *const sEduWhiteBoardUrl = @"http://192.168.1.182:8020/phone_demo/index.html";


@interface TKEduWhiteBoardHandle ()<WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property(nonatomic,retain)UIView *iContainView;
@property(nonatomic,retain)WKWebView *iWebView;
@property(nonatomic,weak)UIView *iRootView;

@property(nonatomic,copy)bLoadFinishedBlock iBloadFinishedBlock;

@property (nonatomic,strong)TKVideoPlayerHandle *iVideoPlayerHandle;
@property (nonatomic,strong)TKDocmentDocModel *iDefaultDocment;
@property (nonatomic,strong) NSMutableArray *iDocmentMutableArray;
@property (nonatomic,strong) NSMutableArray *iMediaMutableArray;
@property (nonatomic,assign)BOOL iIsPlay;
@property (nonatomic,assign)CGRect iNoFullFrame;
@property (nonatomic,assign)CGRect iFullFrame;

@end

@implementation TKEduWhiteBoardHandle


- (UIView*)createWhiteBoard:(id<TKEduWhiteBoardDelegate>)delegate Frame:(CGRect)rect  UserName:(NSString*)username aClassRoomProperty:(TKEduClassRoomProperty*)aClassRoomProperty aClassRoomSessionHandle:(TKEduClassRoomSessionHandle*)aClassRoomSessionHandle aBloadFinishedBlock:(bLoadFinishedBlock)aBloadFinishedBlock aRootView:(UIView *)aRootView;
{
    
   
    _iContainView = [[UIView alloc]initWithFrame:rect];
    _iContainView.backgroundColor = [UIColor clearColor];
    _iContainView.userInteractionEnabled = YES;
    _iNoFullFrame = rect;
    _iFullFrame = CGRectMake(0, 0, ScreenW, ScreenH);
    [self initWebView:rect aContainView:_iContainView];
    _iEduWhiteBoardDelegate = delegate;
    _iBloadFinishedBlock = aBloadFinishedBlock;
    _iEduClassRoomProperty = aClassRoomProperty;
    _iEduClassRoomSessionHandle = aClassRoomSessionHandle;
    
    _iDocmentMutableArray =[[NSMutableArray alloc] init];
    _iMediaMutableArray = [[NSMutableArray alloc]init];
    
    _iCurrentMediaDocModel = [[TKMediaDocModel alloc]init];
    _iVideoPlayerHandle = [[TKVideoPlayerHandle alloc]init];
    _iRootView = aRootView;
    _iIsPlay = NO;
    _isClassBegin = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    return _iContainView;
}


-(void)initWebView:(CGRect)aFrame aContainView:(UIView*)aContainView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];

    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    TKWeakScriptMessageDelegate *tScriptMessageDelegate = [[TKWeakScriptMessageDelegate alloc] initWithDelegate:self];
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sSendBoardData];
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sDeleteBoardData];
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sOnPageFinished];
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sPrintLogMessage];
     [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sfullScreenToLc];
    config.userContentController = userContentController;
    CGRect tFrame = CGRectMake(0, 0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame));
    
    // 创建WKWebView
    _iWebView = [[WKWebView alloc] initWithFrame:tFrame configuration:config];
    _iWebView.backgroundColor = [UIColor clearColor];
    _iWebView.userInteractionEnabled = YES;
    _iWebView.navigationDelegate = self;
    _iWebView.scrollView.delegate = self;
    
//    // 设置访问的URL
   
    
#
#ifdef Debug
//    NSURL *url = [NSURL URLWithString:sEduWhiteBoardUrl];
//    // 根据URL创建请求
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    // WKWebView加载请求
//    [_iWebView loadRequest:request];

#else
//        NSURL *path = [BUNDLE URLForResource:@"phone_demo/index" withExtension:@"html"];
//        [_iWebView loadRequest:[NSURLRequest requestWithURL:path]];
#endif
    NSURL *path = [BUNDLE URLForResource:@"phone_demo/index" withExtension:@"html"];
    [_iWebView loadRequest:[NSURLRequest requestWithURL:path]];
    //添加到containView上
    [aContainView addSubview:_iWebView];
    
}
-(void)refreshUI:(BOOL)isFull{
    _iContainView.frame = isFull?_iFullFrame:_iNoFullFrame;
    _iWebView.frame = isFull?_iFullFrame :CGRectMake(0, 0, CGRectGetWidth(_iNoFullFrame), CGRectGetHeight(_iNoFullFrame));
    
}
#pragma mark othter customer event
-(void)pageFont{
 

}

-(void)pageNext{
    
}

-(void)clearAllWhiteBoardData{

    [_iDocmentMutableArray removeAllObjects];
    [_iMediaMutableArray removeAllObjects];
    [_iVideoPlayerHandle releaseAVPlayer];
  
}

#pragma mark 数据
- (NSArray *)docmentArray{
    
    return [_iDocmentMutableArray copy];
    
}

- (void)addOrReplaceDocmentArray:(TKDocmentDocModel *)aDocmentDocModel {
    TKLog(@"---------add:%@",aDocmentDocModel.filename);
    NSArray *tArray  = [_iDocmentMutableArray copy];
    
    BOOL tIsHave                              = NO;
    NSInteger tIndex = 0;
    for (TKDocmentDocModel *tDocmentDocModel in tArray) {
        
        if ([tDocmentDocModel.fileid integerValue] == [aDocmentDocModel.fileid integerValue]) {
            tIsHave = YES;
            
            break;
        }
        tIndex++;
       
        
    }
    if (!tIsHave) {
        [_iDocmentMutableArray addObject:aDocmentDocModel];
        
    }else{
        [_iDocmentMutableArray replaceObjectAtIndex:tIndex withObject:aDocmentDocModel];
    }
    
    
    
    
    
}
- (void)delDocmentArray:(TKDocmentDocModel *)aDocmentDocModel {
    
    TKLog(@"---------del:%@",aDocmentDocModel.filename);
    
    //删除所有
    NSArray *tArrayAll = [_iDocmentMutableArray copy];
    NSInteger tIndex = 0;
    for (TKDocmentDocModel *tDocmentDocModel in tArrayAll) {
        
        if ([tDocmentDocModel.fileid integerValue] == [aDocmentDocModel.fileid integerValue]) {
            [_iDocmentMutableArray removeObjectAtIndex:tIndex];
            
            break;
        }
        tIndex++;
        
    }
    
}


- (NSArray *)mediaArray{
    
    
    return [_iMediaMutableArray copy];
    
}
- (void)addOrReplaceMediaArray:(TKMediaDocModel *)aMediaDocModel {
    TKLog(@"---------add:%@",aMediaDocModel.filename);
    NSArray *tArray  = [_iMediaMutableArray copy];
    
    BOOL tIsHave                              = NO;
    NSInteger tIndex = 0;
    for (TKMediaDocModel *tMediaDocModel in tArray) {
        
        if ([tMediaDocModel.fileid integerValue] == [aMediaDocModel.fileid integerValue]) {
            tIsHave = YES;
            
            break;
        }
        tIndex++;
        
        
    }
    if (!tIsHave) {
        [_iMediaMutableArray addObject:aMediaDocModel];
        
    }else{
        [_iMediaMutableArray replaceObjectAtIndex:tIndex withObject:aMediaDocModel];
    }
    
    
    
    
    
}
- (void)delMediaArray:(TKMediaDocModel *)aMediaDocModel {
    
    TKLog(@"---------del:%@",aMediaDocModel.filename);
    
    //删除所有
    NSArray *tArrayAll = [_iMediaMutableArray copy];
    NSInteger tIndex = 0;
    for (TKMediaDocModel *tMediaDocModel in tArrayAll) {
        
        if ([tMediaDocModel.fileid integerValue] == [aMediaDocModel.fileid integerValue]) {
            [_iMediaMutableArray removeObjectAtIndex:tIndex];
            break;
        }
        tIndex++;
        
    }
    
}
#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:sSendBoardData]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
//        NSLog(@"-------%@", message.body);
//        NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
        if (_isClassBegin) { [self sendBoardData:message.body];}
       
        
    }else if ([message.name isEqualToString:sDeleteBoardData]){
        
         if (_isClassBegin) { [self deleteBoardData:message.body];}
        
    }else if ([message.name isEqualToString:sOnPageFinished]){
        [self onPageFinished];
    }else if ([message.name isEqualToString:sPrintLogMessage]){
       
        [self printLogMessage:message.name aMessageBody:message.body];
    }else if ([message.name isEqualToString:sfullScreenToLc]){
        [self fullScreenToLc:message.name aMessageBody:message.body];
    }
    
}


#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    TKLog(@"页面开始加载时调用");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    TKLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    TKLog(@"页面加载完成之后调用");
}


//提交发生错误时调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    TKLog(@"%@", error.debugDescription);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
   
    TKLog(@"页面加载失败时调用");
}


//  接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    TKLog(@"接收到服务器跳转请求之后调用");
    
}

//  在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    TKLog(@"在收到响应后，决定是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//  在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
    TKLog(@"在发送请求之前，决定是否跳转");
}


#pragma mark uploadDocument
/**
 *  上传文件(图片)
 *
 *  @param fileData     文件数据
 *  @param filename     文件名
 */
- (int)uploadDocumentWithFileData:(NSData *)fileData fileName:(NSString *)filename{
    return 1;
}

#pragma mark RoomWhiteBoard Delegate
- (void)onFileList:(NSArray*)fileList{
    //{"fileid":0,"page":1,"ismedia":false,"filedata":{"fileid":0,"currpage":1,"pagenum":1,"filetype":"","filename":"lc","swfpath":""}}
    NSDictionary *tDic = @{
                           @"active" :@(1),
                           @"downloadpath":@"",
                           @"dynamicppt" :@(0),
                           @"fileid" :@(0),
                           @"filename":@"白板",
                           @"filepath":@"",
                           @"fileserverid":@(0),
                           @"filetype" :@"",
                           @"isconvert" :@(1),
                           @"newfilename":@"白板",
                           @"pagenum" :@(1),
                           @"pdfpath":@"",
                           @"swfpath" :@"",
                           @"currpage":@(1)

                           };
    
    NSMutableArray *tMutableFileList = [NSMutableArray arrayWithArray:fileList];
    [tMutableFileList insertObject:tDic atIndex:0];
    
    if (_iEduWhiteBoardDelegate && [_iEduWhiteBoardDelegate respondsToSelector:@selector(eduWhiteBoardOnFileList:)]) {
        [_iEduWhiteBoardDelegate eduWhiteBoardOnFileList:tMutableFileList];
        
    }
    int i = 0;
   
    for (NSDictionary *tFileDic in tMutableFileList) {
        //如果是媒体文档，则跳过
        if ([TKUtil getIsMedia:[tFileDic objectForKey:@"filetype"]]) {
            TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc]init];
            [tMediaDocModel setValuesForKeysWithDictionary:tFileDic];
            tMediaDocModel.isPlay = @(NO);
            [self addOrReplaceMediaArray:tMediaDocModel];
          
        }else{
            
            TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
            [tDocmentDocModel setValuesForKeysWithDictionary:tFileDic];
            [tDocmentDocModel dynamicpptUpdate];
            tDocmentDocModel.isShow = @(YES);
            [self addOrReplaceDocmentArray:tDocmentDocModel];
            
            
            if (i == 1) {
                _iDefaultDocment = tDocmentDocModel;
                [self docmentDefault:_iDefaultDocment];
            }
            
        }
        i++;
    }
    
}
-(BOOL)dealWithWhiteBoard:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data{
    
    NSString *tDataString = [NSString stringWithFormat:@"%@",data];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    BOOL tIsWhiteBoardDealWith = false;
    if ([msgName isEqualToString:sClassBegin]) {
       
        [self setPagePermission:!add];
        tIsWhiteBoardDealWith = false;
        return tIsWhiteBoardDealWith;
        
    }
    
    if([msgName isEqualToString:sWBPageCount]|| [msgName isEqualToString:sShowPage] ||[msgName isEqualToString:sSharpsChange] ){
        NSString *tDataString =(NSString *)data;
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        //showPage 子信令
        if ([msgID isEqualToString:sVideo_MediaFilePage_ShowPage] || [msgID isEqualToString:sAudio_MediaFilePage_ShowPage]) {
            NSString *tTypeString = [msgID isEqualToString:sVideo_MediaFilePage_ShowPage]?@"video":@"audio";
            TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc]init];
            NSDictionary *tDic = [tDataDic objectForKey:@"filedata"];
            [tMediaDocModel setValuesForKeysWithDictionary:tDic];
            
            //add ? [self addDocmentDic:tMediaDocModel] :[self delDocmentDic:tMediaDocModel];
            add ? [self addOrReplaceMediaArray:tMediaDocModel] :[self delMediaArray:tMediaDocModel];
            add ? (_iCurrentMediaDocModel = tMediaDocModel) : (_iPreMediaDocModel=tMediaDocModel);
#ifdef Debug
            //NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",@"http",_iEduClassRoomProperty.sWebIp,@"80",_iCurrentMediaDocModel.swfpath];
            NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",@"http",_iEduClassRoomProperty.sWebIp,@"80",_iCurrentMediaDocModel.swfpath];
#else
            NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",sHttp,_iEduClassRoomProperty.sWebIp,_iEduClassRoomProperty.sWebPort,_iCurrentMediaDocModel.swfpath];
#endif
            [_iVideoPlayerHandle playerInitialize:tUrl aMediaDocModel:_iCurrentMediaDocModel withView:_iRootView aType:tTypeString add:add aRoomUser:_iEduClassRoomSessionHandle.localUser];
            
            
            TKLog(@"-----%@", [NSString stringWithFormat:@"msgID:%@,add:%@",msgID,@(add)]);
            
        }
       
        NSDictionary *tParamDic = @{
                                    @"id":msgID,//DocumentFilePage_ShowPage
                                    @"ts":@(ts),
                                    @"data":tDic?tDic:[NSNull null],
                                    @"name":msgName//ShowPage
                                    };
        
        NSString *tMessageString = add ?@"publish-message-received" :@"delete-message-received";
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tParamDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.receivePhoneByTriggerEvent('%@',%@)",tMessageString,jsonString];
        [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
           
            NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
        }];
        tIsWhiteBoardDealWith = true;
        return tIsWhiteBoardDealWith;
    }
    if ([msgName isEqualToString:sMediaProgress]){
        NSDictionary *tDataDic = (NSDictionary *)data;
        MediaProgressAction action = (MediaProgressAction)[[tDataDic objectForKey:@"action"] longValue];
        NSString * mediaType = [tDataDic objectForKey:@"mediaType"];
        NSNumber * tCurrentTime = [tDataDic objectForKey:@"currentTime"];
        
        
        
        switch (action) {
                //告诉别人进度
            case MediaProgressAction_OtherNeedProgress:
            {
                NSString *tSendParticipantId = [tDataDic objectForKey:@"sendParticipantId"];
                NSNumber* fileid = _iCurrentMediaDocModel.fileid;
                
                NSDictionary *tMediaDate = @{
                                             @"action":@(MediaProgressAction_ChangeProgress),
                                             @"mediaType":mediaType,
                                             @"fileid":fileid,
                                             @"currentTime":_iCurrentMediaDocModel.currentTime
                                             };
                TKLog(@"-----%@", [NSString stringWithFormat:@"msgName:%@,add:%@,action:MediaProgressAction_OtherNeedProgress",msgName,@(add)]);
                !add?:[_iEduClassRoomSessionHandle sessionHandlePubMsg:sMediaProgress ID:sMediaProgress_video_1 To:tSendParticipantId Data:tMediaDate Save:false completion:nil];
                
                break;
            }
                //暂停或者play
            case MediaProgressAction_PlayOrPause:
            {
                TKLog(@"-----%@", [NSString stringWithFormat:@"msgName:%@,add:%@,action:MediaProgressAction_PlayOrPause,play:%@",msgName,@(add),[tDataDic objectForKey:@"play"]]);
                BOOL tPlay = [[tDataDic objectForKey:@"play"]boolValue] ;
                [_iVideoPlayerHandle playeOrPause:tPlay];
                break;
            }
                //进度变化
            case MediaProgressAction_ChangeProgress:
            {
                [_iVideoPlayerHandle setCurrentTime:[tCurrentTime doubleValue]];
                _iCurrentMediaDocModel.currentTime = tCurrentTime;
                break;
            }
                
        }
    }
    return tIsWhiteBoardDealWith;
    
}

//YES ，代表白板处理 不传给会议；  NO ，代表白板不处理，传给会议
- (BOOL)onRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data{
    BOOL tIsWhiteBoardDealWith = false;
    tIsWhiteBoardDealWith = [self dealWithWhiteBoard:add ID:msgID Name:msgName TS:ts Data:data];
    
    if (_iEduWhiteBoardDelegate && [_iEduWhiteBoardDelegate respondsToSelector:@selector(eduWhiteBoardOnRemoteMsg:ID:Name:TS:Data:)]) {
        
        tIsWhiteBoardDealWith = [_iEduWhiteBoardDelegate eduWhiteBoardOnRemoteMsg:add ID:msgID Name:msgName TS:ts Data:data];
        
    }
    
    return tIsWhiteBoardDealWith;
}

- (void)onRemoteMsgList:(NSArray*)list{
   
    NSMutableDictionary *tParamDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    BOOL tIsHavePageList = NO;
     BOOL tIsCanPage      = NO;
    for (NSDictionary *tParamDictemp in list) {
        NSString *tID = [tParamDictemp objectForKey:@"id"];
        [tParamDic setObject:tParamDictemp forKey:tID];
        //[self dealWithWhiteBoard:YES ID:[tParamDictemp objectForKey:@"id"] Name:[tParamDictemp objectForKey:@"name"] TS:[[tParamDictemp objectForKey:@"ts"] longValue] Data:[tParamDictemp objectForKey:@"data"]];
        if ([[tParamDictemp objectForKey:@"name"] isEqualToString:sShowPage]) {
            tIsHavePageList = YES;
        }
        if ([[tParamDictemp objectForKey:@"name"] isEqualToString:sClassBegin]) {
            tIsCanPage = YES;
        }
        
    }
    NSData *tJsonData = [NSJSONSerialization dataWithJSONObject:tParamDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tJsonString = [[NSString alloc]initWithData:tJsonData encoding:NSUTF8StringEncoding];
    NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.receivePhoneByTriggerEvent('message-list-received', %@)",tJsonString];
    [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
    }];
    if (!tIsHavePageList) {
//        [self docmentDefault:_iDefaultDocment];
    }
    if (!tIsCanPage) {
        [self setPagePermission:YES];
    }
    
    if (_iEduWhiteBoardDelegate && [_iEduWhiteBoardDelegate respondsToSelector:@selector(eduWhiteBoardOnRemoteMsgList:)]) {
        [_iEduWhiteBoardDelegate eduWhiteBoardOnRemoteMsgList:list];
        
    }
    
    
}
-(void)docmentDefault:(TKDocmentDocModel*)aDefaultDocment{
    NSDictionary *tDataDic = @{
                               @"filedata":@{
                                       @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                                       @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                                       @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                                       @"isconvert": aDefaultDocment.isconvert?aDefaultDocment.isconvert:@"",
                                       @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                                       @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@"",
                                       @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@""
                                       
                                       },
                               @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                               @"ismedia":@(0)
                               
                               };
    if ([aDefaultDocment.dynamicppt intValue] && aDefaultDocment.dynamicppt) {
        bool bool_true = true;
        bool bool_false = false;
        tDataDic = @{
                     @"filedata":@{
                             @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                             @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                             @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                             @"isconvert": aDefaultDocment.isconvert?aDefaultDocment.isconvert:@"",
                             @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                             @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@"",
                             @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@"",
                             @"pptslide": aDefaultDocment.pptslide?aDefaultDocment.pptslide:@(1),
                             @"pptstep":aDefaultDocment.pptstep?aDefaultDocment.pptstep:@(0)
                             },
                     @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@"",
                     @"ismedia":@(bool_false),
                     @"action":aDefaultDocment.action,
                     @"page":@(0),
                     @"aynamicPPT":aDefaultDocment.dynamicppt?@(bool_true):@(bool_false)
                     };
    }
    NSDictionary *tParamDicDefault = @{
                                       @"id":sDocumentFilePage_ShowPage,//DocumentFilePage_ShowPage
                                       @"ts":@(0),
                                       @"data":tDataDic?tDataDic:[NSNull null],
                                       @"name":sShowPage
                                       };
    
    NSString *tMessageString = @"publish-message-received";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tParamDicDefault options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *jsReceivePhoneByTriggerEventForDefault = [NSString stringWithFormat:@"GLOBAL.phone.receivePhoneByTriggerEvent('%@',%@)",tMessageString,jsonString];
    [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEventForDefault completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
    }];
}
#pragma mark js注入
-(void)onPageFinished{
    //2 ios
    NSDictionary *tJsServiceUrl = @{
                                    @"address":[NSString stringWithFormat:@"%@://%@",sHttp,_iEduClassRoomProperty.sWebIp],
                                    @"port":@([_iEduClassRoomProperty.sWebPort integerValue])
                                    };
   /*
  
    
    //手机端初始化参数
    mClientType:null , //0:flash,1:PC,2:IOS,3:andriod,4:tel,5:h323	6:html5 7:sip
    serviceUrl:null , //服务器地址
    addPagePermission:false , //加页权限
    deviceType:null , //0-手机 , 1-ipad
    role:null , //角色
    };

    */
    bool tIsPagePermission = (_iEduClassRoomProperty.iUserType == UserType_Teacher);
    
    NSDictionary *dictM = @{
                            @"mClientType":@(2),
                            @"serviceUrl":tJsServiceUrl,
                            @"addPagePermission":@(tIsPagePermission),
                            @"deviceType":@(1),
                            @"role":@(_iEduClassRoomProperty.iUserType)
                            };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strM = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *js = [NSString stringWithFormat:@"GLOBAL.phone.setInitPageParameterFormPhone(%@)",strM];
    //NSString *js2 =@" myFunction('Bill Gates','CEO')";
    //evaluate 评估
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        // response 返回值
        NSLog(@"----GLOBAL.phone.setInitPageParameterFormPhone");
        if (_iBloadFinishedBlock) {
            _iBloadFinishedBlock();
        }
        
    }];
    //changeInitPageParameterFormPhone:function(key,value)
    //"role",@(1)
     [self setPagePermission:YES];
    
    
}
-(void)changeInitPageParameterFormPhoneRole:(UserType)aRole{
    
    NSString *js = [NSString stringWithFormat:@"GLOBAL.phone.changeInitPageParameterFormPhone(\"role\",%@)",@(aRole)];
    //NSString *js2 =@" myFunction('Bill Gates','CEO')";
    //evaluate 评估
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
       
        
    }];
}

-(void)sendBoardData:(NSDictionary*)aJs{
    
    NSString *tDataString = [aJs objectForKey:@"data"];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSString* msgName =[tDic objectForKey:@"signallingName"];
    NSString* msgId = [tDic objectForKey:@"id"];
    NSString* toId =[tDic objectForKey:@"toID"];
    NSString *tData = [tDic objectForKey:@"data"];
    
    BOOL save = YES;
    if ([tDic objectForKey:@"do_not_save"]) {
        save = [[tDic objectForKey:@"do_not_save"]boolValue];
    }
    if ([msgName isEqualToString:sWBPageCount]) {
        return;
    }

    [_iEduClassRoomSessionHandle  sessionHandlePubMsg:msgName ID:msgId To:toId Data:tData Save:save completion:nil];
    
}
-(void)deleteBoardData:(NSDictionary*)aJs{
    NSData *tJsData = [aJs objectForKey:@"data"];
    NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSString* msgName =[tDic objectForKey:@"signallingName"];
    NSString* msgId = [tDic objectForKey:@"id"];
    NSString* toId =[tDic objectForKey:@"toID"];
    NSString* data = [tDic objectForKey:@"data"];
 
     [_iEduClassRoomSessionHandle  sessionHandleDelMsg:msgName ID:msgId To:toId Data:data completion:nil];

}
-(void)printLogMessage:(id)messageName aMessageBody:(id)aMessageBody{
     TKLog(@"----JS 调用了 %@ 方法，传回参数 %@",messageName,aMessageBody);
}
-(void)fullScreenToLc:(id)messageName aMessageBody:(id)aMessageBody{
    
    if ([aMessageBody isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tDic = (NSDictionary *)aMessageBody;
        BOOL tIsFull = [[tDic objectForKey:@"data"]boolValue];
        [self refreshUI:tIsFull];
       
        
    }
     TKLog(@"---- 调用了 %@ 方法，传回参数 %@",messageName,aMessageBody);
}
#pragma mark 设置白板权限

-(void)setDrawable:(BOOL) candraw{
   
    NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.drawPermission(%@)",@(candraw)];
    [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        NSLog(@"----GLOBAL.phone.drawPermission");
    }];
    
}

-(void)setPagePermission:(BOOL)canPage{
    
     bool tAdd = canPage?true:false;
    NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.pageTurningPermission(%@)",@(tAdd)];
    [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        NSLog(@"----GLOBAL.phone.pageTurningPermission");
    }];

}

#pragma mark 进入前后台
-(void)enterForeground:(NSNotification *)aNotification{
  
    if (_iCurrentMediaDocModel &&  _iIsPlay) {
        [_iVideoPlayerHandle playeOrPause:YES];
    }
}
-(void)enterBackground:(NSNotification *)aNotification{
    _iIsPlay =  _iVideoPlayerHandle.iIsPlayState;
    if (_iCurrentMediaDocModel&&_iIsPlay) {
        [_iVideoPlayerHandle playeOrPause:NO];
    }
}


#pragma mark scroll
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
#pragma mark life cycle
-(void)dealloc{
    
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sSendBoardData];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sDeleteBoardData];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sOnPageFinished];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_iWebView stopLoading];
    
}
@end
