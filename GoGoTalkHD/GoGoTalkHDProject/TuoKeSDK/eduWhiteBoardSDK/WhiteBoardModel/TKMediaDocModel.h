//
//  MediaDocModel.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/20.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKMediaDocModel : NSObject
@property (nonatomic, strong) NSNumber* fileid;//long
@property (nonatomic, strong) NSNumber* page;//NSInteger
@property (nonatomic, strong) NSNumber* ismedia;//BOOl
@property (nonatomic, strong) NSNumber* isconvert;//NSInteger
@property (nonatomic, strong) NSNumber* pagenum;//NSInteger
@property (nonatomic, copy) NSString *filetype;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *swfpath;
@property (nonatomic, strong) NSNumber *currentTime;
@property (nonatomic, strong) NSNumber* isPlay;//BOOl

@end
