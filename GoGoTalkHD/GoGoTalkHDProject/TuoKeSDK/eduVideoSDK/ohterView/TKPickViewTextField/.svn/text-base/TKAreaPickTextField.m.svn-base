//
//  TKAreaPickTextField.m
//  EduClassPad
//
//  Created by tom555cat on 2017/11/20.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKAreaPickTextField.h"
#import "TKMacro.h"
#import "TKAreaChooseModel.h"
#import "TKUtil.h"

@interface TKAreaPickTextField ()

@property (nonatomic, strong) NSString *serverName;

@end

@implementation TKAreaPickTextField

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
    _iPickView = [[UIPickerView alloc] init];// 新建pickerView, 我是在3.5上运行的, 6/6plus或许宽度不同.
    _iPickView.dataSource = self;
    _iPickView.delegate   = self;
    
    self.inputView = _iPickView;// 重点！ 这样点击TextField就会弹出pickerView了.
    
    
    _iDataArray = @[];
    
    _iRole = 0;
    /* default selected item */
    //[self setText:[_iDataArray objectAtIndex:0]];// 设置TextField默认显示pickerView第一列的内容
}
- (void)setSelectRow:(NSInteger)index
{
    if (index >=0 ) {
        [_iPickView selectRow:index inComponent:0 animated:YES];// 选中哪一列
    }
}

- (void)setIDataArray:(NSArray *)iDataArray {
    _iDataArray = [iDataArray copy];
    // 需要显示区域列表中已经选中的地区
    NSString *defaultArea;
    for (TKAreaChooseModel *model in iDataArray) {
        if (model.choosed == YES) {
            self.serverName = model.serverAreaName;
            if ([[TKUtil getCurrentLanguage] isEqualToString:@"en"]) {
                defaultArea = [NSString stringWithFormat:@"%@(Auto)", model.englishDesc];
            } else {
                defaultArea = [NSString stringWithFormat:@"%@(默认)", model.chineseDesc];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setText:defaultArea];
    });
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
    TKAreaChooseModel *model = [_iDataArray objectAtIndex:row];
    if ([[TKUtil getCurrentLanguage] isEqualToString:@"en"]) {
        return model.englishDesc;
    } else {
        return model.chineseDesc;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    TKAreaChooseModel *model = [_iDataArray objectAtIndex:row];
    self.serverName = model.serverAreaName;
    if ([[TKUtil getCurrentLanguage] isEqualToString:@"en"]) {
        self.text = model.englishDesc;
    } else {
        self.text = model.chineseDesc;
    }
}

#pragma mark - inputAccessoryView with toolbar
- (BOOL)canBecomeFirstResponder {
    if ([_iDataArray count] == 0) {
        return NO;
    }
    
    TKAreaChooseModel *model = [_iDataArray objectAtIndex:0];
    self.serverName = model.serverAreaName;
    if ([[TKUtil getCurrentLanguage] isEqualToString:@"en"]) {
        self.text = model.englishDesc;
    } else {
        self.text = model.chineseDesc;
    }
    return YES;
}

- (void)done:(id)sender {
    [self resignFirstResponder];
    [super resignFirstResponder];
    if (_iTKPickerViewDelegate && [_iTKPickerViewDelegate respondsToSelector:@selector(tkPickSelectedArea:)]) {
        [(id<TKAreaPickDelegate>)_iTKPickerViewDelegate tkPickSelectedArea:self.serverName];
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
