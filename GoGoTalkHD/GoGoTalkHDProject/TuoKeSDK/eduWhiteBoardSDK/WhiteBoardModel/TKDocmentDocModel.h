//
//  TKDocmentDocModel.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/31.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark fileList




/*
 
 active = 0;
 animation = 0;
 companyid = 10032;
 downloadpath = "/upload/20170524_145317_wneapnfr.txt";
 fileid = 2717;
 filename = "\U76f4\U64ad\U6587\U6863.txt";
 filepath = "";
 fileserverid = 0;
 filetype = txt;
 isconvert = 1;
 newfilename = "20170524_145317_wneapnfr.txt";
 pagenum = 2;
 pdfpath = "/upload/20170524_145317_wneapnfr.pdf";
 size = 1008;
 status = 0;
 swfpath = "/upload/20170524_145317_wneapnfr.jpg";
 type = 0;
 uploadtime = "2017-05-24 14:53:20";
 uploaduserid = 100620;
 uploadusername = admin;
 
 
 
 */
@interface TKDocmentDocModel : NSObject
@property (nonatomic, strong) NSNumber *active;
@property (nonatomic, strong) NSNumber *animation;
@property (nonatomic, strong) NSNumber *companyid;
@property (nonatomic, copy)   NSString *downloadpath;
@property (nonatomic, strong) NSNumber *fileid;
@property (nonatomic, copy)   NSString *filename;
@property (nonatomic, copy)   NSString *filepath;
@property (nonatomic, strong) NSNumber *fileserverid;
@property (nonatomic, copy)   NSString *filetype;
@property (nonatomic, strong) NSNumber* isconvert;//NSInteger
@property (nonatomic, copy)   NSString *newfilename;
@property (nonatomic, strong) NSNumber *pagenum;
@property (nonatomic, copy)   NSString *pdfpath;
@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy)   NSString *swfpath;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *uploadtime;
@property (nonatomic, strong) NSNumber *uploaduserid;
@property (nonatomic, copy)   NSString *uploadusername;
@property (nonatomic, strong) NSNumber* currpage;//NSInteger
@property (nonatomic, strong) NSNumber* dynamicppt;//1 是动态ppt
@property (nonatomic, strong) NSNumber* pptslide;//1 当前页面
@property (nonatomic, strong) NSNumber* pptstep;//0 贞
@property (nonatomic, strong) NSString *action;//show
@property (nonatomic, strong) NSNumber *isShow;//是否查看
-(void)dynamicpptUpdate;
@end
