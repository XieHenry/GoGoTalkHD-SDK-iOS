//
//  TKTeacherMessageTableViewCell.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKTeacherMessageTableViewCell.h"
#import "TKMacro.h"
#import "TKUtil.h"

@interface TKTeacherMessageTableViewCell ()
@property (nonatomic, strong) UIImageView *xc_imgView;
@end

@implementation TKTeacherMessageTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
//14 12
- (void)setupView
{
    
   
    
    CGFloat tViewCap = 10 *Proportion;
    //头
    {
    
        _iTimeLabel = ({
            CGRect tFrame = CGRectMake(CGRectGetWidth(self.contentView.frame)-36*Proportion-tViewCap, 0, 36*Proportion, 16*Proportion);
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tFrame];
            tLabel.textColor = RGBCOLOR(143, 143, 143);
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(14);
            tLabel;
            
        });
        [self.contentView addSubview:_iTimeLabel];
        
        _iNickNameLabel = ({
            
            CGRect tFrame = CGRectMake(tViewCap,0,  CGRectGetWidth(self.contentView.frame)-2*tViewCap-CGRectGetWidth(_iTimeLabel.frame), 16*Proportion);
            
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tFrame];
            tLabel.textColor = RGBCOLOR(255, 255, 255);
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(15);
            tLabel;
            
        });
        [self.contentView addSubview:_iNickNameLabel];
    
    }
   //内容
    {
    
        _iMessageView = ({
            UIView *tView = [[UIView alloc]initWithFrame:CGRectZero];
//            tView.backgroundColor = RGBCOLOR(48, 48, 48);
            tView.backgroundColor = [UIColor clearColor];
            tView;
            
        });
        [self.contentView addSubview:_iMessageView];
        
        _xc_imgView = ({
            UIImage* img = UIIMAGE_FROM_NAME(@"student_chat_backgroundImage");//原图
            // 设置端盖的值
            CGFloat top = 20;
            CGFloat left = img.size.width * 0.5;
            CGFloat bottom = 20;
            CGFloat right = 20;
            
            // 设置端盖的值
            UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
            // 设置拉伸的模式
            UIImageResizingMode mode = UIImageResizingModeStretch;
            
            // 拉伸图片
            UIImage *newImage = [img resizableImageWithCapInsets:edgeInsets resizingMode:mode];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            
            imgView.image = newImage;
            
            imgView;
        });
        [_iMessageView addSubview:_xc_imgView];
        
        _iMessageLabel = ({
            
            UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//            tLabel.textColor = RGBCOLOR(134, 134, 134);
            tLabel.textColor = [UIColor blackColor];
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(15);
            tLabel.numberOfLines = 0;
            tLabel;
            
        });
        [_iMessageView addSubview:_iMessageLabel];
        
        _iTranslationButton = ({
            UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tLeftButton.frame = CGRectMake(0, 0, 22*Proportion, 22*Proportion);
            //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
            tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
            [tLeftButton setImage: LOADIMAGE(@"btn_translation_normal") forState:UIControlStateNormal];
            [tLeftButton setImage: LOADIMAGE(@"btn_translation_pressed") forState:UIControlStateHighlighted];
            [tLeftButton addTarget:self action:@selector(translationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tLeftButton.hidden = YES;
            tLeftButton;
                
        });
        [_iMessageView addSubview:_iTranslationButton];
        
        
        
        _iMessageTranslationLabel = ({
            
            UILabel *tLabel        = [[UILabel alloc] initWithFrame:CGRectZero];
            tLabel.textColor       = RGBCOLOR(225, 225, 225);
            tLabel.backgroundColor = RGBCOLOR(28, 28, 28);
            tLabel.font            = TKFont(15);
            tLabel.numberOfLines = 0;
            tLabel.hidden = YES;
            tLabel;
            
        });
        [self.contentView addSubview:_iMessageTranslationLabel];
    
    }
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor             = [UIColor clearColor];
    
}
- (void)resetView
{
    _iMessageLabel.text = _iText;
    _iMessageTranslationLabel.text = _iTranslationtext;
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
 
    
    CGSize tMessageLabelsize = [TKTeacherMessageTableViewCell sizeFromText:_iMessageLabel.text withLimitWidth:CGRectGetWidth(self.contentView.frame)-22*Proportion-10*2*Proportion Font:TKFont(15)];
    
    _iMessageLabel.frame = CGRectMake(5, 0, tMessageLabelsize.width+5, tMessageLabelsize.height+5);
    
    _iMessageView.frame = CGRectMake(10, 0, _iMessageLabel.width+5, _iMessageLabel.height);
    _xc_imgView.frame = CGRectMake(-10, 0, _iMessageView.width+15, _iMessageView.height);
    
    
    _iTranslationButton.frame = CGRectMake(CGRectGetWidth(_iMessageView.frame)-22*Proportion, 0,  22*Proportion,  22*Proportion);
    
     CGSize tTranslationMessageLabelsize = [TKTeacherMessageTableViewCell sizeFromText:_iMessageTranslationLabel.text withLimitWidth:CGRectGetWidth(self.contentView.frame) Font:TKFont(15)];
    
    _iMessageTranslationLabel.frame = CGRectMake(0, CGRectGetMaxY(_iMessageLabel.frame), tTranslationMessageLabelsize.width+5, tTranslationMessageLabelsize.height+5);
    
    

}


-(void)translationButtonClicked:(UIButton *)aButton{
    if (_iTranslationButtonClicked) {
        
       // _iTranslationtext = @"我的大脑是红色的，因为我总是热，我总是在火与新的计划和想法";
        
        _iTranslationButtonClicked(_iTranslationtext);
    }
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
    
    CGFloat height = [self sizeFromText:text withLimitWidth:width Font:TEXT_FONT].height;
    return height;
}

@end
