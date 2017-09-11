//
//  BJRoomViewController.h
//  BJLiveCore
//
//  Created by MingLQ on 2016-12-18.
//  Copyright © 2016 Baijia Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BJLiveCore/BJLiveCore.h>
//#import <ReactiveObjC/ReactiveObjC.h>
#import "BJConsoleViewController.h"

@interface BJRoomViewController : UIViewController <
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate> {
    __weak UIScrollView *_imageScrollView;
}

- (void)enterRoomWithSecret:(NSString *)roomSecret
                   userName:(NSString *)userName;

@end

// protected
@interface BJRoomViewController ()

@property (nonatomic) BJLRoom *room;

// 右侧区域
@property (nonatomic) UIButton *recordingView, *playingView;
@property (nonatomic) BJConsoleViewController *console;


// 左侧区域
@property (nonatomic) UIView *slideshowAndWhiteboardView;
@property (nonatomic) UIButton *xc_cleanButton;
@property (nonatomic) UIButton *xc_drawButton;


@end
