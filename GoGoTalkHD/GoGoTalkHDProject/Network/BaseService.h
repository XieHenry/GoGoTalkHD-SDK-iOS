//
//  BaseService.h
//  GoGoTalkHD
//
//  Created by 辰 on 16/7/29.
//  Copyright © 2016年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GGT_LoginViewController.h"

typedef void(^AFNSuccessResponse)(id responseObject);
typedef void(^AFNFailureResponse)(NSError *error);
typedef void(^AFNBOOLResponse)(BOOL result);

typedef NS_ENUM(NSInteger, HttpRequestType) {
    XCHttpRequestGet,
    XCHttpRequestPost,
    XCHttpRequestDelete,
    XCHttpRequestPut,
};


@interface BaseService : NSObject

/** 网络状态 */
@property (nonatomic, assign) AFNetworkReachabilityStatus netWorkStaus;

// 请求管理者
@property (strong, nonatomic) AFHTTPSessionManager *manager;

+ (instancetype)share;

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
                  token:(BOOL)isLoadToken
         viewController:(UIViewController *)viewController
                success:(AFNSuccessResponse)success
                failure:(AFNFailureResponse)failure;

/// POST 带MBP
- (void)sendPostRequestWithPath:(NSString *)url
                     parameters:(NSDictionary *)parameters
                          token:(BOOL)isLoadToken
                 viewController:(UIViewController *)viewController
                        success:(AFNSuccessResponse)success
                        failure:(AFNFailureResponse)failure;

/// GET 带MBP
- (void)sendGetRequestWithPath:(NSString *)url
                         token:(BOOL)isLoadToken
                viewController:(UIViewController *)viewController
                       success:(AFNSuccessResponse)success
                       failure:(AFNFailureResponse)failure;


/// POST 判断是否带MBP
- (void)sendPostRequestWithPath:(NSString *)url
                     parameters:(NSDictionary *)parameters
                          token:(BOOL)isLoadToken
                 viewController:(UIViewController *)viewController
                 showMBProgress:(BOOL)isShow
                        success:(AFNSuccessResponse)success
                        failure:(AFNFailureResponse)failure;

/// GET 判断是否带MBP
- (void)sendGetRequestWithPath:(NSString *)url
                         token:(BOOL)isLoadToken
                viewController:(UIViewController *)viewController
                showMBProgress:(BOOL)isShow
                       success:(AFNSuccessResponse)success
                       failure:(AFNFailureResponse)failure;



@end
