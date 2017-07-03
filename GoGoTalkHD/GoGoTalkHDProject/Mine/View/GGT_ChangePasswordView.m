//
//  GGT_ChangePasswordView.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/17.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_ChangePasswordView.h"

@implementation GGT_ChangePasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        
    }
    return self;
    
}

- (void)initView {
    self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);

    
    NSArray *titleArray = @[@"当前密码:",@"新的密码:"];
    for (int i=0; i<titleArray.count; i++) {
        UILabel *leftTitleLabel = [[UILabel alloc]init];
        leftTitleLabel.text = titleArray[i];
        leftTitleLabel.font = Font(16);
        leftTitleLabel.textColor = UICOLOR_FROM_HEX(0x3D3D3D);
        [self addSubview:leftTitleLabel];
        
        [leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(LineX(20));
            make.top.equalTo(self).with.offset(LineY(13)+LineH(48)*i);
            make.size.mas_equalTo(CGSizeMake(LineW(80), LineH(22)));
        }];

        
        
        UITextField *field = [[UITextField alloc]init];
        field.font = Font(18);
        field.textColor = UICOLOR_FROM_HEX(Color3D3D3D);
        field.tintColor = UICOLOR_FROM_HEX(ColorC40016);
        field.tag = 10 +i;
        field.delegate = self;
        field.clearButtonMode = YES;
        field.secureTextEntry = YES;
        if (i == 0) {
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入当前密码"] attributes:@{NSForegroundColorAttributeName: UICOLOR_FROM_HEX(ColorD5D5D5)}];

        } else if (i == 1) {
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请设置新密码(6-12位)"] attributes:@{NSForegroundColorAttributeName: UICOLOR_FROM_HEX(ColorD5D5D5)}];

        }
        [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:field];
        
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftTitleLabel.mas_right).with.offset(LineX(30));
            make.right.equalTo(self.mas_right).with.offset(-LineX(30));
            make.top.equalTo(self).with.offset(LineY(13)+LineH(48)*i);
            make.height.mas_equalTo(LineH(25));
        }];
        
    }
    
    
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(LineX(20));
        make.right.equalTo(self.mas_right).with.offset(-0);
        make.top.equalTo(self.mas_top).with.offset(LineY(47.5));
        make.height.mas_offset(LineH(1));
    }];
    
    
    
    
    UITextField *field1 = (UITextField *)[self viewWithTag:10];
    self.currentField = field1;
    
    
    
    UITextField *field2 = (UITextField *)[self viewWithTag:11];
    self.changeField = field2;
    
}
#pragma mark 检测输入框的字数限制
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.currentField) {
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    } else if(textField == self.changeField){
        
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
   
    
    if ((IsStrEmpty(self.currentField.text) || self.currentField.text.length <6 || self.currentField.text.length >12) || (IsStrEmpty(self.changeField.text) || self.changeField.text.length <6 || self.changeField.text.length >12)) {
        if (self.FieldBlock) {
            self.FieldBlock(NO);
        }
    } else {
        if (self.FieldBlock) {
            self.FieldBlock(YES);
        }
    }
    
    
}


@end
