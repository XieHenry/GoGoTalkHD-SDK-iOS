//
//  TKChatView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/29.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKChatView.h"
#import "TKGrowingTextView.h"

#import "TKUtil.h"
#import "TKMacro.h"
#import "TKEduSessionHandle.h"
//todo
#import "TKChatMessageModel.h"
#import "RoomUser.h"

@interface TKChatView ()<TKGrowingTextViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,retain)UIView *iChatInputView;//全屏
@property(nonatomic,retain)UIView   *iChatTitleView;//抬头
@property(nonatomic,retain)UILabel  *iChatTitleLabel;//聊天
@property(nonatomic,retain)UIButton *iChatTitleClosedButton;//关闭
@property(nonatomic,retain)UIButton *iChatTitleSenddButton;//发送
@property (nonatomic, strong) TKGrowingTextView *iInputField;
@property (nonatomic, strong) UILabel *iReplyText;
@end


static const CGFloat sChatTitleViewWidth  = 598;
static const CGFloat  sChatTitleViewHigh = 49;
static const CGFloat sChatTitleViewClosedWidth = 100;


@implementation TKChatView

-(instancetype)init{
    if (self = [super init]){
        
        self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        _iChatTitleView  =({
            UIView *tView= [[UIView alloc]initWithFrame:CGRectMake((ScreenW-sChatTitleViewWidth*Proportion)/2.0, 20*Proportion, sChatTitleViewWidth*Proportion , sChatTitleViewHigh*Proportion)];
            tView.backgroundColor = RGBCOLOR(41, 41, 41);
            tView;
        });
        UITapGestureRecognizer* tapTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
        tapTableGesture.delegate = self;
        [self addGestureRecognizer:tapTableGesture];
        
        _iChatTitleLabel = ({
            UILabel *tTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(sChatTitleViewClosedWidth*Proportion, 0,CGRectGetWidth(_iChatTitleView.frame)-sChatTitleViewClosedWidth*Proportion*2, CGRectGetHeight(_iChatTitleView.frame))];
            
            tTitleLabel.text = MTLocalized(@"Button.chat");
            tTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            tTitleLabel.backgroundColor = [UIColor clearColor];
            tTitleLabel.textAlignment = NSTextAlignmentCenter;
            tTitleLabel.font = TKFont(18);
            tTitleLabel.textColor = RGBCOLOR(255, 255, 255);
            tTitleLabel;
        
        });
        
        _iChatTitleClosedButton = ({
            
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(0, 0, sChatTitleViewClosedWidth*Proportion, CGRectGetHeight(_iChatTitleView.frame));
            
            tButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [tButton setTitle:MTLocalized(@"Button.closed") forState:UIControlStateNormal];
            [tButton setTitleColor:RGBCOLOR(179, 179, 179) forState:UIControlStateNormal];
            [tButton addTarget:self action:@selector(chatTitleClosedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.backgroundColor = [UIColor clearColor];
            tButton.titleLabel.font = TKFont(15);
            tButton;
            
        });
        _iChatTitleSenddButton = ({
            
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tButton.frame = CGRectMake(CGRectGetWidth(_iChatTitleView.frame)-sChatTitleViewClosedWidth*Proportion, 0, sChatTitleViewClosedWidth*Proportion, CGRectGetHeight(_iChatTitleView.frame));
            
            [tButton setTitle:MTLocalized(@"Button.send") forState:UIControlStateNormal];
            [tButton setTitleColor:RGBCOLOR(236, 203, 47) forState:UIControlStateNormal];
            tButton.titleLabel.font = TKFont(15);
            tButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [tButton addTarget:self action:@selector(chatTitleSenddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            tButton.backgroundColor = [UIColor clearColor];
            tButton;
            
        });
        
        _iInputField =({
            
            CGFloat tInPutInerContainerWidth = CGRectGetWidth(_iChatTitleView.frame);
            CGFloat tInPutInerContainerHeigh =ScreenH - 100;
            CGRect rectInputFieldFrame = CGRectMake(CGRectGetMinX(_iChatTitleView.frame), CGRectGetMaxY(_iChatTitleView.frame), tInPutInerContainerWidth, tInPutInerContainerHeigh);
            TKGrowingTextView *tInputField =  [[TKGrowingTextView alloc] initWithFrame:rectInputFieldFrame];
            tInputField.internalTextView.backgroundColor = RGBCOLOR(62,62,62);
            //tInputField.internalTextView.backgroundColor = [UIColor magentaColor];
            [tInputField.internalTextView setTextColor:RGBACOLOR(168, 168, 168, 1)];
            [tInputField.internalTextView setTintColor:RGBACOLOR(255, 255, 255, 1)];
            //_inputField.layer.borderColor = RGBCOLOR(60,61,64).CGColor;
            //_inputField.layer.borderWidth = 1;
            //tInputField.font = [UIFont systemFontOfSize:15];
            tInputField.delegate         = self;
            tInputField.maxNumberOfLines = 5;
            tInputField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            tInputField.internalTextView.returnKeyType = UIReturnKeySend;
            tInputField.internalTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
            tInputField.backgroundColor =RGBCOLOR(61, 61, 61);
            tInputField;
            
        });
        [self addSubview:_iInputField];
        
        
        _iReplyText                 = ({
            CGFloat tInPutInerContainerHeigh = 15;
            CGRect tReplyTextFrame = CGRectMake(CGRectGetMinX(_iChatTitleView.frame), CGRectGetMaxY(_iChatTitleView.frame), 100, tInPutInerContainerHeigh);
            UILabel *tReplyText                 = [[UILabel alloc] initWithFrame:tReplyTextFrame];
            //tReplyText.backgroundColor = [UIColor redColor];
            tReplyText.textColor       = RGBCOLOR(99, 99, 99);
            tReplyText.text            = MTLocalized(@"Say.say");//@"说点什么吧";
            tReplyText.textAlignment   = NSTextAlignmentLeft;
            tReplyText.numberOfLines   = 1;
            tReplyText.font            = TKFont(15);
            tReplyText;
            
        });
        [self addSubview:_iReplyText];
        [_iChatTitleView addSubview:_iChatTitleSenddButton];
        [_iChatTitleView addSubview:_iChatTitleClosedButton];
        [_iChatTitleView addSubview:_iChatTitleLabel];
       
        [self addSubview:_iChatTitleView];
        
        
    }
    return self;
    
    
}


-(void)chatTitleSenddButtonClicked:(UIButton*)aButton{
    if (!_iInputField || !_iInputField.text || _iInputField.text.length == 0)
    {
        return;
    }

    [[TKEduSessionHandle shareInstance] sessionHandleSendMessage:_iInputField.text completion:nil];
    _iInputField.text = @"";
    _iReplyText.hidden = NO;
    [_iInputField resignFirstResponder];
   
    
    [self hide];
}

-(void)chatTitleClosedButtonClicked:(UIButton *)aButton{
    [self hide];
    
}

-(void)show{
    
  
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    // [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [_iInputField becomeFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    [UIView commitAnimations];
    
}
-(void)hide{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    //   [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    //
    [self removeFromSuperview];
    [self endEditing:NO];
    _iInputField.text = @"";
    // [self refreshData];
    _iReplyText.hidden = NO;
    
    [UIView commitAnimations];
}
-(void)tapTable:(UIGestureRecognizer *)aTab{
    [self hide];
}
- (void)changeInputAreaHeight:(int)height duration:(NSTimeInterval)duration orientationChange:(bool)orientationChange dragging:(bool)__unused dragging completion:(void (^)(BOOL finished))completion
{
    
    
    
}
- (void)updatePlaceholderVisibility:(bool)firstResponder
{
    _iReplyText.hidden = firstResponder || _iInputField.text.length != 0;
}
#pragma mark TKTextViewInternalDelegate
- (void)TKTextViewChangedResponderState:(bool)firstResponder
{
    [self updatePlaceholderVisibility:firstResponder];
}
#pragma mark TKGrowingTextViewDelegate
- (void)growingTextView:(TKGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    [self growingTextView:growingTextView willChangeHeight:height animated:true];
}

- (void)growingTextView:(TKGrowingTextView *)__unused growingTextView willChangeHeight:(float)height animated:(bool)animated
{
//    CGRect inputContainerFrame = _inputContainer.frame;
//    float newHeight = MAX(10 + height, sChatBarHeight);
//    if (inputContainerFrame.size.height != newHeight)
//    {
//        int currentKeyboardHeight = _knownKeyboardHeight;
//        inputContainerFrame.size.height = newHeight;
//        inputContainerFrame.origin.y = _inputContainer.superview.frame.size.height - currentKeyboardHeight - inputContainerFrame.size.height;
//        _inputContainer.frame = inputContainerFrame;
//        _replyText.frame = CGRectMake(10, 5, _inputContainer.frame.size.width - 75 , _inputContainer.frame.size.height - 10);
//        
//        [TKUtil setHeight:_inputInerContainer To:newHeight-2*6];
//       
//        [TKUtil setHeight:_inputField To:CGRectGetHeight(_inputInerContainer.frame)];
//        
//    }
}

- (void)growingTextViewDidChange:(TKGrowingTextView *)growingTextView
{
    [self updatePlaceholderVisibility:[growingTextView.internalTextView isFirstResponder]];
}

- (BOOL)growingTextViewShouldReturn:(TKGrowingTextView *)growingTextView
{
    [self chatTitleSenddButtonClicked:nil];
    return YES;
}

- (BOOL)growingTextViewShouldBeginEditing:(TKGrowingTextView *)growingTextView
{
    _iReplyText.hidden = YES;
    return YES;
}
- (BOOL)growingTextViewShouldEndEditing:(TKGrowingTextView *)growingTextView
{
    return YES;
}

@end
