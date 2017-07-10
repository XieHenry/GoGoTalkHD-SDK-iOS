//
//  GGT_MineHeaderView.m
//  GoGoTalkHD
//
//  Created by XieHenry on 2017/5/15.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_MineHeaderView.h"

@implementation GGT_MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        
    }
    return self;
    
}

- (void)initView {
    self.backgroundColor = UICOLOR_FROM_HEX(ColorFFFFFF);
    
    //头像
    self.headImgView = [[UIImageView alloc]init];
    self.headImgView.image = UIIMAGE_FROM_NAME(@"me_default_avatar");
    self.headImgView.layer.masksToBounds = YES;
    [self.headImgView addBorderForViewWithBorderWidth:3.0 BorderColor:UICOLOR_FROM_HEX(ColorC40016) CornerRadius:38];
    [self addSubview:self.headImgView];
    
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LineW(76), LineW(76)));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(LineY(54));
    }];
    
    
    //姓名
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = Font(20);
    [self addSubview:self.nameLabel];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LineH(28));
        make.left.equalTo(self.mas_left).with.offset(116);
        make.top.equalTo(self.headImgView.mas_bottom).with.offset(LineH(10));
    }];
    
    //v i p
    self.VIPImgView = [UIImageView new];
    [self addSubview:self.VIPImgView];
    [self.VIPImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(LineW(10));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(LineW(32), LineH(18)));
    }];
    
    //英语等级
    self.levelLabel = [[UILabel alloc]init];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.font = Font(12);
    [self addSubview:self.levelLabel];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(LineH(3));
        make.height.mas_equalTo(LineH(17));
    }];
    
    
    
    //上课信息View
    UIView *classInfoView = [UIView new];
    [self addSubview:classInfoView];
    [classInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.height.mas_equalTo(LineH(55));
        make.top.equalTo(self.levelLabel.mas_bottom).with.offset(LineY(30));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    //上课信息与个人信息之间分割线
    UIView *divisionLine = [UIView new];
    divisionLine.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [classInfoView addSubview:divisionLine];
    [divisionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(classInfoView.mas_left).with.offset(0);
        make.right.equalTo(classInfoView.mas_right).with.offset(0);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(classInfoView.mas_bottom).with.offset(0);
    }];
    
    /*  ---------------迟到次数---------------------  */
    UIView *lateView = [UIView new];
    //lateView.backgroundColor = UICOLOR_RANDOM_COLOR();
    [classInfoView addSubview:lateView];
    [lateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(divisionLine.mas_top).with.offset(0);
        make.top.equalTo(classInfoView.mas_top).with.offset(0);
        make.width.mas_equalTo(LineW(115));
        make.left.equalTo(classInfoView.mas_left).with.offset(0);
    }];
    
    
    _laterLabel = [UILabel new];
    _laterLabel.font = Font(22);
    _laterLabel.textColor = UICOLOR_FROM_HEX(ColorC40016);
//    _laterLabel.text = @"5";
    [lateView addSubview:_laterLabel];
    
    UILabel *ciLabel = [UILabel new];
    ciLabel.font = Font(12);
    ciLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    ciLabel.text = @"次";
    [lateView addSubview:ciLabel];
    
    [_laterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(lateView.mas_centerX).with.offset(-11);
        make.bottom.equalTo(lateView.mas_bottom).with.offset(-25);
    }];
    [ciLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
        make.left.equalTo(_laterLabel.mas_right).with.offset(5);
        make.bottom.equalTo(lateView.mas_bottom).with.offset(-28);
    }];
    
    UILabel *lateSubLabel = [UILabel new];
    lateSubLabel.text = @"迟到";
    lateSubLabel.textColor = UICOLOR_FROM_HEX(Color232323);
    lateSubLabel.font = Font(12);
    [lateView addSubview:lateSubLabel];
    [lateSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ciLabel.mas_bottom).with.offset(1);
        make.height.mas_equalTo(17);
        make.left.equalTo(_laterLabel.mas_left);
    }];
    /*  ---------------迟到次数---------------------  */
    /*---------------已说---------------------*/
    UIView *talkMin = [UIView new];
    //talkMin.backgroundColor = UICOLOR_RANDOM_COLOR();
    [classInfoView addSubview:talkMin];
    [talkMin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(classInfoView.mas_top).with.offset(0);
        make.left.equalTo(lateView.mas_right).with.offset(0);
        make.bottom.equalTo(divisionLine.mas_top).with.offset(0);
        make.width.mas_equalTo(117);
    }];
    UIView *talkLine = [UIView new];
    talkLine.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [talkMin addSubview:talkLine];
    [talkLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(talkMin.mas_left).with.offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(talkMin.mas_centerY);
    }];
    UIView *talkLine2 = [UIView new];
    talkLine2.backgroundColor = UICOLOR_FROM_HEX(ColorF2F2F2);
    [talkMin addSubview:talkLine2];
    [talkLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(talkMin.mas_right).with.offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(talkMin.mas_centerY);
    }];
    
    
    
    _speakLabel = [UILabel new];
    _speakLabel.font = Font(22);
//    _speakLabel.text = @"900";
    _speakLabel.textColor = UICOLOR_FROM_HEX(ColorC40016);
    [talkMin addSubview:_speakLabel];
    [_speakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(talkMin.mas_centerX).with.offset(-LineX(11));
        make.height.mas_offset(30);
        make.top.equalTo(talkMin.mas_top).with.offset(0);
    }];
    UILabel *ciTalkLabel = [UILabel new];
    ciTalkLabel.font = Font(12);
    ciTalkLabel.text = @"min";
    ciTalkLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    [talkMin addSubview:ciTalkLabel];
    [ciTalkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
        make.left.equalTo(_speakLabel.mas_right).with.offset(5);
        make.bottom.equalTo(lateView.mas_bottom).with.offset(-28);
    }];
    UILabel *talkSubLabel = [UILabel new];
    talkSubLabel.text = @"已说";
    talkSubLabel.textColor = UICOLOR_FROM_HEX(Color232323);
    talkSubLabel.font = Font(12);
    [talkMin addSubview:talkSubLabel];
    [talkSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lateSubLabel.mas_centerY);
        make.height.mas_equalTo(LineH(17));
        make.left.mas_equalTo(_speakLabel.mas_left);
    }];
    /*---------------已说---------------------*/
    /* ---------------缺席---------------- */
    UIView *absenceView = [UIView new];
    
    [classInfoView addSubview:absenceView];
    [absenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(talkMin.mas_top);
        make.bottom.mas_equalTo(talkMin.mas_bottom);
        make.left.equalTo(talkMin.mas_right).with.offset(0);
        make.right.equalTo(classInfoView.mas_right).with.offset(0);
    }];
    
    
    _absentLabel = [UILabel new];
    _absentLabel.font = Font(22);
//    _absentLabel.text = @"3";
    _absentLabel.textColor = UICOLOR_FROM_HEX(ColorC40016);
    [absenceView addSubview:_absentLabel];
    [_absentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_speakLabel.mas_centerY);
        make.height.equalTo(_speakLabel.mas_height);
        make.centerX.equalTo(absenceView.mas_centerX).with.offset(-LineX(11));
    }];
    UILabel *ciAbsenceLabel = [UILabel new];
    ciAbsenceLabel.font = Font(12);
    ciAbsenceLabel.text = @"次";
    ciAbsenceLabel.textColor = UICOLOR_FROM_HEX(Color777777);
    [absenceView addSubview:ciAbsenceLabel];
    [ciAbsenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(LineH(17));
        make.left.equalTo(_absentLabel.mas_right).with.offset(5);
        make.centerY.equalTo(ciTalkLabel.mas_centerY);
    }];
    UILabel *absenceSubLabel = [UILabel new];
    absenceSubLabel.text = @"缺席";
    absenceSubLabel.textColor = UICOLOR_FROM_HEX(Color232323);
    absenceSubLabel.font = Font(12);
    [absenceView addSubview:absenceSubLabel];
    [absenceSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(talkSubLabel.mas_height);
        make.left.equalTo(_absentLabel.mas_left);
        make.centerY.equalTo(talkSubLabel.mas_centerY);
    }];
    /* ---------------缺席---------------- */
}

- (void)getResultModel:(GGT_MineLeftModel *)model {
    
    //头像  http://teacher.gogo-talk.com/headimages/5141_20170316181829721.jpg
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl] placeholderImage:UIIMAGE_FROM_NAME(@"me_default_avatar")];
    
    CGSize nameSize = [model.Name boundingRectWithSize:CGSizeMake(LineW(350), 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font(20)} context:nil].size;

    
    //姓名
    self.nameLabel.text = model.Name;
    
    
    
    GGT_Singleton *sin = [GGT_Singleton sharedSingleton];
    if (sin.isAuditStatus == YES) {
        self.VIPImgView.hidden = YES;

        //更新姓名的坐标，始终处于中间位置
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset((LineW(350) - nameSize.width)/2);
            make.top.equalTo(self.headImgView.mas_bottom).with.offset(LineH(10));
            make.height.mas_equalTo(LineH(28));
        }];
        
    }else {
        //缺一个判断，是否是v i p会员
        if ([[NSString stringWithFormat:@"%ld",(long)model.isVip] isEqualToString:@"1"]) {
            self.VIPImgView.image = UIIMAGE_FROM_NAME(@"VIP");
        } else {
            self.VIPImgView.image = UIIMAGE_FROM_NAME(@"fei_VIP");
        }
        

        //更新姓名的坐标，始终处于中间位置
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset((LineW(312) - nameSize.width)/2);
            make.top.equalTo(self.headImgView.mas_bottom).with.offset(LineH(10));
            make.height.mas_equalTo(LineH(28));
        }];
    }

   
    
    //英语等级
    self.levelLabel.text = [NSString stringWithFormat:@"英语等级： Level %ld",(long)model.lv];
    
    //已说英语
    self.speakLabel.text = [NSString stringWithFormat:@"%ld",(long)model.shuo];
    
    //迟到
    self.laterLabel.text = [NSString stringWithFormat:@"%ld",(long)model.chi];
    
    //缺席
    self.absentLabel.text = [NSString stringWithFormat:@"%ld",(long)model.que];
    
}

@end
