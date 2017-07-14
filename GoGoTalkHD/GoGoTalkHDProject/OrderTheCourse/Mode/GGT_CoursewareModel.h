//
//  GGT_CoursewareModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/7/14.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_CoursewareModel : NSObject

@property (nonatomic, strong) NSString *BDEId;
@property (nonatomic, strong) NSString *BookingId;
@property (nonatomic, strong) NSString *CreateTime;
@property (nonatomic, strong) NSString *CreatorId;
@property (nonatomic, strong) NSString *EooReturnId;
@property (nonatomic, strong) NSString *FilePath;
@property (nonatomic, strong) NSString *FileTittle;
@property (nonatomic, strong) NSString *OrderId;
@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, strong) NSString *ThirdReturnId;
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, strong) NSString *UpdateTime;
@property (nonatomic, strong) NSString *UpdatorId;

@property (nonatomic, assign) BOOL xc_isSelected;

@end

/*
 BDEId = 103;
 BookingId = 53;
 CreateTime = "2017-02-19T21:41:16.03";
 CreatorId = 18;
 EooReturnId = "<null>";
 FilePath = "/UploadFiles/Book/201702192138412324.pdf";
 FileTittle = "FFPhonics1_30";
 OrderId = 30;
 Status = 1;
 ThirdReturnId = 2549;
 Type = 1;
 UpdateTime = "2017-02-19T21:41:16.03";
 UpdatorId = 18;
 */
