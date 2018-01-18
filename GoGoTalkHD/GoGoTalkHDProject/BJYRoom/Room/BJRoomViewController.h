//
//  BJRoomViewController.h
//  BJLiveCore
//
//  Created by MingLQ on 2016-12-18.
//  Copyright © 2016 Baijia Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BJLiveCore/BJLiveCore.h>
#import "BJConsoleViewController.h"
#import "BJPlayingView.h"

@interface BJRoomViewController : UIViewController <
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate> {
    __weak UIScrollView *_imageScrollView;
}

- (void)enterRoomWithSecret:(NSString *)roomSecret
                   userName:(NSString *)userName
            courseCellModel:(GGT_CourseCellModel *)model;

@end

// protected
@interface BJRoomViewController ()

@property (nonatomic) BJLRoom *room;

// 右侧区域 recordingView 采集自己的视频   playingView 播放老师的视频
@property (nonatomic) UIButton *recordingView, *playingView;
@property (nonatomic) BJConsoleViewController *console;
//@property (nonatomic) NSMutableArray<BJPlayingView *> *playingViews;
//@property (nonatomic, strong) BJPlayingView *playingView;


// 左侧区域
@property (nonatomic) UIView *slideshowAndWhiteboardView;
@property (nonatomic) UIButton *xc_cleanButton;
@property (nonatomic) UIButton *xc_drawButton;

@property (nonatomic) UILabel *pageNumLabel;
@property (nonatomic,assign) NSInteger teacherPage;
@property (nonatomic,assign) NSInteger studentPage;


@end
