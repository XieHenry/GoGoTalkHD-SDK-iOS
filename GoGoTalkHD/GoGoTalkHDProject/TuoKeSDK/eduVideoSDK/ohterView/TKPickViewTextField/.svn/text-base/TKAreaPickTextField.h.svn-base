//
//  TKAreaPickTextField.h
//  EduClassPad
//
//  Created by tom555cat on 2017/11/20.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKAreaPickDelegate <NSObject>

- (void)tkPickSelectedArea:(NSString *)areaName;

@end

@interface TKAreaPickTextField : UITextField <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<TKAreaPickDelegate> iTKPickerViewDelegate;
@property (nonatomic, strong) UIToolbar   *iInputAccessoryView;//键盘上方的toolbal, 用于加入done按钮完成输入
@property (nonatomic, copy) NSArray      *iDataArray;// pickerView的数据源, 比如 yes, no
@property (nonatomic, strong) UIPickerView *iPickView;//
@property (nonatomic, assign) NSInteger iRole;//
- (void)setSelectRow:(NSInteger)index;// 选中列

@end
