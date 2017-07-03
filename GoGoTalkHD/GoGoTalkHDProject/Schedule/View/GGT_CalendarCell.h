//
//  GGT_CalendarCell.h
//  FSCalendar
//
//  Created by 辰 on 2017/5/2.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};

typedef NS_ENUM(NSUInteger, DateType) {
    DateTypeToday,
    DateTypeOther,
};

@interface GGT_CalendarCell : FSCalendarCell
@property (nonatomic, assign) BOOL isSmall;    // 选中椭圆的状态

@property (weak, nonatomic) CAShapeLayer *selectionLayer;

@property (assign, nonatomic) SelectionType selectionType;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) DateType dateType;

@end
