//
//  TKChooseAreaListView.m
//  EduClassPad
//
//  Created by tom555cat on 2017/11/18.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKChooseAreaListView.h"
#import "TKUtil.h"
#import "TKMacro.h"
//#import "TKAreaChooseModel.h"
//#import "TKChooseAreaListTableViewCell.h"
#import "TKAreaTableViewCell.h"

@interface TKChooseAreaListView ()

@property (nonatomic, strong) UILabel *iChooseAreaHeadLabel;
@property (nonatomic, strong) UITableView *iAreaTableView;
@property (nonatomic, strong) UIButton *button;
//@property (nonatomic, strong) TKAreaChooseModel *chooseAreaModel;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TKChooseAreaListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(35, 35, 35, 0.6);
        
        self.iChooseAreaHeadLabel = ({
            UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 60)];
            
            tLabel.text = MTLocalized(@"Title.AreaList");
            tLabel.font = TITLE_FONT;
            tLabel.textAlignment = NSTextAlignmentCenter;
            tLabel.textColor = RGBCOLOR(225, 225, 225);
            tLabel;
        });
        
        self.iAreaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) - 60) style:UITableViewStyleGrouped];
        self.iAreaTableView.backgroundColor = [UIColor clearColor];
        self.iAreaTableView.separatorColor = [UIColor clearColor];
        self.iAreaTableView.showsHorizontalScrollIndicator = NO;
        self.iAreaTableView.delegate = self;
        self.iAreaTableView.dataSource = self;
        self.iAreaTableView.tableHeaderView = self.iChooseAreaHeadLabel;
        [self.iAreaTableView registerClass:[TKAreaTableViewCell class] forCellReuseIdentifier:@"TKAreaTableViewCell"];
//        NSString *identifier = NSStringFromClass([TKChooseAreaListTableViewCell class]);
//        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
//        [self.iAreaTableView registerNib:nib forCellReuseIdentifier:@"AreaCellIdentifier"];
        [self addSubview:self.iAreaTableView];
        
        self.button = ({
            UIButton *tButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) * 0.2, CGRectGetMaxY(self.iAreaTableView.frame), CGRectGetWidth(frame) * 0.6, 50)];
            tButton.layer.cornerRadius = 5;
            [tButton setBackgroundColor:RGBCOLOR(238, 50, 16)];
            [tButton setTitle:MTLocalized(@"Prompt.OK") forState:UIControlStateNormal];
            [tButton addTarget:self action:@selector(chooseCurrentArea) forControlEvents:UIControlEventTouchUpInside];
            tButton;
        });
        [self addSubview:self.button];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        // 进行网络请求
        __weak typeof(self) wself = self;
//        [[RoomManager instance] requestServerListWithHost:sHost complete:^(id response, NSError *error) {
//            if (error == nil) {
//                NSArray *areaArray = (NSArray *)response;
//                wself.dataArray = areaArray;
//            }
//        }];
    }
    return self;
}

- (void)showView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [TKUtil setLeft:self To:ScreenW-CGRectGetWidth(self.frame)];
    [UIView commitAnimations];
    [self.iAreaTableView reloadData];
}

-(void)hideView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [TKUtil setLeft:self To:ScreenW];
    [UIView commitAnimations];
}

- (void)setServerName:(NSString *)serverName {
//    if (serverName == nil || [self.chooseAreaModel.serverAreaName isEqualToString:serverName]) {
//        return;
//    }
//
//    for (TKAreaChooseModel *obj in self.dataArray) {
//        if ([obj.serverAreaName isEqualToString:serverName]) {
//            // 如果找到了指定的服务器
//            [self.dataArray enumerateObjectsUsingBlock:^(TKAreaChooseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([obj.serverAreaName isEqualToString:serverName]) {
//                    obj.choosed = YES;
//                    self.chooseAreaModel = obj;
//                } else {
//                    obj.choosed = NO;
//                }
//            }];
//
//            // 连接新服务器
//            [self chooseCurrentArea];
//            [self.iAreaTableView reloadData];
//            break;
//        }
//    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    TKChooseAreaListTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"AreaCellIdentifier" forIndexPath:indexPath];
//    TKAreaChooseModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    tCell.areaName = model.chineseDesc;         // ToDo，还需要确定多语言
//    tCell.choosed = model.choosed;
//    return tCell;
    
    TKAreaTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"TKAreaTableViewCell" forIndexPath:indexPath];
    TKAreaChooseModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    if ([TKUtil isSimplifiedChinese]) {
//        tCell.areaName = model.chineseDesc;
//    } else {
//        tCell.areaName = model.englishDesc;
//    }
//
//    tCell.choosed = model.choosed;
    return tCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TKAreaChooseModel *model = [self.dataArray objectAtIndex:indexPath.row];
//    self.chooseAreaModel = model;
//
//    // 其他选项取消选择
//    [self.dataArray enumerateObjectsUsingBlock:^(TKAreaChooseModel   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj != model) {
//            obj.choosed = NO;
//        } else {
//            obj.choosed = YES;
//        }
//    }];
//
//    // 选中当前选项
//    self.chooseAreaModel.choosed = YES;
    
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //[self.delegate chooseArea:self.chooseAreaModel];
}

- (void)chooseCurrentArea {
    // 避免没有点击列表就点击确定
//    if (self.chooseAreaModel) {
//        [self.delegate chooseArea:self.chooseAreaModel];
//    } else {
//        for (TKAreaChooseModel *model in self.dataArray) {
//            if (model.choosed == YES) {
//                [self.delegate chooseArea:model];
//                break;
//            }
//        }
//    }
}

@end
