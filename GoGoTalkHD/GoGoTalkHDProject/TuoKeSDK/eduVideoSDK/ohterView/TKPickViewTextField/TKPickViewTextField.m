//
//  TKPickViewTextField.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/7.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKPickViewTextField.h"
#import "TKMacro.h"
@implementation TKPickViewTextField


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPickerView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
         [self initPickerView];
    }
    return self;
}
-(void)initPickerView{
    _iPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenH-120, ScreenW, 120)];// 新建pickerView, 我是在3.5上运行的, 6/6plus或许宽度不同.
    _iPickView.dataSource = self;
    _iPickView.delegate   = self;
    
    self.inputView = _iPickView;// 重点！ 这样点击TextField就会弹出pickerView了.
    
    _iDataArray = @[@"老师",@"学生"];//0-老师 ,1-助教，2-学生
    _iRole = 0;
    /* default selected item */
    [self setText:[_iDataArray objectAtIndex:0]];// 设置TextField默认显示pickerView第一列的内容
}
- (void)setSelectRow:(NSInteger)index
{
    if (index >=0 ) {
        [_iPickView selectRow:index inComponent:0 animated:YES];// 选中哪一列
    }
}

#pragma mark - UIPickerView dataSource, delegate
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_iDataArray count];
}

-(NSString *) pickerView:(UIPickerView* )pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_iDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.text = [_iDataArray objectAtIndex:row];
    switch (row) {
            //老师
        case 0:
            _iRole = 0;
            break;
        //学生
        case 1:
            _iRole = 2;
            break;
        default:
            break;
    }
    TKLog(@"%@",@(_iRole));
    if (_iTKPickerViewDelegate && [_iTKPickerViewDelegate respondsToSelector:@selector(tkPickerViewSelectedRole:)]) {
        
        [(id<TKPickerViewDelegate>) _iTKPickerViewDelegate tkPickerViewSelectedRole:_iRole];
        
    }
   
}

#pragma mark - inputAccessoryView with toolbar
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)done:(id)sender {
    
    [self resignFirstResponder];
    [super resignFirstResponder];
    NSLog(@"%@",@(_iRole));
    if (_iTKPickerViewDelegate && [_iTKPickerViewDelegate respondsToSelector:@selector(tkPickerViewSelectedRole:)]) {
        
        [(id<TKPickerViewDelegate>) _iTKPickerViewDelegate tkPickerViewSelectedRole:_iRole];
        
    }
    
    
}
- (void)cancle:(id)sender {
    
    [super resignFirstResponder];
    [self resignFirstResponder];
    
}

/* 创建toolbar  http://blog.csdn.net/dexin5195/article/details/42024269 */
- (UIView *)inputAccessoryView {
    
    if (!_iInputAccessoryView) {
        
        _iInputAccessoryView                  = [[UIToolbar alloc] init];
       // _iInputAccessoryView.barStyle         = UIBarStyleDefault;
        _iInputAccessoryView.backgroundColor = [UIColor clearColor];
        _iInputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_iInputAccessoryView sizeToFit];
        CGRect frame               = _iInputAccessoryView.frame;
        frame.size.height          = 30.0f;
        _iInputAccessoryView.frame = frame;
        
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancle:)];
        
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:cancleBtn,flexibleSpaceLeft, doneBtn,nil];
        [_iInputAccessoryView setItems:array];
    }
    return _iInputAccessoryView;

}

@end
