//
//  eduWhiteBoardView.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/9.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduBoardHandle.h"
#import <WebKit/WebKit.h>
#import "TKWeakScriptMessageDelegate.h"

#import "TKEduRoomProperty.h"
#import "TKEduSessionHandle.h"
#import "TKMediaDocModel.h"

#import "TKUtil.h"
#import "TKDocmentDocModel.h"
#import "TKDocumentListView.h"
//guangsheng
static NSString const* sEduWhiteBoardUrl = @"http://192.168.1.182:8020/phone_demo/index.html";
//weijin
//static NSString const* sEduWhiteBoardUrl = @"http://192.168.1.12:8020/phone_demo/index.html";
//static NSString const* sEduWhiteBoardUrl = @"http://192.168.1.12:8020/phone_demo/index.html";

@interface TKEduBoardHandle ()<WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property(nonatomic,retain)UIView *iContainView;
@property(nonatomic,copy)bLoadFinishedBlock iBloadFinishedBlock;
@property (nonatomic,assign)CGRect iNoFullFrame;
@property (nonatomic,assign)CGRect iFullFrame;

@end

@implementation TKEduBoardHandle

- (UIView*)createWhiteBoardWithFrame:(CGRect)rect
                            UserName:(NSString*)username
                 aBloadFinishedBlock:(bLoadFinishedBlock)aBloadFinishedBlock
                           aRootView:(UIView *)aRootView;
{
    _iContainView = [[UIView alloc]initWithFrame:rect];
    _iContainView.backgroundColor = [UIColor clearColor];
    _iContainView.userInteractionEnabled = YES;
    _iNoFullFrame = rect;
    _iFullFrame = CGRectMake(0, 0, ScreenW, ScreenH);
    [self initWebView:rect aContainView:_iContainView];
    _iBloadFinishedBlock = aBloadFinishedBlock;
    _iRootView = aRootView;
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
    //本地白板交互的方法
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sSendBoardData];
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sDeleteBoardData];
    //白板加载完成的回调，需要在这里进行进入教室以及进行白板初始化
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sOnPageFinished];
    //打印白板内日志
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sPrintLogMessage];
    //全屏按钮交互
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sfullScreenToLc];
    //播放ppt内视频交互
    [userContentController addScriptMessageHandler:tScriptMessageDelegate name:sOnJsPlay];
    config.userContentController = userContentController;
   
    CGRect tFrame = CGRectMake(0, 0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame));
    // 创建WKWebView
    _iWebView = [[WKWebView alloc] initWithFrame:tFrame configuration:config];
    _iWebView.backgroundColor = RGBCOLOR(28, 28, 28);
    _iWebView.userInteractionEnabled = YES;
    _iWebView.navigationDelegate = self;
    _iWebView.scrollView.delegate = self;
    _iWebView.scrollView.scrollEnabled = NO;
    _iWebView.scrollView.backgroundColor = RGBCOLOR(28, 28, 28);
    
//#if defined(__IPHONE_11_0)
//    [_iWebView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//#endif
    
#ifdef __IPHONE_11_0
    if ([_iWebView.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            [_iWebView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        } else {
            // Fallback on earlier versions
        }
    }
#endif

#ifdef Debug
//   
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?ts=%@",sEduWhiteBoardUrl, @([[NSDate date]timeIntervalSince1970])]];
//         //根据URL创建请求
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//         //WKWebView加载请求
//        [_iWebView loadRequest:request];
    
#endif
    //phone_demo/index.hml?ts=1111
    NSURL *path = [BUNDLE URLForResource:@"phone_demo/index" withExtension:@"html"];
    [self clearcookie];
    [_iWebView loadRequest:[NSURLRequest requestWithURL:path]];
    
    

  
    //添加到containView上
    [aContainView addSubview:_iWebView];
    
}

#pragma mark js注入
-(void)onPageFinished{
    TKLog(@"tlm-----onpageFinished 进入房间后的时间: %@", [TKUtil currentTimeToSeconds]);
    //2 ios
#ifdef Debug
    //NSString *tUrl = [NSString stringWithFormat:@"%@://%@:%@%@",@"http",_iEduClassRoomProperty.sWebIp,@"80",_iCurrentMediaDocModel.swfpath];
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
    mClientType:null , //0:flash,1:PC,2:IOS,3:andriod,4:tel,5:h323	6:html5 7:sip
    serviceUrl:null , //服务器地址
    addPagePermission:false , //加页权限
    deviceType:null , //0-手机 , 1-ipad
    role:null , //角色
    };
    */
    bool tAddPagePermission = false;
     int role = [TKEduSessionHandle shareInstance].iRoomProperties.iUserType;
    NSDictionary *dictM = @{
                            @"mClientType":@(2),
                            @"serviceUrl":tJsServiceUrl,
                            @"addPagePermission":@(tAddPagePermission),
                            @"deviceType":@(1),
                            @"role":@(role),
                            @"raisehand":@(false),
                            @"giftnumber":@(0),
                            @"candraw":@(false),
                            @"disablevideo":@(false),
                            @"disableaudio":@(false),
                            @"playback":@([TKEduSessionHandle shareInstance].isPlayback?true:false)
                            };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strM = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *js = [NSString stringWithFormat:@"GLOBAL.phone.setInitPageParameterFormPhone(%@)",strM];

    //evaluate 评估
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        // response 返回值
        NSLog(@"----GLOBAL.phone.setInitPageParameterFormPhone");
        if (_iBloadFinishedBlock) {
            _iBloadFinishedBlock();
        }
        
    }];
   
    
    
    
}


//todo 1）切换动态ppt时会来一次初始化，不应该来。2）白板内部操作会来
-(void)sendBoardData:(NSDictionary*)aJs{

    NSString *tDataString = [aJs objectForKey:@"data"];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSString* msgName =[tDic objectForKey:@"signallingName"];
    NSString* msgId = [tDic objectForKey:@"id"];
    NSString* toId =[tDic objectForKey:@"toID"];
    NSString *tData = [tDic objectForKey:@"data"];
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
    }else if ([msgName isEqualToString:sWBPageCount]){
            //加页
          NSNumber *tTotalPage = [tDataDic objectForKey:@"totalPage"];
          tDocmentDocModel.pagenum = tTotalPage?tTotalPage:tDocmentDocModel.pagenum;
          tDocmentDocModel.currpage = tTotalPage?tTotalPage:tDocmentDocModel.pagenum;
    }
   
    [[TKEduSessionHandle shareInstance] addOrReplaceDocmentArray:tDocmentDocModel];
  
    BOOL save = YES;
    if ([tDic objectForKey:@"do_not_save"]) {
        save = [[tDic objectForKey:@"do_not_save"]boolValue];
    }
    BOOL isClassBegin = [TKEduSessionHandle shareInstance].isClassBegin;
    BOOL isCanDraw = [TKEduSessionHandle shareInstance].localUser.canDraw;
    BOOL isTeacher = ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher);
    BOOL isSharpsChangeMsg = [msgName isEqualToString:sSharpsChange];
    BOOL isH5Document = ([tDocmentDocModel.fileprop integerValue] == 3);
    
    //BOOL isCanSend = (isClassBegin &&((isCanDraw && isSharpsChangeMsg) || isTeacher || (isH5Document &&isCanDraw )));
    
    BOOL isCanSend = (isClassBegin &&(isCanDraw  || isTeacher));
    
    if (isCanSend) {
        
        [[TKEduSessionHandle shareInstance]  sessionHandlePubMsg:msgName ID:msgId To:toId Data:tData Save:save completion:nil];
    }
    
    
}
-(void)deleteBoardData:(NSDictionary*)aJs{
    NSData *tJsData = [aJs objectForKey:@"data"];
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
-(void)printLogMessage:(id)messageName aMessageBody:(id)aMessageBody{
     TKLog(@"----JS 调用了 %@ 方法，传回参数 %@",messageName,aMessageBody);
}
-(void)fullScreenToLc:(id)messageName aMessageBody:(id)aMessageBody{
    
    if ([aMessageBody isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tDic = (NSDictionary *)aMessageBody;
        BOOL tIsFull = [[tDic objectForKey:@"data"]boolValue];
        [self refreshUIForFull:tIsFull];
    }
     TKLog(@"---- 调用了 %@ 方法，传回参数 %@",messageName,aMessageBody);
    
    
}
-(void)refreshWebViewUI{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(_iContainView.frame), CGRectGetHeight(_iContainView.frame));
    _iWebView.frame = frame;
    _iNoFullFrame = _iContainView.frame;
}

-(void)refreshUIForFull:(BOOL)isFull{
    
    [UIView animateWithDuration:0.1 animations:^{
        _iContainView.frame = isFull?_iFullFrame:_iNoFullFrame;
        _iWebView.frame = isFull?_iFullFrame :CGRectMake(0, 0, CGRectGetWidth(_iNoFullFrame), CGRectGetHeight(_iNoFullFrame));
        [[NSNotificationCenter defaultCenter]postNotificationName:sfullScreenToLc object:@(isFull)];
        TKDocmentDocModel *tDocmentDocModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
        
        //todo 判断是否是动态ppt
        if ([tDocmentDocModel.dynamicppt integerValue]) {
            
            NSDictionary *tParamDic = @{
                                        @"height":@(CGRectGetHeight(_iWebView.frame)),//DocumentFilePage_ShowPage
                                        @"width":@(CGRectGetWidth(_iWebView.frame))
                                        };
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tParamDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.resizeNewpptHandler(%@)",jsonString];
            [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
                
                NSLog(@"----GLOBAL.phone.receivePhoneByTriggerEvent");
            }];
        }

    }];
    
    
}

//public void onJsPlay(final String videoData) ；
-(void)onJsPlay:(NSDictionary *)videoData{
    NSString *aVideoData = [videoData objectForKey:@"data"];
    [[TKEduSessionHandle shareInstance]configurePlayerRoute:NO isCancle:NO];
    if (!aVideoData) {
        return;
    }
    if ([TKEduSessionHandle shareInstance].isPlayMedia) {
        [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:^(NSError * error) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",aVideoData];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
            NSString *url = [tDic objectForKey:@"url"];
            NSString *fileid = [tDic objectForKey:@"fileid"];
            bool isvideo = [[tDic objectForKey:@"isvideo"]boolValue];
            NSString * toID = [TKEduSessionHandle shareInstance].isClassBegin?sTellAll:[TKEduSessionHandle shareInstance].localUser.peerID;
            [[TKEduSessionHandle shareInstance]sessionHandlePublishMedia:url hasVideo:isvideo fileid:fileid filename:@"" toID:toID block:nil];
        }];
        
    }else{
        NSString *tDataString = [NSString stringWithFormat:@"%@",aVideoData];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *tDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        NSString *url = [tDic objectForKey:@"url"];
        NSString *fileid = [tDic objectForKey:@"fileid"];
        bool isvideo = [[tDic objectForKey:@"isvideo"]boolValue];
        NSString * toID = [TKEduSessionHandle shareInstance].isClassBegin?sTellAll:[TKEduSessionHandle shareInstance].localUser.peerID;
        [[TKEduSessionHandle shareInstance]sessionHandlePublishMedia:url hasVideo:isvideo fileid:fileid filename:@"" toID:toID block:nil];
    }
    
    

}

#pragma mark 设置白板权限

-(void)closeNewPptVideo:(id) aData{
    
    NSString *jsReceivePhoneByTriggerEvent = [NSString stringWithFormat:@"GLOBAL.phone.closeNewPptVideo()"];
    [_iWebView evaluateJavaScript:jsReceivePhoneByTriggerEvent completionHandler:^(id _Nullable id, NSError * _Nullable error) {
        NSLog(@"----GLOBAL.phone.closeNewPptVideo");
    }];
    
}

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
        NSLog(@"----GLOBAL.phone.pageTurningPermission %d", tAdd);
    }];

}
-(void)setPageParameterForPhoneForRole:(UserType)aRole{
    
   // NSString *js = [NSString stringWithFormat:@"GLOBAL.phone.changeInitPageParameterFormPhone(\"role\",%@)",@(aRole)];
    
     NSString *js = [NSString stringWithFormat:@"GLOBAL.phone.changeInitPageParameterFormPhone({role:%@})",@(aRole)];
    //NSString *js2 =@" myFunction('Bill Gates','CEO')";
    //evaluate 评估
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        
    }];
}

-(void)setAddPagePermission:(bool)aPagePermission{
    
     NSString *js = [NSString stringWithFormat:@"GLOBAL.phone.changeInitPageParameterFormPhone({addPagePermission:%@})",@(aPagePermission)];
    //NSString *js2 =@" myFunction('Bill Gates','CEO')";
    //evaluate 评估
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        
    }];
}
-(void)resizeHandler{
    

    NSString *js = [NSString stringWithFormat:@"GLOBAL.phone.resizeHandler()"];
    //NSString *js2 =@" myFunction('Bill Gates','CEO')";
    //evaluate 评估
    [_iWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        
    }];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
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

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:sSendBoardData]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        //        NSLog(@"-------%@", message.body);
        //        NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
        [self sendBoardData:message.body];
        
    }else if ([message.name isEqualToString:sDeleteBoardData]){
        [self deleteBoardData:message.body];
        
        
    }else if ([message.name isEqualToString:sOnPageFinished]){
        [self onPageFinished];
    }else if ([message.name isEqualToString:sPrintLogMessage]){
        
        [self printLogMessage:message.name aMessageBody:message.body];
    }else if ([message.name isEqualToString:sfullScreenToLc]){
        [self fullScreenToLc:message.name aMessageBody:message.body];
    }else if ([message.name isEqualToString:sOnJsPlay]){
        TKLog(@"----JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
        [self onJsPlay:message.body];
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

#pragma mark life cycle
-(void)dealloc{
    
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sSendBoardData];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sDeleteBoardData];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sOnPageFinished];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sPrintLogMessage];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sfullScreenToLc];
    [[_iWebView configuration].userContentController removeScriptMessageHandlerForName:sOnJsPlay];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_iWebView stopLoading];
    
}

-(void)clearAllWhiteBoardData{
    _iBloadFinishedBlock = nil;
}

-(void)cleanup{
    
    _iContainView = nil;
    _iWebView.scrollView.delegate = nil;
    _iWebView = nil;
}
@end
