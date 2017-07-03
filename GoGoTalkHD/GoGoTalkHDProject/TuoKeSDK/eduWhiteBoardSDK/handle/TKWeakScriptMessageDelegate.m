//
//  TKWeakScriptMessageDelegate.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/9.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKWeakScriptMessageDelegate.h"

@implementation TKWeakScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)aScriptMessageHandlerDelegate
{
    self = [super init];
    if (self) {
        _iScriptMessageHandlerDelegate = aScriptMessageHandlerDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [_iScriptMessageHandlerDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
