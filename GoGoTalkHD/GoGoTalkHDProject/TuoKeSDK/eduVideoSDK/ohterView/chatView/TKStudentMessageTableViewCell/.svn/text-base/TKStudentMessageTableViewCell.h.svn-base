//
//  TKStudentMessageTableViewCell.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
typedef void(^bTranslationButtonClicked)(NSString *aTranslationString);

@interface TKStudentMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *iNickNameLabel;
@property (nonatomic, strong) UILabel *iTimeLabel;
@property (nonatomic, strong) UIView *iMessageView;
@property (nonatomic, strong) UILabel *iMessageLabel;
@property (nonatomic, strong) UIButton *iTranslationButton;
@property (nonatomic, copy)   bTranslationButtonClicked iTranslationButtonClicked;
@property (nonatomic, strong) UILabel *iMessageTranslationLabel;
@property (nonatomic, assign) MessageType iMessageType;
@property (nonatomic, strong) NSString *iText;
@property (nonatomic, strong) NSString *iTranslationtext;
@property (nonatomic, strong) NSString *iNickName;
@property (nonatomic, strong) NSString *iTime;

- (void)resetView;
+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width;
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont;
+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
+ (CGSize)sizeFromAttributedString:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
@end
