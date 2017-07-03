//
//  NSString+XCHelper.h
//  XCHelper
//
//  Created by 辰 on 2017/4/21.
//  Copyright © 2017年 Chn. All rights reserved.
//  字符串的常用方法的分类

#import <Foundation/Foundation.h>

@interface NSString (XCHelper)

#pragma mark - Encrypt and decrypt
/**
 *	Convert the string to 32bit md5 string.
 *
 *	@return 32bit md5
 */
- (NSString *)xc_toMD5;

/**
 *	Convert the string to 16bit md5 string.
 *
 *	@return 16bit md5
 */
- (NSString *)xc_to16MD5;

/**
 *	Encrypt the string with sha1 argorithm.
 *
 *	@return The sha1 string.
 */
- (NSString *)xc_sha1;

/**
 *	Encrypt the string with sha256 argorithm.
 *
 *	@return The sha256 string.
 */
- (NSString *)xc_sha256;

/**
 *	Encrypt the string with sha512 argorithm.
 *
 *	@return The sha512 string.
 */
- (NSString *)xc_sha512;

#pragma mark - Data convert to string or string to data.
/** 将字符串转换成data
 *	Convert the current string to data.
 *
 *	@return data object if convert successfully, otherwise nil.
 */
- (NSData *)xc_toData;

/** 将data转换成字符串
 *	Convert a data object to string.
 *
 *	@param data	The data will be converted.
 *
 *	@return string object if convert successfully, otherwise nil.
 */
+ (NSString *)xc_toStringWithData:(NSData *)data;

#pragma mark - Check email, phone, tel, or persion id.
/** 邮箱
 *	Check whether the string is a valid kind of email format.
 *
 *	@return YES if it is a valid format, otherwise false.
 */
- (BOOL)xc_isEmail;

/** 邮箱
 *	Check whether the string is a valid kind of email format.
 *
 *	@param email The string to be checked.
 *
 *	@return YES if it is a valid format, otherwise false.
 */
+ (BOOL)xc_isEmail:(NSString *)email;

/** 手机好
 *	Check whether the string is a valid kind of mobile phone format.
 *  Now only check 11 numbers and begin with 1.
 *
 *	@return YES if passed, otherwise false.
 */
- (BOOL)xc_isMobilePhone;

/** 手机号
 *	Check whether the string is a valid kind of mobile phone format.
 *
 *  @param phone The phone to be checked.
 *
 *	@return YES if passed, otherwise false.
 */
+ (BOOL)xc_isMobilePhone:(NSString *)phone;

/** 电话
 *	Check whether it is a valid kind of tel number format.
 *
 *	@return YES if passed, otherwise false.
 */
- (BOOL)xc_isTelNumber;

/** 电话
 *	Check whether it is a valid kind of tel number format.
 *
 *	@param telNumber	The tel number to be checked.
 *
 *	@return YES if passed, otherwise false.
 */
+ (BOOL)xc_isTelNumber:(NSString *)telNumber;

/** 身份证
 *	Check whether it is a valid kind of Chinese Persion ID
 *
 *	@return YES if it is valid kind of PID, otherwise false.
 */
- (BOOL)xc_isPersonID;

/** 身份证
 *	Check whether it is a valid kind of Chinese Persion ID
 *
 *	@param PID	The Chinese Persion ID to be checked.
 *
 *	@return YES if it is valid kind of PID, otherwise false.
 */
+ (BOOL)xc_isPersonID:(NSString *)PID;

#pragma mark - Trim Character
/** 去除左边空格
 *	Trim the left blank space
 *
 *	@return The new string without left blank space.
 */
- (NSString *)xc_trimLeft;

/** 去除右边空格
 *	Trim the right blank space
 *
 *	@return The new string without right blank space.
 */
- (NSString *)xc_trimRight;

/** 去除左右两边的空格
 *	Trim the left and the right blank space
 *
 *	@return The new string without left and right blank space.
 */
- (NSString *)xc_trim;

/** 去除所有空格
 *	Trim all blank space in the string.
 *
 *	@return The new string without blank space.
 */
- (NSString *)xc_trimAll;

/**
 *	Trim letters.
 *
 *	@return The new string without letters.
 */
- (NSString *)xc_trimLetters;

/** 去除指定的字符
 *	Trim all the specified characters.
 *
 *	@param character	The character to be trimed.
 *
 *	@return The new string without the specified character.
 */
- (NSString *)xc_trimCharacter:(unichar)character;

/** 去除空白
 *	Trim white space.
 *
 *	@return The new string without white space.
 */
- (NSString *)xc_trimWhitespace;

/**
 *	Trim all whitespace and new line.
 *
 *	@return The new string without white space and new line.
 */
- (NSString *)xc_trimWhitespaceAndNewLine;

#pragma mark - Check letters, numbers or letter and numbers
/** 检查是否只包含字母
 *	Check whether it only contains letters.
 *
 *	@return YES if only containing letters, otherwise NO.
 */
- (BOOL)xc_isOnlyLetters;

/** 检查是否只包含数字
 *	Check whether it only contains digit numbers.
 *
 *	@return YES if only containing digit numbers, otherwise NO.
 */
- (BOOL)xc_isOnlyDigits;

/** 检查是否只包含字母和数字
 *	Check whether it only contains letters and digit numbers.
 *
 *	@return YES if only containing letters and digit numbers, otherwise NO.
 */
- (BOOL)xc_isOnlyAlphaNumeric;

#pragma mark - URL
/** 将字符串转换成URL
 *	Try to convert the string to a NSURL object.
 *
 *	@return NSURL object if converts successfully, otherwise nil.
 */
- (NSURL *)xc_toURL;

/** URL编码
 *	Try to do a url encode.
 *
 *	@return Encoded string.
 */
- (NSString *)xc_URLEncode;

#pragma mark - HTML
/** 顾虑HTML标签中的字符串
 *	Filter html tags in the string.
 *
 *	@return A new string without html tags.
 */
- (NSString *)xc_filterHtml;

/** 顾虑HTML中指定的字符串
 *	Fileter html tags in the specified string.
 *
 *	@param html	The specified html string.
 *
 *	@return A new string without html tags.
 */
+ (NSString *)xc_filterHTML:(NSString *)html;

#pragma mark - Get document/tmp/Cache path
/** 获得文件的绝对路径
 *	Get the absolute path of the document.
 *
 *	@return Document path.
 */
+ (NSString *)xc_documentPath;

/** 获得tmp的决定路径
 *	Get the absolute path of tmp
 *
 *	@return Tmp path
 */
+ (NSString *)xc_tmpPath;

/** 获得缓存的绝对路径
 *	Get the absolute path of Cache.
 *
 *	@return Cache absolute path
 */
+ (NSString *)xc_cachePath;

#pragma mark - String operation
/** 字符串中是否包含一个字符串
 *	Check whether current string contains the substring.
 *
 *	@param substring	Substring
 *
 *	@return YES if containing, otherwise NO.
 */
- (BOOL)xc_isContainString:(NSString *)substring;

@end
