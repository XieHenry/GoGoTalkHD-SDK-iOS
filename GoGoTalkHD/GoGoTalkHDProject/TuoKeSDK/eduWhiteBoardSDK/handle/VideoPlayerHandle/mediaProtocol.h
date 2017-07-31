//
//  mediaProtocol.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/24.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKMediaDocModel.h"

@protocol mediaProtocol <NSObject>

-(void)mediaPlayStatus:(BOOL)aSucess;
-(void)mediaBackAction;

- (void)replay:(TKMediaDocModel*)model;

@end
