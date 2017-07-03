//
//  GGT_ShareAndFeedBackViewController.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/19.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "BaseViewController.h"
#import <UMSocialCore/UMSocialCore.h>

typedef void(^TestReportButtonClickBlock)(UIButton *button);

@interface GGT_ShareAndFeedBackViewController : BaseViewController
@property (nonatomic, copy) TestReportButtonClickBlock testbuttonClickBlock;

//是否是分享弹窗
@property BOOL isShareController;
@end




typedef void(^ShareButtonClickBlock)(UIButton *button);
//分享的view
@interface ShareView : UIView
@property (nonatomic, copy) ShareButtonClickBlock buttonClickBlock;

@end



//反馈的view
@interface FeedBackView : UIView
@end












