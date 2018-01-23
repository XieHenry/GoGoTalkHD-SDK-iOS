//
//  BJRoomViewController+media.m
//  BJLiveCore
//
//  Created by MingLQ on 2016-12-18.
//  Copyright © 2016 Baijia Cloud. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>

#import "BJRoomViewController+media.h"
#import "UIViewController+BJUtil.h"
#import <BJLiveCore/BJLiveCore.h>

@implementation BJRoomViewController (media)

- (void)makeMediaEvents {
    [self makeSpeakingEvents];
    [self makeRecordingEvents];
    [self makePlayingEvents];
    [self makeSlideshowAndWhiteboardEvents];
}

#pragma mark - 打开说话的权限
- (void)makeSpeakingEvents {

    @weakify(self);
    
    if (self.room.loginUser.isTeacher) {
        // 有学生请求发言
        [self bjl_observe:BJLMakeMethod(self.room.speakingRequestVM, receivedSpeakingRequestFromUser:)
                 observer:^BOOL(BJLUser *user) {
                     @strongify(self);
                     // 自动同意
                     [self.room.speakingRequestVM replySpeakingRequestToUserID:user.ID allowed:YES];
//                     [self.console printFormat:@"%@ 请求发言、已同意", user.name];
                     return YES;
                 }];
    }
    else {
        // 发言请求被处理
        [self bjl_observe:BJLMakeMethod(self.room.speakingRequestVM, speakingRequestDidReplyEnabled:isUserCancelled:user:)
                 observer:(BJLMethodObserver)^BOOL(BOOL speakingEnabled, BOOL isUserCancelled, BJLUser *user) {
                     @strongify(self);
//                     [self.console printFormat:@"发言申请已被%@", speakingEnabled ? @"允许" : @"拒绝"];
                     if (speakingEnabled) {
                         [self.room.recordingVM setRecordingAudio:YES
                                                   recordingVideo:NO];
//                         [self.console printFormat:@"麦克风已打开"];
                     }
                     return YES;
                 }];
        // 发言状态被开启、关闭
        [self bjl_observe:BJLMakeMethod(self.room.speakingRequestVM, speakingDidRemoteControl:)
                 observer:(BJLMethodObserver)^BOOL(BOOL enabled) {
//                     [self.console printFormat:@"发言状态被%@", enabled ? @"开启" : @"关闭"];
                     return YES;
                 }];
    }
}

#pragma mark - 打开自己的视频
- (void)makeRecordingEvents {
    
    
//    self.room.recordingView.userInteractionEnabled = NO;
//    [self.recordingView addSubview:self.room.recordingView];
//    [self.room.recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.recordingView);
//    }];
//
//    // 打开摄像头
//    [self.room.recordingVM setRecordingAudio:YES
//                              recordingVideo:YES];
//
//    // 设置高清模式
//    self.room.recordingVM.videoDefinition = BJLVideoDefinition_high;
//    /*------------------------------*/
    
}

- (void)makePlayingEvents {
    
    @weakify(self);
    [self bjl_kvo:BJLMakeProperty(self.room.playingVM, playingUsers)
         observer:^BOOL(id _Nullable old, id _Nullable now) {
             @strongify(self);
             
            
             // 从音视频用户列表 playingUsers 中筛选出老师
             for (BJLOnlineUser *user in self.room.playingVM.playingUsers) {
                 if (user.isTeacher && user.videoOn) { // 身份为老师且开启了视频
                     // 获取对应用户的播放视图
                     UIView *playingView = [self.room.playingVM playingViewForUserWithID:user.ID];
                     // 将播放视图添加到当前 viewController 的对应视图（布局自定）
                     [self.playingView addSubview:playingView];
                     [playingView mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.top.left.bottom.right.equalTo(self.playingView);
                     }];

//                     [self.playingView playWithUser:user videoView:playingView];
                     // 播放视频
                     [self.room.playingVM updatePlayingUserWithID:user.ID videoOn:YES];
                     // 设置用于播放音视频的下行链路为 TCP
                     self.room.mediaVM.downLinkType = BJLLinkType_TCP;
                     
                     
                     // 打开自己的视频
                     [self showRecordingView];
                     [self.room.recordingVM setRecordingAudio:YES
                                               recordingVideo:YES];
                     // 设置用于采集音视频的上行链路为 UDP
                     self.room.mediaVM.upLinkType = BJLLinkType_UDP;
                     
                     
                     break;
                 }
             }
             
             // 当没有老师播放视频的时候 移除老师视频的view
             if (self.room.playingVM.playingUsers.count == 0) {
                 [self.room.playingVM updatePlayingUserWithID:self.room.onlineUsersVM.onlineTeacher.ID videoOn:NO];
                 // 移除该 user 的 playingView (playingView 获取方法参考播放视频部分)
                 UIView *playingView = [self.room.playingVM playingViewForUserWithID:self.room.onlineUsersVM.onlineTeacher.ID];
                 [playingView removeFromSuperview];
                 
                 [self.room.recordingVM setRecordingAudio:NO recordingVideo:NO];
                 [self.room.recordingView removeFromSuperview];
             }
             
             return YES;
         }];
    
}

- (void)makeSlideshowAndWhiteboardEvents {
    @weakify(self);
    
    // 设置白板
    self.room.slideshowViewController.studentCanPreviewForward = YES;
    self.room.slideshowViewController.studentCanRemoteControl = YES;
    
    
    // self.room.slideshowViewController.placeholderImage = [UIImage imageWithColor:[UIColor lightGrayColor]];
    
    [self addChildViewController:self.room.slideshowViewController
                       superview:self.slideshowAndWhiteboardView];
    [self.room.slideshowViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.slideshowAndWhiteboardView);
    }];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.slideshowAndWhiteboardView addSubview:infoButton];
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.slideshowAndWhiteboardView).offset(- 5);
    }];
    
    infoButton.hidden = YES;
    
    
    [[self.xc_drawButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *button) {
         @strongify(self);
         
         if (self.teacherPage != self.studentPage) {
             [self.console printFormat:@"当前课件和老师端课件不在同一页，不可以使用画笔工具哦~"];
             return ;
         }
         
         button.selected = !button.selected;
         // 划线
         BOOL whiteboardEnabled = self.room.slideshowViewController.drawingEnabled;
         self.room.slideshowViewController.drawingEnabled = !whiteboardEnabled;
         
     }];
    
    [[self.xc_cleanButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         
         if (self.teacherPage != self.studentPage) {
             [self.console printFormat:@"当前课件和老师端课件不在同一页，不可以使用画笔工具哦~"];
             return ;
         }
         
         [self.room.slideshowViewController clearDrawing];
         self.xc_drawButton.selected = NO;
         self.room.slideshowViewController.drawingEnabled = NO;
     }];
    
    
#pragma mark 页码
    [self bjl_kvo:BJLMakeProperty(self.room.slideshowViewController, localPageIndex)
         observer:^BOOL(id  _Nullable old, id  _Nullable now) {
             @strongify(self);
             self.studentPage = self.room.slideshowViewController.localPageIndex;
             self.pageNumLabel.text = [NSString stringWithFormat:@"%td/%ld",[now integerValue],self.room.slideshowVM.totalPageCount];
             return YES;
         }];
    
    
    // 以监听课件教室内当前页变化为例：
    [self bjl_kvo:BJLMakeProperty(self.room.slideshowVM, currentSlidePage)
         observer:^BOOL(BJLSlidePage * _Nullable old, BJLSlidePage * _Nullable now) {
             NSLog(@"currentPage：%td", now.documentPageIndex);
             self.teacherPage = now.documentPageIndex;
             
             return YES;
         }];
    
}



- (void)showRecordingView {
    if (self.room.recordingView.superview) {
        return;
    }
    [self.recordingView addSubview:self.room.recordingView];
    [self.room.recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.recordingView);
    }];
}

- (void)hideRecordingView {
    [self.room.recordingView removeFromSuperview];
}

@end
