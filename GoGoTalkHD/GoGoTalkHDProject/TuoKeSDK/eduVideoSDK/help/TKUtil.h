//
//  TKUtil.h
//  emmnew
//
//  Created by mac on 14-3-27.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "TKRCGlobalConfig.h"
#define EMMIOSVER ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue])

#ifndef GETDICVALUE
#define GETDICVALUE(Dic, key) \
([[Dic objectForKey:key] isKindOfClass:[NSNull class]] ? nil : [Dic objectForKey:key])
#endif


//typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
//    UIRectCornerTopLeft     = 1 << 0,//左上角
//    UIRectCornerTopRight    = 1 << 1,//右上角
//    UIRectCornerBottomLeft  = 1 << 2,//左下角
//    UIRectCornerBottomRight = 1 << 3,//右下角
//    UIRectCornerAllCorners  = ~0UL   //全部
//};





@interface TKUtil : NSObject
+ (NSString*)fullPath:(NSString*)shortPath;

+ (NSString*)GetDicString:(NSDictionary*)dic Key:(NSString*)key;
+ (int)GetDicInt:(NSDictionary*)dic Key:(NSString*)key;

//#define GETLEFT(v)      (v.frame.origin.x)
//#define GETRIGHT(v)     (v.frame.origin.x + v.frame.size.width)
//#define GETTOP(v)       (v.frame.origin.y)
//#define GETBOTTOM(v)    (v.frame.origin.y + v.frame.size.height)
+ (void)setLeft:(UIView*)v To:(CGFloat)x;
+ (void)setTop:(UIView*)v To:(CGFloat)y;
+ (void)setRight:(UIView*)v To:(CGFloat)right;
+ (void)setBottom:(UIView*)v To:(CGFloat)bottom;
+ (void)setWidth:(UIView*)v To:(CGFloat)width;
+ (void)setHeight:(UIView*)v To:(CGFloat)height;
+ (void)setCenter:(UIView*)v ToFrame:(CGRect)frame;
+(UIView *)setCornerForView:(UIView * )aView;
#pragma mark 获取是否是媒体文件
+(BOOL)getIsMedia:(NSString*)filetype;
+(BOOL)isVideo:(NSString *)filetype;
+(NSString *)docmentOrMediaImage:(NSString*)aType;
#pragma mark 获取字符串长度
+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize;

#pragma mark 加密
+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
+(NSMutableDictionary *)decodeUrl:(NSString *)aDecodeUrl;
+(NSMutableDictionary *)decodeParam:(NSString *)aParamString;
+(NSString *) md5HexDigest:(NSString *)aString;
#pragma mark 获取当前时间
+(NSString *)currentTime;
#pragma mark 只能是数字
+ (BOOL)validateNumber:(NSString*)number;
#pragma mark globle
+ (void)showMessage:(NSString *)message ;
#pragma mark 几位数
+(NSInteger)numberBit:(NSInteger)aNumber;
#pragma mark 判断当前语言
+(BOOL)isEnglishLanguage;
@end
