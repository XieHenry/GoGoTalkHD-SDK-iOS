//
//  TKClassTimeView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/8.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKClassTimeView : UIView


-(void)setClassTime:(NSTimeInterval)aLocalTime;
-(void)startClassBeginTimer;
-(void)invalidateClassBeginTime;
@end
