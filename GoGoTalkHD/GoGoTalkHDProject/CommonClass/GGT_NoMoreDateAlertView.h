//
//  GGT_NoMoreDateAlertView.h
//  GoGoTalk
//
//  Created by XieHenry on 2017/5/9.
//  Copyright © 2017年 XieHenry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGT_NoMoreDateAlertView : UIView


@property (nonatomic, strong) UIImageView *placeImgView;
@property (nonatomic, strong) UILabel *placeLabel;

- (void)imageString:(NSString *)imageString andAlertString:(NSString *)alertString;


@end
