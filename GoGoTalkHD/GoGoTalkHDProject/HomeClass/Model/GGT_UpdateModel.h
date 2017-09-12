//
//  GGT_UpdateModel.h
//  GoGoTalkHD
//
//  Created by 辰 on 2017/9/12.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGT_UpdateModel : NSObject

@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Contents;
@property (nonatomic, strong) NSString *FirstButton;
@property (nonatomic, strong) NSString *LastButton;
@property (nonatomic, strong) NSString *Url;
@property (nonatomic, strong) NSString *Type;

@end

/*
 
 //Type类型：0 非强制性更新  1 强制性更新  2 已是最新版本，不用更新
 
 "data": {
     "Title": "版本更新",
     "Contents": "亲爱的学员，GoGo英语有版本更新了，邀请您来参与新版体验！",
     "FirstButton": "暂不更新",
     "LastButton": "立即更新",
     "Url": "https://www.baidu.com/",
     "Type": 0
 }
 */
