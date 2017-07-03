//
//  GGT_PopoverController.m
//  GoGoTalkHD
//
//  Created by 辰 on 2017/5/16.
//  Copyright © 2017年 Chn. All rights reserved.
//

#import "GGT_PopoverController.h"
#import "GGT_PopoverCell.h"

@interface GGT_PopoverController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *xc_tableView;
@end

@implementation GGT_PopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    
    self.popoverPresentationController.backgroundColor = [UIColor whiteColor];
}

- (void)initTableView
{
    self.xc_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.xc_tableView.backgroundColor = UICOLOR_FROM_RGB_ALPHA(255, 255, 255, 0.8);
    [self.view addSubview:self.xc_tableView];
    
    [self.xc_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.width.equalTo(self.view);
    }];
    
    self.xc_tableView.delegate = self;
    self.xc_tableView.dataSource = self;
    [self.xc_tableView registerClass:[GGT_PopoverCell class] forCellReuseIdentifier:NSStringFromClass([GGT_PopoverCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGT_PopoverCell *cell = [GGT_PopoverCell cellWithTableView:tableView forIndexPath:indexPath];
    cell.xc_name = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dismissBlock) {
        self.dismissBlock([NSString stringWithFormat:@"%ld", (long)indexPath.row]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




//重写preferredContentSize，让popover返回你期望的大小
- (CGSize)preferredContentSize {
    if (self.presentingViewController && self.xc_tableView != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 320;
        tempSize.height = 402;
//        CGSize size = [self.xc_tableView sizeThatFits:tempSize];  //sizeThatFits返回的是最合适的尺寸，但不会改变控件的大小
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}
- (void)setPreferredContentSize:(CGSize)preferredContentSize{
    super.preferredContentSize = preferredContentSize;
}


@end
