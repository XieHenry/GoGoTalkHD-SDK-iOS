//
//  GGT_CalendarCell.m
//  FSCalendar
//
//  Created by 辰 on 2017/5/2.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_CalendarCell.h"
#import "FSCalendarDynamicHeader.h"
#import "FSCalendarExtensions.h"

@interface GGT_CalendarCell ()
@property (nonatomic, strong) UILabel *xc_weekdayLabel;
@property (nonatomic, strong) UILabel *xc_subtitleTopLabel;
@property (nonatomic, strong) UILabel *xc_subtitleBottomLabel;
@property (nonatomic, strong) UIImageView *xc_dotImgView;
@end

@implementation GGT_CalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.subtitleLabel.numberOfLines = 0;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.xc_weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.xc_weekdayLabel.font = Font(14);
    self.xc_weekdayLabel.textColor = UICOLOR_FROM_HEX(Color7E7E7E);
    [self.contentView addSubview:self.xc_weekdayLabel];
    
    self.xc_subtitleTopLabel = [[UILabel alloc] init];
    self.xc_subtitleTopLabel.font = Font(14);
    self.xc_subtitleTopLabel.textAlignment = NSTextAlignmentCenter;
    [self.subtitleLabel addSubview:self.xc_subtitleTopLabel];
    
    self.xc_subtitleBottomLabel = [[UILabel alloc] init];
    self.xc_subtitleBottomLabel.font = Font(14);
    self.xc_subtitleBottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.subtitleLabel addSubview:self.xc_subtitleBottomLabel];
    
    self.xc_dotImgView = [[UIImageView alloc] init];
    [self.subtitleLabel addSubview:self.xc_dotImgView];
    self.xc_dotImgView.image = UIIMAGE_FROM_NAME(@"gengduo");
    self.xc_dotImgView.contentMode = UIViewContentModeCenter;
    self.xc_dotImgView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectInset(self.bounds, 1, 1);
    
    //    self.imageView.backgroundColor = [UIColor orangeColor];
    
    //self.titleLabel.text = self.title;
    if (self.subtitle) {
        self.subtitleLabel.text = self.subtitle;
        if (self.subtitleLabel.hidden) {
            self.subtitleLabel.hidden = NO;
        }
    } else {
        if (!self.subtitleLabel.hidden) {
            self.subtitleLabel.hidden = YES;
        }
    }
    self.subtitleLabel.hidden = NO;
    
    
    //    if (self.subtitle) {
    CGFloat titleHeight11 = self.calendar.calculator.titleHeight;
    CGFloat subtitleHeight = self.calendar.calculator.subtitleHeight;
    
    CGFloat height = titleHeight11 + subtitleHeight;
    //        self.titleLabel.frame = CGRectMake(
    //                                       self.preferredTitleOffset.x,
    //                                       (self.contentView.fs_height*5.0/6.0-height)*0.5+self.preferredTitleOffset.y,
    //                                       self.contentView.fs_width,
    //                                       titleHeight
    //                                       );
    //        self.subtitleLabel.frame = CGRectMake(
    //                                          self.preferredSubtitleOffset.x,
    //                                          (self.titleLabel.fs_bottom-self.preferredTitleOffset.y) - (self.titleLabel.fs_height-self.titleLabel.font.pointSize)+self.preferredSubtitleOffset.y,
    //                                          self.contentView.fs_width,
    //                                          subtitleHeight
    //                                          );
    
    
    
    
    
    self.titleLabel.frame = CGRectMake(
                                       self.width-titleHeight11- 10,
                                       (self.contentView.fs_height*5.0/6.0-height)*0.5+self.preferredTitleOffset.y-10,
                                       titleHeight11 + 10,
                                       titleHeight11
                                       );
    
    self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.titleLabel.height/2.0+5);
    
    self.subtitleLabel.frame = CGRectMake(
                                          self.preferredSubtitleOffset.x,
                                          self.titleLabel.bottom,
                                          self.contentView.fs_width,
                                          self.height - self.titleLabel.bottom
                                          );
    self.xc_weekdayLabel.frame = CGRectMake(margin10, self.titleLabel.y, self.titleLabel.x-margin10, self.titleLabel.height);
    self.xc_weekdayLabel.font = self.titleLabel.font;
    
    if (!_isSmall) {
        self.xc_weekdayLabel.hidden = YES;
    } else {
        self.xc_weekdayLabel.hidden = NO;
    }
    
    
    if (self.dateType == DateTypeToday) {
        if (self.subtitleLabel.text.length >= 3) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.subtitleLabel.text];
            NSDictionary * firstAttributes = @{NSForegroundColorAttributeName:UICOLOR_FROM_HEX(kThemeColor)};
            [attrStr setAttributes:firstAttributes range:NSMakeRange(0,attrStr.length-3)];
            self.subtitleLabel.attributedText = attrStr;
        }
    } else {
        self.subtitleLabel.text = self.subtitleLabel.text;
    }
    
    
    
    
    
#pragma mark - 布局subtitle
    self.xc_subtitleTopLabel.frame = CGRectMake(1, 15, self.subtitleLabel.width-2, (self.subtitleLabel.height-15)/3.0);
    self.xc_subtitleBottomLabel.frame = CGRectMake(1, self.xc_subtitleTopLabel.bottom, self.xc_subtitleTopLabel.width, self.xc_subtitleTopLabel.height);
    self.xc_dotImgView.frame = CGRectMake(1, self.xc_subtitleBottomLabel.bottom, self.subtitleLabel.width-2, self.xc_subtitleTopLabel.height);
    
    if (self.subtitle.length > 0) {
        self.subtitleLabel.text = @"";

        NSMutableArray *xc_subtitleArray = [NSMutableArray array];
        NSArray *array = [self.subtitle componentsSeparatedByString:@","];
        [xc_subtitleArray addObjectsFromArray:array];
        [xc_subtitleArray removeObjectAtIndex:0];
        
        if (xc_subtitleArray.count >= 2) {
            
            if (xc_subtitleArray.count > 2) {
                self.xc_dotImgView.hidden = NO;
            } else {
                self.xc_dotImgView.hidden = YES;
            }
            
            // 红色的idx
            __block NSInteger index = 0;
            [xc_subtitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj rangeOfString:@"red"].location != NSNotFound) {
                    if (idx >= 2) {
                        index = idx;
                    }
                }
            }];
            
            
            if (xc_subtitleArray.count == 2) {      // 两个
                
                NSString *xc_topString = [xc_subtitleArray[0] componentsSeparatedByString:@"#"][1];
                NSString *xc_bottomString = [xc_subtitleArray[1] componentsSeparatedByString:@"#"][1];
                
                self.xc_subtitleTopLabel.text = xc_topString;
                self.xc_subtitleBottomLabel.text = xc_bottomString;
                
                if ([xc_subtitleArray[0] rangeOfString:@"gray"].location != NSNotFound) {
                    self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                }
                
                if ([xc_subtitleArray[1] rangeOfString:@"gray"].location != NSNotFound) {
                    self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                }
                
                if ([xc_subtitleArray[0] rangeOfString:@"bule"].location != NSNotFound) {
                    self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                }
                
                if ([xc_subtitleArray[1] rangeOfString:@"bule"].location != NSNotFound) {
                    self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                }
                
                if ([xc_subtitleArray[0] rangeOfString:@"red"].location != NSNotFound) {
                    self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                }
                
                if ([xc_subtitleArray[1] rangeOfString:@"red"].location != NSNotFound) {
                    self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                }

                
            } else {        // 3个
                __block BOOL hasRed = NO;
                __block NSInteger index = 0;
                [xc_subtitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj rangeOfString:@"red"].location != NSNotFound) {
                        hasRed = YES;
                        index = idx;
                    }
                }];
                
                if (hasRed) {   // 有红色
                    
                    if (index < xc_subtitleArray.count-1) { // 显示红色 和 红色下面那个
                        
                        NSString *xc_topString = [xc_subtitleArray[index] componentsSeparatedByString:@"#"][1];
                        NSString *xc_bottomString = [xc_subtitleArray[index+1] componentsSeparatedByString:@"#"][1];
                        
                        self.xc_subtitleTopLabel.text = xc_topString;
                        self.xc_subtitleBottomLabel.text = xc_bottomString;
                        
                        if ([xc_subtitleArray[index] rangeOfString:@"gray"].location != NSNotFound) {
                            self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                        }
                        
                        if ([xc_subtitleArray[index+1] rangeOfString:@"gray"].location != NSNotFound) {
                            self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                        }
                        
                        if ([xc_subtitleArray[index] rangeOfString:@"bule"].location != NSNotFound) {
                            self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                        }
                        
                        if ([xc_subtitleArray[index+1] rangeOfString:@"bule"].location != NSNotFound) {
                            self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                        }
                        
                        if ([xc_subtitleArray[index] rangeOfString:@"red"].location != NSNotFound) {
                            self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                        }
                        
                        if ([xc_subtitleArray[index+1] rangeOfString:@"red"].location != NSNotFound) {
                            self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                        }

                        
                    } else { // 显示红色 和 红色上面那个
                        
                        NSString *xc_topString = [xc_subtitleArray[index-1] componentsSeparatedByString:@"#"][1];
                        NSString *xc_bottomString = [xc_subtitleArray[index] componentsSeparatedByString:@"#"][1];
                        
                        self.xc_subtitleTopLabel.text = xc_topString;
                        self.xc_subtitleBottomLabel.text = xc_bottomString;
                        
                        if ([xc_subtitleArray[index-1] rangeOfString:@"gray"].location != NSNotFound) {
                            self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                        }
                        
                        if ([xc_subtitleArray[index] rangeOfString:@"gray"].location != NSNotFound) {
                            self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                        }
                        
                        if ([xc_subtitleArray[index-1] rangeOfString:@"bule"].location != NSNotFound) {
                            self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                        }
                        
                        if ([xc_subtitleArray[index] rangeOfString:@"bule"].location != NSNotFound) {
                            self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                        }
                        
                        if ([xc_subtitleArray[index-1] rangeOfString:@"red"].location != NSNotFound) {
                            self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                        }
                        
                        if ([xc_subtitleArray[index] rangeOfString:@"red"].location != NSNotFound) {
                            self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                        }

                        
                    }
                    
                }
                else {    // 没有红色  正常显示
                    NSString *xc_topString = [xc_subtitleArray[0] componentsSeparatedByString:@"#"][1];
                    NSString *xc_bottomString = [xc_subtitleArray[1] componentsSeparatedByString:@"#"][1];
                    
                    self.xc_subtitleTopLabel.text = xc_topString;
                    self.xc_subtitleBottomLabel.text = xc_bottomString;
                    
                    if ([xc_subtitleArray[0] rangeOfString:@"gray"].location != NSNotFound) {
                        self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                    }
                    
                    if ([xc_subtitleArray[1] rangeOfString:@"gray"].location != NSNotFound) {
                        self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
                    }
                    
                    if ([xc_subtitleArray[0] rangeOfString:@"bule"].location != NSNotFound) {
                        self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                    }
                    
                    if ([xc_subtitleArray[1] rangeOfString:@"bule"].location != NSNotFound) {
                        self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
                    }
                    
                    if ([xc_subtitleArray[0] rangeOfString:@"red"].location != NSNotFound) {
                        self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                    }
                    
                    if ([xc_subtitleArray[1] rangeOfString:@"red"].location != NSNotFound) {
                        self.xc_subtitleBottomLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
                    }
                }
            }
            
            
        
        } else {
            
            NSString *xc_topString = [xc_subtitleArray[0] componentsSeparatedByString:@"#"][1];
            
            self.xc_dotImgView.hidden = YES;
            self.xc_subtitleTopLabel.text = xc_topString;
            self.xc_subtitleBottomLabel.text = @"";
            
            if ([xc_subtitleArray[0] rangeOfString:@"gray"].location != NSNotFound) {
                self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(ColorD8D8D8);
            }
            
            if ([xc_subtitleArray[0] rangeOfString:@"bule"].location != NSNotFound) {
                self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(Color0198FF);
            }
           
            if ([xc_subtitleArray[0] rangeOfString:@"red"].location != NSNotFound) {
                self.xc_subtitleTopLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
            }
            
        }
        
    } else {
        self.xc_dotImgView.hidden = YES;
        self.xc_subtitleTopLabel.text = @"";
        self.xc_subtitleBottomLabel.text = @"";
    }

    
    
    
    
    
    
    
    
    
    
    //    } else {
    //        self.titleLabel.frame = CGRectMake(
    //                                       self.preferredTitleOffset.x,
    //                                       self.preferredTitleOffset.y,
    //                                       self.contentView.fs_width,
    //                                       floor(self.contentView.fs_height*5.0/6.0)
    //                                       );
    //    }
    
    
    self.imageView.frame = CGRectMake(self.preferredImageOffset.x, self.preferredImageOffset.y, self.contentView.fs_width, self.contentView.fs_height);
    
    
    
//    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
//    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
//    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter;
    
    
    //    _shapeLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
    //                                   (titleHeight-diameter)/2,
    //                                   diameter,
    //                                   diameter);
    
    
    // 设置选中圆的原点位置
#pragma mark - 需要修改的地方
    /*------------------------------------------------------------------------------*/
    //    float margin = 4;
    //    if (_isToggle) {      椭圆
    //        self.shapeLayer.frame = CGRectMake(margin,
    //                                           self.titleLabel.center.y-CGRectGetHeight(self.titleLabel.frame)/2.0 - margin,
    //                                           CGRectGetWidth(self.titleLabel.frame)-margin*2,
    //                                           CGRectGetHeight(self.titleLabel.frame) + margin*2);
    //    } else {
    // 圆
    //        self.shapeLayer.frame = CGRectMake(self.titleLabel.center.x-CGRectGetHeight(self.titleLabel.frame)/2.0 - margin,
    //                                           self.titleLabel.center.y-CGRectGetHeight(self.titleLabel.frame)/2.0 - margin,
    //                                           CGRectGetHeight(self.titleLabel.frame) + margin*2,
    //                                           CGRectGetHeight(self.titleLabel.frame) + margin*2);
    //    }
    
    
    /*------------------------------------------------------------------------------*/
    float margin = 2;
    self.shapeLayer.frame = CGRectMake(self.titleLabel.center.x-CGRectGetHeight(self.titleLabel.frame)/2.0 - margin,
                                       self.titleLabel.center.y-CGRectGetHeight(self.titleLabel.frame)/2.0 - margin,
                                       CGRectGetHeight(self.titleLabel.frame) + margin*2,
                                       CGRectGetHeight(self.titleLabel.frame) + margin*2);
    
    /*------------------------------------------------------------------------------*/
    
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.shapeLayer.bounds
                                                cornerRadius:CGRectGetWidth(self.shapeLayer.bounds)*0.5*self.borderRadius].CGPath;
    
    
    if (!CGPathEqualToPath(self.shapeLayer.path,path)) {
        self.shapeLayer.path = path;
    }
    
    CGFloat eventSize = self.shapeLayer.frame.size.height/6.0;
    self.eventIndicator.frame = CGRectMake(
                                           self.preferredEventOffset.x,
                                           CGRectGetMaxY(self.shapeLayer.frame)+eventSize*0.17+self.preferredEventOffset.y,
                                           self.fs_width,
                                           eventSize*0.83
                                           );
    
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSString *dateString = [self getTheDayOfTheWeekByDateString:date];
    self.xc_weekdayLabel.text = dateString;
}

-(NSString *)getTheDayOfTheWeekByDateString:(NSDate *)date{
    
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    
    NSString *outputDateStr=[outputFormatter stringFromDate:date];
    
    outputDateStr = [outputDateStr stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
    
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
    return [weekArray objectAtIndex:0];
}

- (CGFloat)borderRadius
{
    return self.preferredBorderRadius >= 0 ? self.preferredBorderRadius : self.appearance.borderRadius;
}

@end
