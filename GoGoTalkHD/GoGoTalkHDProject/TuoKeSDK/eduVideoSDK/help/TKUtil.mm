//
//  TKUtil.m
//  emmnew
//
//  Created by mac on 14-3-27.
//
//

#import "TKUtil.h"
#import "TKMacro.h"
#import "TKGTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#define kChosenDigestLength		CC_SHA1_DIGEST_LENGTH

#define DESKEY @"Gd0^9f@KoAQOXFPZQ^H&fURo"


@implementation TKUtil

/*
 
 typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
	UIRectCornerTopLeft     = 1 << 0,//左上角
	UIRectCornerTopRight    = 1 << 1,//右上角
	UIRectCornerBottomLeft  = 1 << 2,//左下角
	UIRectCornerBottomRight = 1 << 3,//右下角
	UIRectCornerAllCorners  = ~0UL   //全部
 };
 
 //创建圆角边框(UIRectCornerBottomLeft | UIRectCornerBottomRight)
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.button.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
 
 CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
 maskLayer.frame = self.button.bounds;
 maskLayer.path = maskPath.CGPath;
 self.button.layer.mask = maskLayer;
 
 
 */
+(UIView *)setCornerForView:(UIView * )aView {
    //创建圆角边框(UIRectCornerBottomLeft | UIRectCornerBottomRight)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:UIRectCornerAllCorners   cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.shadowColor = RGBACOLOR(0, 0, 0, 1.0).CGColor;
    maskLayer.shadowOffset = CGSizeMake(-2, -3);
    maskLayer.shadowOpacity = 1;
    maskLayer.shadowRadius = 5;
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    aView.layer.mask = maskLayer;
    return aView;
    
}


+ (NSString*)fullPath:(NSString*)shortPath
{
    static NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:shortPath];
}


+ (NSString*)GetDicString:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return @"";
    }
    
    NSString *str = [dic objectForKey:key];
    
    if (!str || ![str isKindOfClass:[NSString class]])
    {
        str = @"";
    }
    
    return str;
}

+ (int)GetDicInt:(NSDictionary*)dic Key:(NSString*)key
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]])
    {
        return 0;
    }
    
    if (![dic objectForKey:key])
    {
        return 0;
    }
    
    if ([[dic objectForKey:key] isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    
    return [[dic objectForKey:key] intValue];
}

+ (void)setLeft:(UIView*)v To:(CGFloat)x {
    CGRect frame = v.frame;
    frame.origin.x = x;
    v.frame = frame;
}

+ (void)setTop:(UIView*)v To:(CGFloat)y {
    CGRect frame = v.frame;
    frame.origin.y = y;
    v.frame = frame;
}

+ (void)setRight:(UIView*)v To:(CGFloat)right {
    CGRect frame = v.frame;
    frame.origin.x = right - frame.size.width;
    v.frame = frame;
}

+ (void)setBottom:(UIView*)v To:(CGFloat)bottom {
    CGRect frame = v.frame;
    frame.origin.y = bottom - frame.size.height;
    v.frame = frame;
}

+ (void)setWidth:(UIView*)v To:(CGFloat)width {
    CGRect frame = v.frame;
    frame.size.width = width;
    v.frame = frame;
}

+ (void)setHeight:(UIView*)v To:(CGFloat)height {
    CGRect frame = v.frame;
    frame.size.height = height;
    v.frame = frame;
}
+ (void)setCenter:(UIView*)v ToFrame:(CGRect )frame{
    v.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
    
}
#pragma mark 加解密

//http://blog.csdn.net/justinjing0612/article/details/8482689
//先base64解码，在3des解码
+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    //
   
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        //plainText = [GTMBase64 decodeBase64String:plainText];
        NSData *tData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        NSData *EncryptData = [TKGTMBase64 TK_webSafeDecodeData:tData];
        plainTextBufferSize = [EncryptData length];
       
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
       
    }
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
   //http://stackoverflow.com/questions/13415672/assigning-to-uint8-t-aka-unsigned-char-from-incompatible-type-void
    bufferPtr =  static_cast<uint8_t *> (malloc( bufferPtrSize * sizeof(uint8_t)));
   // bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    
    NSString *result;
    //解密
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [TKGTMBase64 TK_stringByEncodingData:myData];
    }
    
    return result;
}
//weiyi://start?param=ENCRYPT&timestamp=xxxxx(unix 时间戳)
//
+(NSMutableDictionary *)decodeUrl:(NSString *)aDecodeUrl{
    NSMutableDictionary *tResultDic = [[NSMutableDictionary  alloc]initWithCapacity:10];

    NSArray *tUrlArray = [aDecodeUrl componentsSeparatedByString:@"?"];
    //[tUrlArray objectAtIndex:1] ->param=ENCRYPT&timestamp=xxxxx(unix 时间戳)
    NSArray *tParamArray = [[tUrlArray objectAtIndex:1] componentsSeparatedByString:@"&"];
    if ([tParamArray count]>1) {
        for (NSString *aTempString in tParamArray) {
            NSArray *tParamOrTimestapArray = [aTempString componentsSeparatedByString:@"="];
            [tResultDic  setObject:[tParamOrTimestapArray objectAtIndex:1]  forKey:[tParamOrTimestapArray objectAtIndex:0]];
        }
    }
   
    
    return tResultDic;
}
// @"ip=192.168|port=80|meetingid=132444942|nickname=xue|headurl=http://192.168.0.5/t.jpg|thirdID=100|password=1234
+(NSMutableDictionary *)decodeParam:(NSString *)aParamString{
    
    NSMutableDictionary *tResultDic = [[NSMutableDictionary  alloc]initWithCapacity:10];
    //NSString * aURLString = @"ip=192.168|port=80|meetingid=132444942|nickname=xue|headurl=http://192.168.0.5/t.jpg|thirdID=100|password=1234";
    NSArray *tUrlArray = [aParamString componentsSeparatedByString:@"&"];
    if ([tUrlArray count]>1) {
        /*
         stringByAddingPercentEscapesUsingEncoding(只对 `#%^{}[]|\"<> 加空格共14个字符编码，不包括”&?”等符号),
         URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
         URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
         URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
         URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
         URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
         URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
         
         */
        //stringByRemovingPercentEncoding
        for (NSString *aTempString in tUrlArray) {
            NSArray *tParagramArray = [aTempString componentsSeparatedByString:@"="];
            [tResultDic  setObject:[tParagramArray objectAtIndex:1]  forKey:[tParagramArray objectAtIndex:0]];
        }
    }
    
    return tResultDic;
}

+ (CGFloat) widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize{
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Light" size:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width+5;
    
}


+(BOOL)getIsMedia:(NSString*)filetype{
    BOOL tIsMedia = false;
    if ([filetype isEqualToString:@"mp3"]
        || [filetype isEqualToString:@"mp4"]
        || [filetype isEqualToString:@"webm"]
        || [filetype isEqualToString:@"ogg"]
        || [filetype isEqualToString:@"wav"]) {
        tIsMedia = true;
    }
    return tIsMedia;

}
+(NSString *)docmentOrMediaImage:(NSString*)aType{
    NSString *tString = @"icon_user";
    if ([aType isEqualToString:@""]) {
        tString = @"icon_empty";
        
    }else if ([aType isEqualToString:@"excel"]){
        tString = @"icon_excel";
    }else if ([aType isEqualToString:@"image"]){
        tString = @"icon_images";
    }
    else if ([aType isEqualToString:@"ppt"]){
        tString = @"icon_ppt";
    }
    else if ([aType isEqualToString:@"docx"]){
        tString = @"icon_word";
    }
    else if ([aType isEqualToString:@"txt"]){
        tString = @"icon_text_pad";
    }
    else if ([aType isEqualToString:@"pdf"]){
        tString = @"icon_pdf";
    }
    else if ([aType isEqualToString:@"mp3"]){
        tString = @"icon_mp3";
    }
    else if ([aType isEqualToString:@"mp4"]){
        tString = @"icon_mp4";
    }
    return tString;
    
    
}
+(NSString *)currentTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}
+(NSString *) md5HexDigest:(NSString *)aString{
    const char *original_str = [aString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}






@end
