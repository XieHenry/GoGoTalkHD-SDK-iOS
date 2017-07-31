//
//  TKMessageTableViewCell.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKMessageTableViewCell.h"
#import "TKMacro.h"
#import "TKUtil.h"
@implementation TKMessageTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setupView
{

    _iMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _iMessageLabel.textColor = RGBCOLOR(134, 134, 134);
    _iMessageLabel.backgroundColor = [UIColor clearColor];
    _iMessageLabel.textAlignment = NSTextAlignmentCenter;
    _iMessageLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_iMessageLabel setFont:TKFont(15)];
    [self.contentView addSubview:_iMessageLabel];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor             = [UIColor clearColor];
   
}
- (void)resetView
{
    _iMessageLabel.text = _iMessageText;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //CGSize tMessageLabelsize = [TKMessageTableViewCell sizeFromText:_iMessageLabel.text withLimitHeight:28 Font:TEXT_FONT];
    CGSize tMessageLabelsize = [TKMessageTableViewCell sizeFromText:_iMessageLabel.text withLimitWidth:CGRectGetWidth(self.frame) Font:TKFont(15)];
    _iMessageLabel.frame = CGRectMake(0, 0, tMessageLabelsize.width+20, tMessageLabelsize.height+20);
    
     [self imageAddCornerWithRadius];
     [TKUtil setCenter:_iMessageLabel ToFrame:self.contentView.frame];
    [self.contentView bringSubviewToFront:_iMessageLabel];
   
}

- (void)imageAddCornerWithRadius{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc]initWithFrame:_iMessageLabel.frame];
       // _backgroudImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _backgroudImageView.backgroundColor = RGBACOLOR(48, 48, 48, 1);

        [self.contentView addSubview:_backgroudImageView];
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_iMessageLabel.frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake( CGRectGetWidth(_iMessageLabel.frame)/2,  CGRectGetWidth(_iMessageLabel.frame)/2)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = _iMessageLabel.frame;
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_iMessageLabel.frame), CGRectGetHeight(_iMessageLabel.frame));
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    _backgroudImageView.layer.mask = maskLayer;
    _backgroudImageView.frame = _iMessageLabel.frame;
    [TKUtil setCenter:_backgroudImageView ToFrame:self.contentView.frame];

    
}


+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont
{
    //    CGSize size = [text sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: aFont};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont
{
    //    CGSize size = [text sizeWithFont:TEXT_FONT constrainedToSize:CGSizeMake(180, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: aFont};
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}
+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width
{
    
    CGFloat height = [self sizeFromText:text withLimitWidth:width Font:TEXT_FONT].height;
    return height;
}

@end
