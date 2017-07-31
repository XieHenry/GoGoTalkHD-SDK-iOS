//
//  TKDocmentDocModel.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/31.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark fileList

@interface TKDocmentDocModel : NSObject
@property (nonatomic, strong) NSNumber *active;
@property (nonatomic, strong) NSNumber *animation;
@property (nonatomic, strong) NSNumber *companyid;
@property (nonatomic, copy)   NSString *downloadpath;
@property (nonatomic, copy)   NSString *fileid;
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
@property (nonatomic, strong) NSNumber* dynamicppt;//1 是原动态ppt 2.新的
@property (nonatomic, strong) NSNumber* pptslide;//1 当前页面
@property (nonatomic, strong) NSNumber* pptstep;//0 贞
@property (nonatomic, strong) NSString *action;//show
@property (nonatomic, strong) NSNumber *isShow;//是否查看
-(void)dynamicpptUpdate;
@end
