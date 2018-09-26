//
//  TGLiveViewChatTableViewCell.h
//  libMeetings
//
//  Created by ifeng on 16/4/13.
//  Copyright © 2016年 macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
@interface TKLiveViewChatTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *iName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *timeText;
@property (nonatomic, strong) UIColor *iNameColor;
//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textView;

@property (nonatomic, strong) UIImageView *avaterView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *colonLabel;
@property (nonatomic, strong) UIImageView *backgroudImageView;
@property (nonatomic, assign) MessageType iMessageType;

- (void)resetView;
+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width;
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont;
+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
@end
