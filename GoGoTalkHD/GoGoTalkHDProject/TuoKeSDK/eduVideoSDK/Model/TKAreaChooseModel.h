//
//  TKAreaChooseModel.h
//  EduClassPad
//
//  Created by tom555cat on 2017/11/18.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKAreaChooseModel : NSObject

- (instancetype)initWithParams:(NSDictionary *)params;

@property (nonatomic, strong) NSString *serverAreaName;
@property (nonatomic, strong) NSString *chineseDesc;
@property (nonatomic, strong) NSString *englishDesc;
@property (nonatomic, assign) BOOL choosed;

@end
