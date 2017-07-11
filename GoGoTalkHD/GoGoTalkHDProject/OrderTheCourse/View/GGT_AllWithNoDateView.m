//
//  GGT_AllWithNoDateView.m
//  GoGoTalk
//
//  Created by XieHenry on 2017/6/23.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import "GGT_AllWithNoDateView.h"

@implementation GGT_AllWithNoDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    
    
    GGT_NoMoreDateAlertView *nodataView = [[GGT_NoMoreDateAlertView alloc]initWithFrame:CGRectMake(0, LineY(80), SCREEN_WIDTH(), LineW(180)) andImageString:@"wudingdan_wode" andAlertString:@"此时间段没有老师"];
    [self addSubview:nodataView];
    
    
    //推荐时间
    UILabel *tuijianLabel = [[UILabel alloc]init];
    tuijianLabel.frame = CGRectMake(0, nodataView.y+nodataView.height+LineY(34), SCREEN_WIDTH(), LineW(18));
    tuijianLabel.text = @"推荐时间";
    tuijianLabel.font = Font(16);
    tuijianLabel.textAlignment = NSTextAlignmentCenter;
    tuijianLabel.textColor = UICOLOR_FROM_HEX(kThemeColor);
    [self addSubview:tuijianLabel];
    
    
    
    self.tagsView = [[OrderTimeTagsView alloc] init];
    self.tagsView.frame = CGRectMake(0,tuijianLabel.y+tuijianLabel.height+LineY(20),SCREEN_WIDTH(),10);
    [self addSubview:self.tagsView];

    self.tagsView.textColor = UICOLOR_FROM_HEX(kThemeColor);
    self.tagsView.textSize = LineW(12);
    self.tagsView.bordColor = UICOLOR_FROM_HEX(kThemeColor);
    self.tagsView.textbackgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    self.tagsView.allowClick = YES;
    self.tagsView.cornerRadius = LineH(12);
    [self.tagsView setTags:@[@"15:30",@"17:00",@"19:30"]];
//    [self.tagsView setTags:@[@"15:30",@"17:00",@"19:30",@"16:30",@"18:00",@"11:30"]];

    self.tagsView.tagClickedBlock = ^(NSString *tagString){
        NSLog(@"tagString---%@",tagString);
    };
    
    

    //刷新标签UI高度
    [self.tagsView display];
    
    
    //刷新之后重新赋值
    self.tagsView.frame = CGRectMake((SCREEN_WIDTH() - [self.tagsView fittedSize].width)/2,tuijianLabel.y+tuijianLabel.height+LineY(20),[self.tagsView fittedSize].width, [self.tagsView fittedSize].height);

}




@end
