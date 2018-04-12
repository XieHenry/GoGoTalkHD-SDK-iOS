//
//  TKVideoBoardHandle.m
//  EduClassPad
//
//  Created by lyy on 2017/12/19.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoBoardHandle.h"
#import <WebKit/WebKit.h>
#import "TKWeakScriptMessageDelegate.h"

#import "TKEduRoomProperty.h"
#import "TKEduSessionHandle.h"
#import "TKMediaDocModel.h"

#import "TKUtil.h"
#import "TKDocmentDocModel.h"
//#import "TKDocumentListView.h"
#import "TKEduSessionHandle.h"

//广生
static NSString *const sEduWhiteBoardUrl = @"http://192.168.1.182:1314/publish/index.html#/mobileApp_videoWhiteboard";

@interface TKVideoBoardHandle()<WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property(nonatomic,retain)UIView *iContainView;
//@property(nonatomic,retain)UIScrollView *iContainView;

@property (nonatomic, assign)CGRect iFrame;
@property (nonatomic, strong)NSString *videoDrawingBoardType;
@end
@implementation TKVideoBoardHandle

- (UIView*)createVideoWhiteBoardWithFrame:(CGRect)rect
                                 UserName:(NSString*)username
                    videoDrawingBoardType:(NSString *)videoDrawingBoardType
                      aBloadFinishedBlock:(bLoadFinishedBlock)aBloadFinishedBlock{
    
    
    
    _iContainView = [[UIView alloc]initWithFrame:rect];
    _iContainView.backgroundColor = [UIColor clearColor];
    _iContainView.userInteractionEnabled = YES;
    _iFrame = rect;
    _videoDrawingBoardType = videoDrawingBoardType;
    [self initWebView:rect aContainView:_iContainView];
    _iBloadFinishedBlock = aBloadFinishedBlock;
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    
    /*
     @property (nonatomic) BOOL mediaPlaybackRequiresUserAction API_DEPRECATED_WITH_REPLACEMENT("requiresUserActionForMediaPlayback", ios(8.0, 9.0));
     @property (nonatomic) BOOL mediaPlaybackAllowsAirPlay API_DEPRECATED_WITH_REPLACEMENT("allowsAirPlayForMediaPlayback", ios(8.0, 9.0));
     @property (nonatomic) BOOL requiresUserActionForMediaPlayback API_DEPRECATED_WITH_REPLACEMENT("mediaTypesRequiringUserActionForPlayback", ios(9.0, 10.0));
     
     
     */
    if (iOS8Later) {
        config.mediaPlaybackRequiresUserAction = NO;//把手动播放设置NO ios(8.0, 9.0)，这个属性决定了HTML5视频可以自动播放还是需要用户启动播放。iPhone和iPad默认都是YES。
    }
    if (iOS9Later) {
        config.requiresUserActionForMediaPlayback = NO;//ios9 ios 10 A Boolean value indicating whether HTML5 videos require the user to start playing them (YES) or whether the videos can be played automatically (NO).
    }
    
    
    /*! @enum WKAudiovisualMediaTypes
     @abstract The types of audiovisual media which will require a user gesture to begin playing.
     @constant WKAudiovisualMediaTypeNone No audiovisual media will require a user gesture to begin playing.
     @constant WKAudiovisualMediaTypeAudio Audiovisual media containing audio will require a user gesture to begin playing.
     @constant WKAudiovisualMediaTypeVideo Audiovisual media containing video will require a user gesture to begin playing.
     @constant WKAudiovisualMediaTypeAll All audiovisual media will require a user gesture to begin playing.
     */
    if (iOS10_0Later) {
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;//ios10 Determines which media types require a user gesture to begin playing
    }
    
    
    config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。A Boolean value indicating whether HTML5 videos play inline (YES) or use the native full-screen controller (NO).
    if (iOS8Later) {
        config.mediaPlaybackAllowsAirPlay = YES;//允许播放，ios(8.0, 9.0)
        
    }
    if (iOS9Later) {
        config.allowsAirPlayForMediaPlayback = YES;//ios 默认yes ios9
    }
    
    
    
    
#pragma clang diagnostic pop
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    TKWeakScriptMessageDelegate *tScriptMessageDelegate = [[TKWeakScriptMessageDelegate alloc] initWithDelegate:self];
    //打印日志
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sPrintLogMessage_videoWhiteboardPage];
    //白板加载完成
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sOnPageFinished_videoWhiteboardPage];
    //发布消息
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sPubMsg_videoWhiteboardPage];
    //删除消息
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sDelMsg_videoWhiteboardPage];

    config.userContentController = userContentController;
    
    CGRect tFrame = CGRectMake(0, 0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame));
    // 创建WKWebView
    _iWebView = [[WKWebView alloc] initWithFrame:tFrame configuration:config];
    _iWebView.backgroundColor = [UIColor clearColor];
    _iWebView.userInteractionEnabled = YES;
    _iWebView.navigationDelegate = self;
    _iWebView.scrollView.delegate = self;
    _iWebView.scrollView.scrollEnabled = NO;
    _iWebView.scrollView.backgroundColor = [UIColor clearColor];
    
    //禁用长按出现粘贴复制的问题
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    [_iWebView.configuration.userContentController addUserScript:noneSelectScript];
    
    
#ifdef __IPHONE_11_0
    if ([_iWebView.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        [_iWebView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
#endif
    
#ifdef Debug
    
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?ts=%@",sEduWhiteBoardUrl, @([[NSDate date]timeIntervalSince1970])]];
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@?languageType=%@&videoDrawingBoardType=%@", sEduWhiteBoardUrl, [TKUtil getCurrentLanguage],self.videoDrawingBoardType];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]];
//         //根据URL创建请求
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//         [self clearcookie];
//         //WKWebView加载请求
//        [_iWebView loadRequest:request];
    
#endif
    NSURL *path = [BUNDLE URLForResource:@"react_mobile_video_whiteboard_publishdir/index" withExtension:@"html"];
    NSString *urlStr = [NSString stringWithFormat:@"%@#/mobileApp_videoWhiteboard?languageType=%@&videoDrawingBoardType=%@",path.absoluteString,[TKUtil getCurrentLanguage],self.videoDrawingBoardType];

    path = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]];

    [self clearcookie];
    [_iWebView loadRequest:[NSURLRequest requestWithURL:path]];
    
    
    //添加到containView上
    [aContainView addSubview:_iWebView];
    [_iWebView setOpaque:NO];
    
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:sPrintLogMessage_videoWhiteboardPage]) {
        //打印日志
        [self printLogMessageVideoWhiteboardPag:message.name aMessageBody:message.body];
    }else if ([message.name isEqualToString:sOnPageFinished_videoWhiteboardPage]){
        //白板加载完成
        [self onPageFinishedVideoWhiteboardPage];
        
    }else if ([message.name isEqualToString:sPubMsg_videoWhiteboardPage]){
        //发送消息
        [self pubMsgVideoWhiteboardPage:message.body];
    }else if ([message.name isEqualToString:sDelMsg_videoWhiteboardPage]){
        //删除消息
        [self deleteBoardDataVideoWhiteboardPage:message.body];
    }
    
}
- (void)printLogMessageVideoWhiteboardPag:(id)messageName aMessageBody:(id)aMessageBody{
    TKLog(@"----JS 调用了 %@ 方法，传回参数 %@",messageName,aMessageBody);
}
-(void)deleteBoardDataVideoWhiteboardPage:(NSDictionary*)aJs{
    NSString *tDataString = [aJs objectForKey:@"data"];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    //NSData *tJsData = [aJs objectForKey:@"data"];
    NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSString* msgName =[tDic objectForKey:@"signallingName"];
    NSString* msgId = [tDic objectForKey:@"id"];
    NSString* toId =[tDic objectForKey:@"toID"];
    NSString* data = [tDic objectForKey:@"data"];
    
    BOOL isClassBegin = [TKEduSessionHandle shareInstance].isClassBegin;
    BOOL isCanDraw = [TKEduSessionHandle shareInstance].localUser.canDraw;
    BOOL isTeacher = ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher);
    BOOL isSharpsChangeMsg = [msgName isEqualToString:sSharpsChange];
    BOOL isCanSend = (isClassBegin &&((isCanDraw && isSharpsChangeMsg) || isTeacher));
    
    if (isCanSend) {
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:msgName ID:msgId To:toId Data:data completion:nil];
    }
    
}
- (void)pubMsgVideoWhiteboardPage:(NSDictionary*)aJs{
    
    NSString *tDataString = [aJs objectForKey:@"data"];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSString* msgName =[tDic objectForKey:@"signallingName"];
    NSString* msgId = [tDic objectForKey:@"id"];
    NSString* toId =[tDic objectForKey:@"toID"];
    NSString *tData = [tDic objectForKey:@"data"];
    NSString *associatedMsgID = [tDic objectForKey:@"associatedMsgID"];
    NSString *associatedUserID = [tDic objectForKey:@"associatedUserID"];
    NSData *tDataData = [tData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tDataDic = [NSJSONSerialization JSONObjectWithData:tDataData options:NSJSONReadingMutableContainers error:nil];
    TKDocmentDocModel *tDocmentDocModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
    
    if ([msgName isEqualToString:sShowPage]) {
        
        NSDictionary *tDic2 =  [tDataDic objectForKey:@"filedata"];
        NSNumber *tCurrpage = [tDic2 objectForKey:@"currpage"];
        NSNumber *tPPTslide = [tDic2 objectForKey:@"pptslide"];
        NSNumber *tPPTstep = [tDic2 objectForKey:@"pptstep"];
        NSNumber *tPageNum = [tDic2 objectForKey:@"pagenum"];
        tDocmentDocModel.currpage = tCurrpage?tCurrpage:tDocmentDocModel.currpage;
        tDocmentDocModel.pptslide = tPPTslide?tPPTslide:tDocmentDocModel.pptslide;
        tDocmentDocModel.pptstep = tPPTstep?tPPTstep:tDocmentDocModel.pptstep;
        tDocmentDocModel.pagenum = tPageNum?tPageNum:tDocmentDocModel.pagenum;
        
        //当name为sShowPage  要更改toId为 all
        toId = sTellAll;
        
    }else if ([msgName isEqualToString:sWBPageCount]){
        //加页
        NSNumber *tTotalPage = [tDataDic objectForKey:@"totalPage"];
        tDocmentDocModel.pagenum = tTotalPage?tTotalPage:tDocmentDocModel.pagenum;
        tDocmentDocModel.currpage = tTotalPage?tTotalPage:tDocmentDocModel.pagenum;
    }
    
    
    //NSArray *tArray =  [[TKEduSessionHandle shareInstance] docmentArray];
    //TKLog(@"jin sendBoardData %@",tArray);
    [[TKEduSessionHandle shareInstance] addOrReplaceDocmentArray:tDocmentDocModel];
    
    BOOL save = YES;
    if ([tDic objectForKey:@"do_not_save"]) {
        save = [[tDic objectForKey:@"do_not_save"]boolValue];
    }
    BOOL isClassBegin = [TKEduSessionHandle shareInstance].isClassBegin;
    BOOL isCanDraw = [TKEduSessionHandle shareInstance].localUser.canDraw;
    BOOL isTeacher = ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher);
    BOOL isResultStudent = [msgName isEqualToString:sSubmitAnswers];
    
    //BOOL isResultStudent = YES;
    BOOL isH5Document = ([tDocmentDocModel.fileprop integerValue] == 3);
    
    //BOOL isCanSend = (isClassBegin &&((isCanDraw && isSharpsChangeMsg) || isTeacher || (isH5Document &&isCanDraw )));
    
    BOOL isCanSend = (isClassBegin &&(isCanDraw  || isTeacher || isResultStudent));
    
    if (isCanSend) {
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:msgName ID:msgId To:toId Data:tData Save:save AssociatedMsgID:sVideoWhiteboard AssociatedUserID:associatedUserID expires:0  completion:nil];
    }else if (isClassBegin && ![msgId isEqualToString:sDocumentFilePage_ShowPage]){
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:msgName ID:msgId To:toId Data:tData Save:save AssociatedMsgID:sVideoWhiteboard AssociatedUserID:associatedUserID expires:0 completion:nil];
    }
}
- (void)onPageFinishedVideoWhiteboardPage{
    TKLog(@"视频白板加载完成%@",self.videoDrawingBoardType);
    //给白板发送webview宽高
    NSMutableDictionary *tDictSize = [NSMutableDictionary dictionary];
    [tDictSize setObject:@"transmitWindowSize" forKey:@"type"];
    
    NSDictionary *tParamDicSize = @{
                                @"height":@(CGRectGetHeight(_iWebView.frame)),//DocumentFilePage_ShowPage
                                @"width":@(CGRectGetWidth(_iWebView.frame))
                                };
    
    [tDictSize setObject:tParamDicSize forKey:@"windowSize"];
    
    NSData *jsonDataSize = [NSJSONSerialization dataWithJSONObject:tDictSize options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tjsonStringSize = [[NSString alloc]initWithData:jsonDataSize encoding:NSUTF8StringEncoding];
    
    NSString *jsReceivePhoneByTriggerEventSize = [NSString stringWithFormat:@"MOBILETKSDK.receiveInterface.dispatchEvent(%@)",tjsonStringSize];
    
    [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEventSize completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        TKLog(@"MOBILETKSDK.receiveInterface.dispatchEvent");
    }];
    //2 ios
#ifdef Debug
    NSDictionary *tJsServiceUrl = @{
                                    @"address":[NSString stringWithFormat:@"%@://%@",@"http",[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp],
                                    @"port":@(80)
                                    };
#else
    NSDictionary *tJsServiceUrl = @{
                                    @"address":[NSString stringWithFormat:@"%@://%@",sHttp,[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp],
                                    @"port":@([[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort integerValue])
                                    };
#endif
    
    /*
     //手机端初始化参数
     mClientType:null , //0:flash,1:PC,2:IOS,3:andriod,4:tel,5:h323    6:html5 7:sip
     serviceUrl:null , //服务器地址
     addPagePermission:false , //加页权限
     deviceType:null , //0-手机 , 1-ipad
     role:null , //角色
     };
     */
    int role = [TKEduSessionHandle shareInstance].iRoomProperties.iUserType;
    
    //myself
    NSMutableDictionary *myselfDict = [NSMutableDictionary dictionaryWithDictionary:[TKEduSessionHandle shareInstance].localUser.properties];
    
    [myselfDict setObject:[TKEduSessionHandle shareInstance].localUser.peerID forKey:@"id"];
    

    NSDictionary *dictM = @{
                            @"mClientType":@(2),
                            @"serviceUrl":tJsServiceUrl,
                            @"deviceType":@(1),
                            @"role":@([TKEduSessionHandle shareInstance].isPlayback?-1:role),
                            @"raisehand":@(false),
                            @"giftnumber":@(0),
                            @"candraw":@(false),
                            @"disablevideo":@(false),
                            @"disableaudio":@(false),
                            @"playback":@([TKEduSessionHandle shareInstance].isPlayback?true:false),
                            @"isSendLogMessage":@([TKEduSessionHandle shareInstance].isSendLogMessage?true:false),//2017-11-10 判断是否开启log日志
                            @"myself":myselfDict,
                            @"debugLog":@(true)
                            };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strM = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *js = [NSString stringWithFormat:@"MOBILETKSDK.receiveInterface.setInitPageParameterFormPhone(%@)",strM];
    
    //evaluate 评估
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        // response 返回值
        NSLog(@"----MOBILETKSDK.receiveInterface.setInitPageParameterFormPhone");
        
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && [TKEduSessionHandle shareInstance].videoRatio) {
            
            NSString *str = [TKUtil dictionaryToJSONString:@{@"videoRatio":[TKEduSessionHandle shareInstance].videoRatio}];
            [[TKEduSessionHandle shareInstance]sessionHandlePubMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        
        }
        if (_iBloadFinishedBlock) {
           
//            if ([TKEduSessionHandle shareInstance].iIsJoined == NO) {
                _iBloadFinishedBlock();
//            }
        }
    }];
    
    //发送room-msglist
    NSMutableDictionary *tDict = [NSMutableDictionary dictionary];
    [tDict setObject:@"room-msglist" forKey:@"type"];
    [tDict setObject:[TKEduSessionHandle shareInstance].msgList forKey:@"message"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tjsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    TKLog(@"---------白板-------%@",tjsonString);
    NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"MOBILETKSDK.receiveInterface.dispatchEvent(%@)",tjsonString];
    
    [self.iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        TKLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
    }];
}
-(void)setPageParameterForPhoneForRole:(UserType)aRole{
    
    
    NSString *js = [NSString stringWithFormat:@"MOBILETKSDK.receiveInterface.changeInitPageParameterFormPhone({role:%@})",@(aRole)];
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];
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

#pragma mark life cycle
-(void)dealloc{
    
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sPrintLogMessage_videoWhiteboardPage];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sPubMsg_videoWhiteboardPage];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sDelMsg_videoWhiteboardPage];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sOnPageFinished_videoWhiteboardPage];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_iWebView stopLoading];
    
}
-(void)clearcookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage   sharedHTTPCookieStorage];
    for (cookie in [storage cookies])  {
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    //webview暂停加载
    // [_iWebView stopLoading];
}
- (void)deleteVideoWhiteBoard{
    [_iWebView removeFromSuperview];
    _iWebView  = nil;
    
}

@end
