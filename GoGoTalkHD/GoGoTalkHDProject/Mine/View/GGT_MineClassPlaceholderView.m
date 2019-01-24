//
//  GGT_MineClassPlaceholderView.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/6/2.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineClassPlaceholderView.h"

@implementation GGT_MineClassPlaceholderView


- (instancetype)initWithFrame:(CGRect)frame method:(NSInteger)method alertStr:(NSString *)str{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewWithmethod:method alertStr:(NSString *)str];
    }
    return self;
    
}

- (void)initViewWithmethod:(NSInteger)method alertStr:(NSString *)str{
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(140);
        make.size.mas_offset(CGSizeMake(258, 171));
    }];
    
    
    
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = Font(14);
    topLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    topLabel.numberOfLines = 0;
    [self addSubview:topLabel];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(imgView.mas_bottom).offset(20);
    }];
    
    
    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = Font(14);
    bottomLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    [self addSubview:bottomLabel];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(topLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    
    //赋值
    switch (method) {
        case ClassOverAndNoTestReportStatus: {
            
            imgView.image = UIIMAGE_FROM_NAME(@"dengdaizhong");
            //260 163
            [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(self.mas_top).offset(180);
                make.size.mas_offset(CGSizeMake(230,144));
            }];

            topLabel.text = str;
            bottomLabel.text = @"";
            
            
        }
            break;
        case ClassNotStartStatus: {
            imgView.image = UIIMAGE_FROM_NAME(@"tiyanke");

            //260 191
            [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(self.mas_top).offset(140);
                make.size.mas_offset(CGSizeMake(230, 168));
            }];
            
            
            str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            
            if ([str xc_isContainString:@"400"] == YES) {
                //您还没有预约课程，预约课程请联系您的学习顾问\n或登录官网自主约课：www.gogo-talk.com
                NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:str];
                NSDictionary * attris = @{NSForegroundColorAttributeName:UICOLOR_FROM_HEX(kThemeColor)};
                
                NSRange rang = [str rangeOfString:@"400"];
                [mutableAttriStr setAttributes:attris  range:NSMakeRange(rang.location,mutableAttriStr.length-rang.location)];
                topLabel.attributedText = mutableAttriStr;
                
            }else {
                topLabel.text = str;
            }
            
            bottomLabel.text = @"";
            
        }
            
            break;
        case MyClassStatus: {
            
            imgView.image = UIIMAGE_FROM_NAME(@"Empty_state");
            topLabel.text = @"您还没有开通课时，需要开通请联系我们!";
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"客服电话：400-8787-276"];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:UICOLOR_FROM_HEX(ColorC40016) range:NSMakeRange(5, 12)];
            bottomLabel.attributedText = AttributedStr;
        }
            break;
            
        case ClassNormal:
            break;
        default:
            break;
    }
    
    
    
    
    
    
}

@end
