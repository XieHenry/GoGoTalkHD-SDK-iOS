//
//  TKPickViewTextField.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/7.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKPickerViewDelegate <NSObject>

-(void)tkPickerViewSelectedRole:(NSInteger)aRole;

@end

@interface TKPickViewTextField : UITextField<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id<TKPickerViewDelegate> iTKPickerViewDelegate;
@property (nonatomic, strong) UIToolbar   *iInputAccessoryView;//键盘上方的toolbal, 用于加入done按钮完成输入
@property (nonatomic, strong) NSArray      *iDataArray;// pickerView的数据源, 比如 yes, no
@property (nonatomic, strong) UIPickerView *iPickView;// 
@property (nonatomic, assign) NSInteger iRole;//
- (void)setSelectRow:(NSInteger)index;// 选中列
@end
