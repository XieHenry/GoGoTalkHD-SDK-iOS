//
//  GGT_TimeCollectionModel.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/7/14.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_TimeCollectionModel : NSObject

//开始时间
@property (nonatomic, copy) NSString *date;
//状态
@property (nonatomic, assign) NSInteger isHaveClass;
//LessonId
@property (nonatomic, assign) NSInteger TLId;
//时间
@property (nonatomic, copy) NSString *time;


//{
//    date = "2017-07-17 11:30";
//    isHaveClass = 1;
//    TLId = 5988228;
//    time = "11:30";
//},

@end
