//
//  TKAVPlayerViewController.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/16.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKMediaDocModel,TKEduClassRoomProperty;

@interface TKAVPlayerViewController : UIViewController

- (instancetype)initWithMediaDocModel:(TKMediaDocModel *)aMediaDocModel aEduClassRoomProperty:(TKEduClassRoomProperty*)aEduClassRoomProperty;
@end
