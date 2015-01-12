//
//       _/_/_/                      _/            _/_/_/_/_/
//    _/          _/_/      _/_/    _/  _/              _/      _/_/      _/_/
//   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/              _/      _/    _/  _/    _/
//  _/    _/  _/        _/        _/  _/          _/        _/    _/  _/    _/
//   _/_/_/    _/_/_/    _/_/_/  _/    _/      _/_/_/_/_/    _/_/      _/_/
//
//
//  Copyright (c) 2015-2016, Geek Zoo Studio
//  http://www.geek-zoo.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "B1_SignupVerifyBoard_iPhone.h"
#import "B1_SignupVerifyCell_iPhone.h"
#import "B2_SignupBoard_iPhone.h"
#import "ErrorMsg.h"

#pragma mark -

@interface B1_SignupVerifyBoard_iPhone ()
{
    NSTimer * _timer;
    NSInteger _count;
    B1_SignupVerifyCell_iPhone * _cell;
}
@end

@implementation B1_SignupVerifyBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIScrollView, list )

DEF_MODEL( UserModel, userModel )

- (void)load
{
    self.userModel = [UserModel sharedInstance];
}

- (void)unload
{
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    @weakify(self);
    
    self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	self.list.whenReloading = ^
	{
		@normalize(self);
		
		self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.size = CGSizeMake( self.list.width, self.list.height );
        item.clazz = [B1_SignupVerifyCell_iPhone class];
        item.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        item.section = 0;
    };
    self.list.whenReloaded = ^
    {
        _cell = (B1_SignupVerifyCell_iPhone *)((BeeUIScrollItem *)self.list.items[0]).view;
    };
    
    [self observeNotification:BeeUIKeyboard.SHOWN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self observeNotification:BeeUIKeyboard.HIDDEN];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:BeeUIKeyboard.SHOWN];
    [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self unobserveNotification:BeeUIKeyboard.HIDDEN];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.list reloadData];
    
    [self.userModel addObserver:self];
    
    [self setStatus];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [self.userModel removeObserver:self];
    [self.userModel cancelMessages];
    
    [self stopTimer];
    [self.view endEditing:YES];
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
}

#pragma mark - BeeUITextField

ON_SIGNAL2( BeeUITextField, signal )
{
    if ( [signal is:BeeUITextField.RETURN] )
    {
        B1_SignupVerifyCell_iPhone * cell = (B1_SignupVerifyCell_iPhone * )signal.sourceCell;
        BeeUITextField * input = (BeeUITextField *)signal.source;
        
        if ( [cell.mobilePhone isFirstResponder] )
        {
            [cell.verifyCode becomeFirstResponder];
            return;
        }
		else if ( UIReturnKeyDone == input.returnKeyType )
        {
            [self.view endEditing:YES];
        }
    }
    else if ( [signal is:BeeUITextField.WILL_ACTIVE] )
    {
    }
}

ON_NOTIFICATION2( BeeUIKeyboard , notification )
{
    if ( [notification is:BeeUIKeyboard.SHOWN])
    {
        CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
        }];
    }
    else if ([notification is:BeeUIKeyboard.HEIGHT_CHANGED])
    {
        CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsMake( 0, 0, keyboardHeight, 0)];
        }];
    }
    else if ( [notification is:BeeUIKeyboard.HIDDEN] )
    {
        [UIView animateWithDuration:0.35f animations:^{
            [self.list setBaseInsets:UIEdgeInsetsZero];
        }];
    }
}

#pragma mark - B1_SignupVerifyCell_iPhone

ON_SIGNAL3( B1_SignupVerifyCell_iPhone, send, signal )
{
    [self.view endEditing:YES];
    [self getVerifyCode];
}

ON_SIGNAL3( B1_SignupVerifyCell_iPhone, next, signal )
{
    [self.view endEditing:YES];
    [self doVerify];
}

ON_SIGNAL3( B1_SignupVerifyCell_iPhone, signin, signal )
{
    [self.stack popBoardAnimated:YES];
}

#pragma mark -

- (void)startTimer
{
	[_timer invalidate];
	_timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                    target:self
                                                  selector:@selector(updateStatus)
                                                  userInfo:nil
                                                   repeats:YES];
    if ( nil == _cell )
        return;
    
    _cell.send.enabled = NO;
    _count = 60;
}

- (void)stopTimer
{
	[_timer invalidate];
	_timer = nil;
}

#pragma mark -

- (void)setStatus
{
    if ( nil == _cell )
        return;
    
    _cell.status.data = __TEXT(@"get_vetify_code");
    _cell.send.enabled = YES;
    _count = 60;
}

- (void)resetStatus
{
    if ( nil == _cell )
        return;
    
    _cell.status.data = __TEXT(@"get_verify_code_again");
    _cell.send.enabled = YES;
    _count = 60;
}

- (void)updateStatus
{
    if ( nil == _cell )
        return;

    _count--;
    if ( _count )
    {
        NSString * status = [NSString stringWithFormat:@"%d%@",_count,__TEXT(@"resend_after")];
        _cell.status.data = status;
        _cell.send.enabled = NO;
    }
    else
    {
        [self stopTimer];
        [self resetStatus];
    }
}

#pragma mark - 

- (void)getVerifyCode
{
    if ( nil == _cell )
        return;
    
    NSString * mobilePhone = _cell.mobilePhone.text.trim;
    
    if ( NO == [mobilePhone isMobilephone] )
    {
        [self presentMessageTips:__TEXT(@"wrong_mobile_phone")];
        
        _cell.mobilePhone.data = @"";
        [_cell.mobilePhone becomeFirstResponder];
        
        return;
    }
    
    [self presentMessageTips:@"验证码默认为：123456"];
    // 不获取手机验证码，使用默认验证码：123456
//    [self.userModel getVerifyCodeWithMobilePhone:mobilePhone];
}

- (void)doVerify
{
    if ( nil == _cell )
        return;
    
    NSString * mobilePhone = _cell.mobilePhone.text.trim;
    NSString * verifyCode = _cell.verifyCode.text.trim;
    
    if ( NO == [mobilePhone isMobilephone] )
    {
        [self presentMessageTips:__TEXT(@"wrong_mobile_phone")];
        
        _cell.mobilePhone.data = @"";
        [_cell.mobilePhone becomeFirstResponder];
        
        return;
    }
    
    if ( verifyCode.length == 0 )
    {
        [self presentMessageTips:__TEXT(@"please_input_verify_code")];
        
        _cell.verifyCode.data = @"";
        [_cell.verifyCode becomeFirstResponder];
        
        return;
    }
    
    // 不后台验证，使用默认验证码：123456
//    [self.userModel verifyWithMobilePhone:mobilePhone
//                               verifyCode:verifyCode];
    
    [self verifyDefaultCode];
}

- (void)verifyDefaultCode
{
    NSString * mobilePhone = _cell.mobilePhone.text.trim;
    NSString * verifyCode = _cell.verifyCode.text.trim;
    
    if ( [@"123456" isEqualToString:verifyCode] )
    {
        B2_SignupBoard_iPhone * board = [B2_SignupBoard_iPhone board];
        board.mobilePhone = mobilePhone;
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        [self presentFailureTips:@"使用默认验证码：123456"];
    }
}

#pragma mark - UserModel

ON_SIGNAL3( UserModel, GETTING_VERIFYCODE, signal )
{
    [self presentLoadingTips:@"正在获取..."];
}

ON_SIGNAL3( UserModel, GET_VERIFYCODE_SUCCEED, signal )
{
    [self dismissTips];
    
    if ( nil == _cell )
        return;
    
    _cell.next.enabled = YES;
    
    [self startTimer];
}

ON_SIGNAL3( UserModel, GET_VERIFYCODE_FAILED, signal )
{
    [self dismissTips];
    
    if ( nil == _cell )
        return;
    
    NSNumber * errorCode = signal.object;
    
    if ( ErrorMsgCodeMobileExists == errorCode.intValue )
    {
        [_cell.mobilePhone becomeFirstResponder];
    }
}

ON_SIGNAL3( UserModel, VERIFYING, signal )
{
    [self presentLoadingTips:@"正在验证..."];
}

ON_SIGNAL3( UserModel, VERIFY_SUCCEED, signal )
{
    [self dismissTips];
    
    if ( nil == _cell )
        return;
    
    NSString * mobilePhone = _cell.mobilePhone.text.trim;
    
    B2_SignupBoard_iPhone * board = [B2_SignupBoard_iPhone board];
    board.mobilePhone = mobilePhone;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( UserModel, VERIFY_FAILED, signal )
{
    [self dismissTips];
}

@end
