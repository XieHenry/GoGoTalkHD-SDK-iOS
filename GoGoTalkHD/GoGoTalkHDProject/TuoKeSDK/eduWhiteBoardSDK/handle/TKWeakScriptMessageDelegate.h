//
//  TKWeakScriptMessageDelegate.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/9.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface TKWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> iScriptMessageHandlerDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)aScriptMessageHandlerDelegate;
@end
