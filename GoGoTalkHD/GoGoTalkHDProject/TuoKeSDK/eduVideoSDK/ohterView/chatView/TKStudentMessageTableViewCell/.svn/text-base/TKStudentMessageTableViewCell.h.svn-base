//
//  TKStudentMessageTableViewCell.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
#import "TKChatMessageModel.h"
typedef void(^bTranslationButtonClicked)(NSString *aTranslationString);

@interface TKStudentMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) TKChatMessageModel *chatModel;

+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width;
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont;
+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
+ (CGSize)sizeFromAttributedString:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
@end
