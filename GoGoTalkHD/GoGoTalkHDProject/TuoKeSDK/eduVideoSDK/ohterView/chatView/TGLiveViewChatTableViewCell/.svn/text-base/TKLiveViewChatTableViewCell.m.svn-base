//
//  TGLiveViewChatTableViewCell.m
//  libMeetings
//
//  Created by ifeng on 16/4/13.
//  Copyright © 2016年 macmini. All rights reserved.
//

#import "TKLiveViewChatTableViewCell.h"
#import "TKUtil.h"
#import "TKMacro.h"

#import "NSAttributedString+JTATEmoji.h"



@implementation TKLiveViewChatTableViewCell

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
     [self imageAddCornerWithRadius];
    _avaterView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_avaterView];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = [UIColor whiteColor];
//    _nameLabel.layer.cornerRadius = 5;
//    _nameLabel.layer.shadowOffset =  CGSizeMake(1, 1);
//    _nameLabel.layer.shadowOpacity = 0.8;
//    _nameLabel.layer.shadowColor =  [UIColor blackColor].CGColor;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_nameLabel setFont:TKFont(15)];
    [self.contentView addSubview:self.nameLabel];
    self.colonLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.colonLabel.textColor = [UIColor whiteColor];
   
    self.colonLabel.text = @":";
    [self.contentView addSubview:self.colonLabel];
    _textView = [[UILabel alloc] initWithFrame:CGRectZero];
   // _textView.editable = NO;
    _textView.font = TEXT_FONT;
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.numberOfLines = 0;
    _textView.lineBreakMode = NSLineBreakByCharWrapping;
//    _textView.scrollEnabled = NO;
//    _textView.layer.cornerRadius = 5;
//    _textView.layer.shadowOffset =  CGSizeMake(1, 1);
//    _textView.layer.shadowOpacity = 0.8;
//    _textView.layer.shadowColor =  [UIColor blackColor].CGColor;
    
    [self.contentView addSubview:_textView];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
   
}
- (void)resetView
{

//    _textView.text = _text;
    _textView.attributedText = [NSAttributedString emojiAttributedString:_text withFont:TEXT_FONT withColor:[UIColor whiteColor]];
    
    self.nameLabel.text = _iName;
    [_nameLabel setTextColor:_iNameColor];
    
    _avaterView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
   
    CGSize titlesize = [TKLiveViewChatTableViewCell sizeFromText:self.nameLabel.text withLimitHeight:20 Font:Name_FONT];
    CGSize colonSize = [TKLiveViewChatTableViewCell sizeFromText:@":" withLimitHeight:20 Font:TEXT_FONT];
    
    CGSize textSize = [TKLiveViewChatTableViewCell sizeFromText:_text withLimitWidth:CGRectGetWidth(self.frame)-colonSize.width-titlesize.width-30 Font:TEXT_FONT];
    _avaterView.frame = CGRectMake(10, 10, 20, 20);
    _avaterView.frame = CGRectMake(0, 0, 0, 0);
    
    _nameLabel.frame = CGRectMake((_avaterView.frame.origin.x + _avaterView.frame.size.width) + 5, 0, titlesize.width+5, titlesize.height+5);
    
    _colonLabel.frame = CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 5, 0, colonSize.width+5, colonSize.height+5);
    
    _textView.frame = CGRectMake(_colonLabel.frame.origin.x + _colonLabel.frame.size.width + 5, 0 , textSize.width + 5, textSize.height+5);
    
    [self imageAddCornerWithRadius];
}

- (void)imageAddCornerWithRadius{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc]initWithFrame:self.contentView.frame];
        _backgroudImageView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        [self.contentView addSubview:_backgroudImageView];
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.contentView.frame;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    _backgroudImageView.layer.mask = maskLayer;
    _backgroudImageView.frame = self.contentView.frame;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
    
    CGFloat height = [TKLiveViewChatTableViewCell sizeFromText:text withLimitWidth:width Font:TEXT_FONT].height;
    return height;
}
@end
