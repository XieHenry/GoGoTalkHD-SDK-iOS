//
//  TKStudentMessageTableViewCell.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKStudentMessageTableViewCell.h"
#import "TKMacro.h"
#import "TKUtil.h"

@implementation TKStudentMessageTableViewCell

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
//14 12
- (void)setupView
{
    
    CGFloat tViewCap = 10 *Proportion;
    CGFloat tContentWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat tContentHigh = CGRectGetHeight(self.contentView.frame);
    CGFloat tTimeLabelWidth = 50*Proportion;
    CGFloat tTimeLabelHeigh = 16*Proportion;
    CGFloat tTranslateLabelHeigh = 22*Proportion;
    //头
    {
       
        _iTimeLabel = ({
            CGRect tFrame = CGRectMake(tViewCap,0,  tTimeLabelWidth, tTimeLabelHeigh);
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tFrame];
            tLabel.textColor = RGBCOLOR(143, 143, 143);
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(10);
            tLabel;
            
        });
        [self.contentView addSubview:_iTimeLabel];
        
        _iNickNameLabel = ({
            
            CGRect tFrame = CGRectMake(tContentWidth-tTimeLabelWidth-tViewCap, 0, tContentWidth-tTimeLabelWidth, tTimeLabelHeigh);
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tFrame];
            tLabel.textColor = RGBCOLOR(255, 255, 255);
            _iNickNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(10);
            tLabel;
            
        });
        [self.contentView addSubview:_iNickNameLabel];
        
    }
    //内容
    {
        
        _iMessageView = ({
            UIView *tView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_iNickNameLabel.frame), tContentWidth, tContentHigh-CGRectGetMaxY(_iNickNameLabel.frame)-5)];
            tView.backgroundColor = RGBCOLOR(48, 48, 48);
            tView;
            
        });
        [self.contentView addSubview:_iMessageView];
       

        _iMessageLabel = ({
            
            UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(_iMessageView.frame)-tTranslateLabelHeigh, CGRectGetHeight(_iMessageView.frame))];
            
            tLabel.textColor = RGBCOLOR(134, 134, 134);
            tLabel.backgroundColor = [UIColor clearColor];
            tLabel.font = TKFont(15);
            tLabel.numberOfLines = 0;
            tLabel;
            
        });
        [_iMessageView addSubview:_iMessageLabel];
      
        _iTranslationButton = ({
            UIButton *tLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tLeftButton.frame = CGRectMake(CGRectGetWidth(_iMessageView.frame)-tTranslateLabelHeigh, 0, tTranslateLabelHeigh, tTranslateLabelHeigh);
            //        tLeftButton.center = CGPointMake(25+8, _titleView.center.y);
            tLeftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            
            [tLeftButton setImage: LOADIMAGE(@"btn_translation_normal") forState:UIControlStateNormal];
            [tLeftButton setImage: LOADIMAGE(@"btn_translation_pressed") forState:UIControlStateHighlighted];
            [tLeftButton addTarget:self action:@selector(translationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tLeftButton.enabled = NO;
            tLeftButton;
            
        });
      
        [_iMessageView addSubview:_iTranslationButton];
        
        
      
        _iMessageTranslationLabel = ({
            
            UILabel *tLabel        = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_iNickNameLabel.frame)+5+CGRectGetHeight(_iMessageView.frame), tContentWidth, tContentHigh-tTimeLabelHeigh-CGRectGetMaxY(_iMessageView.frame)-5)];
            tLabel.textColor       = RGBCOLOR(225, 225, 225);
            tLabel.backgroundColor = RGBCOLOR(28, 28, 28);
            tLabel.font            = TKFont(15);
            tLabel.numberOfLines = 0;
            tLabel;
            
        });
        [self.contentView addSubview:_iMessageTranslationLabel];
        
    }
    
    self.contentView.backgroundColor = [UIColor clearColor];

    self.backgroundColor             = [UIColor clearColor];
   
    
}
- (void)resetView
{
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_iText];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 10;
//    
//    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, _iText.length)];
//    [attributeString addAttribute:NSFontAttributeName value:TKFont(15) range:NSMakeRange(0, _iText.length)];
//    
//    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:_iText];
//    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 10;
//   
//    [attributeString2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, _iText.length)];
//    [attributeString2 addAttribute:NSFontAttributeName value:TKFont(15) range:NSMakeRange(0, _iText.length)];
//    _iMessageTranslationLabel.attributedText = attributeString2;
//    
//    _iMessageLabel.attributedText = attributeString;
    _iMessageLabel.text = _iText;
    _iMessageTranslationLabel.text = _iTranslationtext;
     NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[_iNickName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    _iNickNameLabel.text = attrStr.string;
    _iTimeLabel.text =  _iTime;
     [self layoutSubviews];
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
     CGFloat tViewCap = 10 *Proportion;
     CGFloat tContentWidth = CGRectGetWidth(self.contentView.frame);
     CGFloat tTimeLabelWidth = 80*Proportion;
     CGFloat tTimeLabelHeigh = 16*Proportion;
     CGFloat tTranslateLabelHeigh = 22*Proportion;
    //
    //MessageType_Teacher  MessageType_OtherUer  MessageType_Message
    //之前是MessageType_Me
    // _iMessageType == MessageType_Teacher || _iMessageType == MessageType_OtherUer || _iMessageType == MessageType_Message
    if (_iMessageType == MessageType_Teacher || _iMessageType == MessageType_OtherUer || _iMessageType == MessageType_Message) {
        _iTimeLabel.frame = CGRectMake(tViewCap,0,tTimeLabelWidth ,tTimeLabelHeigh);
        _iNickNameLabel.frame =  CGRectMake(CGRectGetMaxX(_iTimeLabel.frame), 0, tContentWidth-tTimeLabelWidth-tViewCap, tTimeLabelHeigh);

        CGSize tMessageLabelsize = [TKStudentMessageTableViewCell sizeFromText:_iMessageLabel.text withLimitWidth:tContentWidth-tTranslateLabelHeigh-tViewCap*2 Font:TKFont(15)];
        _iNickNameLabel.textAlignment =  NSTextAlignmentRight;
        _iTimeLabel.textAlignment = NSTextAlignmentLeft;
        _iMessageView.frame  = CGRectMake(tViewCap, CGRectGetHeight(_iNickNameLabel.frame)+5, tMessageLabelsize.width+tTranslateLabelHeigh+5, tMessageLabelsize.height+5);
        
        _iMessageLabel.frame = CGRectMake(0, 0, tMessageLabelsize.width+5, tMessageLabelsize.height+5);
        _iTranslationButton.frame = CGRectMake(CGRectGetWidth(_iMessageView.frame)-tTranslateLabelHeigh, 0,  tTranslateLabelHeigh,  tTranslateLabelHeigh);
        CGSize tTranslationMessageLabelsize = [TKStudentMessageTableViewCell sizeFromText:_iTranslationtext withLimitWidth:tContentWidth-2*tViewCap Font:TKFont(15)];
        
        _iMessageTranslationLabel.frame = CGRectMake(tViewCap, CGRectGetMaxY(_iMessageView.frame), tTranslationMessageLabelsize.width+5, tTranslationMessageLabelsize.height+5);
        _iMessageTranslationLabel.hidden = ([_iTranslationtext isEqualToString:@""] || !_iTranslationtext);
  
        NSLog(@"_iMessageTranslationLabel:%@",_iMessageTranslationLabel.hidden?@"yinchang":@"wu");
        

        
        
    }else{
         _iNickNameLabel.frame = CGRectMake(tViewCap,0,tTimeLabelWidth ,tTimeLabelHeigh);
        _iTimeLabel.frame =  CGRectMake(CGRectGetMaxX(_iNickNameLabel.frame), 0, tContentWidth-tTimeLabelWidth-tViewCap, tTimeLabelHeigh);
       
        _iNickNameLabel.textAlignment = NSTextAlignmentLeft ;
        _iTimeLabel.textAlignment = NSTextAlignmentRight;
        CGSize tMessageLabelsize = [TKStudentMessageTableViewCell sizeFromText:_iMessageLabel.text withLimitWidth:tContentWidth-tTranslateLabelHeigh-tViewCap*2 Font:TKFont(15)];
        
        _iMessageView.frame  = CGRectMake(tContentWidth-tMessageLabelsize.width-5-tViewCap*2-tTranslateLabelHeigh, CGRectGetHeight(_iNickNameLabel.frame)+5, tMessageLabelsize.width+tTranslateLabelHeigh+5, tMessageLabelsize.height+5);
        
        _iMessageLabel.frame = CGRectMake(0, 0, tMessageLabelsize.width+5, tMessageLabelsize.height+5);
        
        _iTranslationButton.frame = CGRectMake(CGRectGetWidth(_iMessageView.frame)-tTranslateLabelHeigh, 0,  tTranslateLabelHeigh,  tTranslateLabelHeigh);
        
        CGSize tTranslationMessageLabelsize = [TKStudentMessageTableViewCell sizeFromText:_iTranslationtext withLimitWidth:tContentWidth-2*tViewCap Font:TKFont(15)];
        
        _iMessageTranslationLabel.frame = CGRectMake(tContentWidth-tTranslationMessageLabelsize.width-5-2*tViewCap, CGRectGetMaxY(_iMessageView.frame), tTranslationMessageLabelsize.width+5, tTranslationMessageLabelsize.height+5);
        _iMessageTranslationLabel.hidden = ([_iTranslationtext isEqualToString:@""]|| !_iTranslationtext);
   
        NSLog(@"_iMessageTranslationLabel:%@",_iMessageTranslationLabel.hidden?@"yinchang":@"wu");
    }
 
    [TKUtil setHeight:self.contentView To:CGRectGetHeight(_iTimeLabel.frame)+CGRectGetHeight(_iMessageView.frame)+CGRectGetHeight(_iMessageTranslationLabel.frame)+10];
    
    [TKUtil setHeight:self To:CGRectGetHeight(_iTimeLabel.frame)+CGRectGetHeight(_iMessageView.frame)+CGRectGetHeight(_iMessageTranslationLabel.frame)+10];

    
}


-(void)translationButtonClicked:(UIButton *)aButton{
    if (_iTranslationButtonClicked) {
        
        _iTranslationButtonClicked(_iTranslationtext);
    }
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
