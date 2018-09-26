//
//  TKBackGroundView.m
//  EduClassPad
//
//  Created by lyy on 2017/11/28.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKBackGroundView.h"
#import "TKMacro.h"
@interface TKBackGroundView()
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end
@implementation TKBackGroundView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.promptLabel.text = MTLocalized(@"State.isInBackGround");
    
}

- (void)setContent:(NSString *)content {
    self.promptLabel.text = content;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
