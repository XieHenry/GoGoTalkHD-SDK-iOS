//
//  GGT_ChoicePickView.h
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/23.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickViewType) {
    BirthdayType,
    SexType,
    AddressType,
};


@interface GGT_ChoicePickView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>


- (instancetype)initWithFrame:(CGRect)frame method:(NSInteger)method;

//选中的内容
@property (nonatomic, copy) NSString *choiceDateStr;
//选中的地区id
@property (nonatomic, copy) NSString *choiceIdDateStr;

//生日
@property (nonatomic, copy) void(^DateBlock) (NSString *dateStr);

//性别
@property (nonatomic, copy) void(^SexBlock) (NSString *sexStr);

//所在地
@property (nonatomic, copy) void(^addressBlock) (NSString *addressStr,NSString *addressIdStr);

//传递过来的类型
@property (nonatomic) NSInteger type;

//性别数据源
@property (nonatomic, strong) NSMutableArray *sexDataArray;

//省份数据源
@property (nonatomic, strong) NSMutableArray *shengDataArray;
@property (nonatomic, strong) NSMutableArray *shengIdDataArray;

//市数据源
@property (nonatomic, strong) NSMutableArray *shiDataArray;
@property (nonatomic, strong) NSMutableArray *shiIdDataArray;

//县或区数据源
@property (nonatomic, strong) NSMutableArray *quDataArray;
@property (nonatomic, strong) NSMutableArray *quIdDataArray;


@end
