//
//  GGT_SelectCoursewareViewController.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/10.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ChangeBlock)(NSString *str);
@interface GGT_SelectCoursewareViewController : BaseViewController

@property (nonatomic, copy) ChangeBlock changeBlock;
@end
