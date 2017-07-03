//
//  GGT_MineClassPlaceholderView.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/6/2.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlaceholderType) {
    ClassOverAndNoTestReportStatus, //课程已结束且体验报告未生成---测评报告
    ClassNotStartStatus,            //课程未开始---测评报告
    ClassNormal,                    //有测评报告
    MyClassStatus,                  //我的课时---没数据的状态
    
};


@interface GGT_MineClassPlaceholderView : UIView

- (instancetype)initWithFrame:(CGRect)frame method:(NSInteger)method alertStr:(NSString *)str;

@end
