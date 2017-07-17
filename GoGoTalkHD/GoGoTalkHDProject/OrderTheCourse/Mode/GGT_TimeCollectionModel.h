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
@property (nonatomic, copy) NSString *week;
//状态
@property (nonatomic, copy) NSString *isHaveClass;


@end
