//
//  PlaceholderTextView.h
//  wyh
//
//  Created by bobo on 16/1/5.
//  Copyright © 2016年 HW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

//提醒文字距离左边宽度,上边高度
@property (nonatomic)  CGSize marginSize;

- (void)textChanged:(NSNotification * )notification;

@end
