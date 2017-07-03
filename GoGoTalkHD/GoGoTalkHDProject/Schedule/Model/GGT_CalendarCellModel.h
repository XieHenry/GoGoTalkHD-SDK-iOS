//
//  GGT_CalendarCellModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/23.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_CalendarCellModel : NSObject

@property (nonatomic, strong) NSArray *ListTimes;
@property (nonatomic, strong) NSString *YearMonthDay;

@end

/*
 {
     data = {
         ListDates = (
                {
                     ListTimes =  (
                             {
                                 HourMinute = "<span style='color:gray'>16:00</span>";
                             }
                     );
                     YearMonthDay = "2017-05-18";
                }
         );
     };
     msg = "\U6210\U529f";
     result = 1;
 }
 */
