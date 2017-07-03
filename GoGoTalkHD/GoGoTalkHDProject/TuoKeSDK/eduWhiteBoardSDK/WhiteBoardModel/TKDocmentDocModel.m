//
//  TKDocmentDocModel.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/31.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKDocmentDocModel.h"

@implementation TKDocmentDocModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@--%@没有定义%@",@(__FILE__),@(__FUNCTION__), key);
    
}
-(void)dynamicpptUpdate{
    //如果是动态ppt
    if ([_dynamicppt intValue]) {
        _swfpath = [_downloadpath copy];
        _action = @"show";
    }else{
        _action = @"";
    }
}
@end
