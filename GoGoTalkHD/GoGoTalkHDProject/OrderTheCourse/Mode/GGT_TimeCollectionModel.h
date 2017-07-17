//
//  GGT_TimeCollectionModel.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/14.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_TimeCollectionModel : NSObject
//时间
@property (nonatomic, copy) NSString *date;
//LessonId
@property (nonatomic, assign) NSInteger week;
//状态
@property (nonatomic, assign) NSInteger isHaveClass;


@end
