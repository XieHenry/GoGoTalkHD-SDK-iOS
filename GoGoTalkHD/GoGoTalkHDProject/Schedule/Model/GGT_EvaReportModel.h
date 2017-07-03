//
//  GGT_EvaReportModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/6/9.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_EvaReportModel : NSObject
@property (nonatomic, strong) NSString *CreateTime;
@property (nonatomic, strong) NSString *IsDemo;
@property (nonatomic, strong) NSString *LvItem;
@property (nonatomic, strong) NSString *LvValue;
@property (nonatomic, strong) NSString *ReportId;
@property (nonatomic, strong) NSString *htmlUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *NameEn;

@end

/*
 CreateTime = "2017/02/28 21:12";
 IsDemo = "体验报告";
 LvItem = 1;
 LvValue = 2;
 ReportId = 13;
 htmlUrl = "http://manage.gogo-talk.com:9332/ipad/index.html?id=13";
 url = "http://teacher.gogo-talk.com/teacher/AssessmentReport.aspx?rpid=UUNrS2piMlRJQ1l4WnRJaFBhL0Rib3BoQ2VEbllzRnd0YkpQOHlzOTlRVT0=";
 */
