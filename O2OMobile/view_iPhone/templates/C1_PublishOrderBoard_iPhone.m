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

#import "C1_PublishOrderBoard_iPhone.h"
#import "C1_PublishOrderCell_iPhone.h"
#import "C1_TypeFilterItemCell_iPhone.h"
#import "AudioPlayer.h"
#import "AudioRecorder.h"
#import "AudioManager.h"
#import "C2_OrderDistributeBoard_iPhone.h"
#import "DatePickerCell.h"

#pragma mark -

@interface C1_PublishOrderBoard_iPhone()
{
    C1_PublishOrderCell_iPhone * _cell;
}

@property (nonatomic, retain) DatePickerCell * datePickerCell;

@end

@implementation C1_PublishOrderBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( C1_PublishOrderTitleCell_iPhone, titleCell )
DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( C1_TypeFilterCell_iPhone, filter )

@synthesize uid = _uid;
@synthesize orderData = _orderData;

DEF_MODEL( LocationModel, locationModel )
DEF_MODEL( OrderPublishModel, orderPublishModel )
DEF_MODEL( ServiceTypeListModel, serviceTypeListModel )

- (void)load
{
    self.orderData = [[[OrderData alloc] init] autorelease];
    self.orderData.time = [[NSDate now] dateByAddingTimeInterval:300];
    
    self.locationModel = [LocationModel sharedInstance];
    [self.locationModel addObserver:self];
    
    self.orderPublishModel = [OrderPublishModel modelWithObserver:self];
    
    self.serviceTypeListModel = [ServiceTypeListModel modelWithObserver:self];
}

- (void)unload
{
    self.orderData = nil;
    
    [self.locationModel removeObserver:self];
    [self.locationModel cancelMessages];
    
    [self.orderPublishModel removeObserver:self];
    [self.orderPublishModel cancelMessages];
    self.orderPublishModel = nil;
    
    [self.serviceTypeListModel removeObserver:self];
    [self.serviceTypeListModel cancelMessages];
    self.serviceTypeListModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xFFFFFF );
    
    self.titleCell = [C1_PublishOrderTitleCell_iPhone cell];
    
    self.navigationBarShown = YES;
	self.navigationBarTitle = self.titleCell;
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
    
    @weakify(self);
    
    self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
	
	self.list.whenReloading = ^
	{
		@normalize(self);
		
		self.list.total = 1;
        
        BeeUIScrollItem * item = self.list.items[0];
        item.size = CGSizeMake( self.list.width, 504 );
        item.clazz = [C1_PublishOrderCell_iPhone class];
        item.data = self.orderData;
        item.insets = UIEdgeInsetsMake(0, 0, 0, 0);
        item.section = 0;
    };
    self.list.whenReloaded = ^
    {
        _cell = (C1_PublishOrderCell_iPhone *)((BeeUIScrollItem *)self.list.items[0]).view;
    };
    
    self.datePickerCell = [[DatePickerCell alloc] init];
    self.datePickerCell.frame = CGRectMake( 0, 0, self.width, 260 );
    self.datePickerCell.whenValueChanged = ^(NSDate * value)
    {
        @normalize(self);
        
        self.orderData.time = value;
    };
    self.datePickerCell.whenDone = ^(NSDate * value)
    {
        @normalize(self);
        
        self.orderData.time = value;
    };
    
    self.datePickerCell.whenCanceled = ^
    {
    };
    
    [self observeNotification:BeeUIKeyboard.SHOWN];
    [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self observeNotification:BeeUIKeyboard.HIDDEN];
    
    [self observeNotification:AudioRecorder.RECORDING];
    [self observeNotification:AudioRecorder.STOPPED];
    [self observeNotification:AudioRecorder.FAILED];
    
    [self observeNotification:AudioPlayer.PLAYING];
    [self observeNotification:AudioPlayer.STOPPED];
    [self observeNotification:AudioPlayer.FAILED];
}

ON_DELETE_VIEWS( signal )
{
    [self unobserveNotification:BeeUIKeyboard.SHOWN];
    [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
    [self unobserveNotification:BeeUIKeyboard.HIDDEN];
    
    [self unobserveNotification:AudioRecorder.RECORDING];
    [self unobserveNotification:AudioRecorder.STOPPED];
    [self unobserveNotification:AudioRecorder.FAILED];
    
    [self unobserveNotification:AudioPlayer.PLAYING];
    [self unobserveNotification:AudioPlayer.STOPPED];
    [self unobserveNotification:AudioPlayer.FAILED];
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.locationModel getLocationInfo];
    
    if ( self.uid.intValue )
    {
        self.filter.datas = self.serviceTypeListModel.services;
        if ( 0 == self.filter.datas.count )
        {
            [self.titleCell disableToggle];
            
            self.filter.hidden = YES;
        }
        else
        {
            [self.filter.itemList reloadData];
        }
    }
    else
    {
        if ( NO == self.serviceTypeListModel.loaded )
        {
            [self.serviceTypeListModel loadCache];
            [self.serviceTypeListModel firstPage];
        }
    }
    
    if ( self.orderData.service_type.id )
    {
        self.filter.currentServiceType = self.orderData.service_type.id;
        
        if ( self.orderData.service_type.title )
        {
            self.titleCell.title.text = self.orderData.service_type.title;
        }
    }
    
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [AudioManager removeAudioWithName:self.orderData.content.voice];
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    self.titleCell.expanded = NO;
    self.filter.expanded = NO;
    self.navigationBarRight = nil;
}

#pragma mark -

- (void)updateNavigationBarRight
{
    if ( self.filter.expanded )
    {
        self.navigationBarRight = [UIImage imageNamed:@"b2_close.png"];
    }
    else
    {
        self.navigationBarRight = nil;
    }
}

#pragma mark - C1_PublishOrderTitleCell_iPhone

ON_SIGNAL3( C1_PublishOrderTitleCell_iPhone, toggle, signal )
{
    self.filter.expanded = !self.filter.expanded;
    if ( self.filter.expanded )
    {
        [self resignFirstResponder];
    }
    
    [self updateNavigationBarRight];
}

#pragma mark - C1_TypeFilterItemCell_iPhone

ON_SIGNAL3( C1_TypeFilterItemCell_iPhone, mask, signal )
{
    SERVICE_TYPE * type = signal.sourceCell.data;
    
    self.orderData.service_type.id = type.id;
    
    self.titleCell.title.text = type.title;
    self.titleCell.expanded = NO;
    self.titleCell.RELAYOUT();
    
    self.filter.expanded = NO;
    
    [self updateNavigationBarRight];
}

#pragma mark - BeeUITextField

ON_SIGNAL3( C1_PublishOrderCell_iPhone, price, signal )
{
    BeeUITextField * input = (BeeUITextField *)signal.source;
    if ( [signal is:BeeUITextField.WILL_DEACTIVE] )
    {
        self.orderData.price = input.text.trim;
    }
    else if ( [signal is:BeeUITextField.RETURN] )
    {
        [self.view endEditing:YES];
    }
}

ON_SIGNAL3( C1_PublishOrderCell_iPhone, address, signal )
{
    BeeUITextField * input = (BeeUITextField *)signal.source;
    C1_PublishOrderCell_iPhone * cell = (C1_PublishOrderCell_iPhone * )signal.sourceCell;
    if ( [signal is:BeeUITextField.WILL_DEACTIVE] )
    {
        self.orderData.location.name = input.text.trim;
    }
    else if ( [signal is:BeeUITextField.RETURN] )
    {
        self.orderData.location.name = input.text.trim;
        [cell.note becomeFirstResponder];
    }
}

#pragma mark - BeeUITextView

ON_SIGNAL3( BeeUITextView, WILL_ACTIVE, signal )
{
    BeeUITextView * area = (BeeUITextView *)signal.source;
    area.returnKeyType = UIReturnKeyDone;
    
    float offsetY = 0.0;
    
    if ( [BeeSystemInfo isPhoneRetina4] )
    {
        offsetY = 0.0;
    }
    else
    {
        offsetY = area.frame.origin.y;
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.list setContentOffset:CGPointMake( 0, offsetY )];
    }];
}

ON_SIGNAL3( BeeUITextView, TEXT_CHANGED, signal )
{
}

ON_SIGNAL3( BeeUITextView, TEXT_OVERFLOW, signal )
{
}

ON_SIGNAL3( BeeUITextView, RETURN, signal )
{
    BeeUITextView * area = (BeeUITextView *)signal.source;
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.list setContentOffset:CGPointMake( 0, 0 )];
    }];
    
    [self.view endEditing:YES];
    
    self.orderData.content.text = area.text;
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

#pragma mark - C1_PublishOrderCell_iPhone

ON_SIGNAL3( C1_PublishOrderCell_iPhone, time_mask, signal )
{
    [self.view endEditing:YES];
    
    [self showDatePicker];
}

ON_SIGNAL3( C1_PublishOrderCell_iPhone, record, signal )
{
    [self.view endEditing:YES];
    
    BeeUIButton * button = (BeeUIButton *)signal.source;
    
    if ( button.selected )
    {
        if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
        {
            [[AudioManager sharedInstance] play:self.orderData.content.voice];
        }
    }
    else
    {
        if ( [signal is:BeeUIButton.TOUCH_DOWN] )
        {
            [[AudioPlayer sharedInstance] stop];
            
            [AudioRecorder sharedInstance].maxDuration = 30.0f;
            [[AudioRecorder sharedInstance] record];
            
            [self startRecord];
        }
        else if ( [signal is:BeeUIButton.DRAG_OUTSIDE] )
        {
            [self cancelRecord];
        }
        else if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
        {
            [[AudioRecorder sharedInstance] stop];
        }
        else if ( [signal is:BeeUIButton.TOUCH_UP_OUTSIDE] )
        {
            [[AudioRecorder sharedInstance] stop];
        }
        else if ( [signal is:BeeUIButton.TOUCH_UP_CANCEL] )
        {
            [[AudioRecorder sharedInstance] stop];
        }
    }
}

ON_SIGNAL3( C1_PublishOrderCell_iPhone, reset, signal )
{
    [self resetRecord];
}

ON_SIGNAL3( C1_PublishOrderCell_iPhone, publish, signal )
{
    [self publish];
}

#pragma mark - BeeUIDatePicker

ON_SIGNAL3( BeeUIDatePicker, CHANGED, signal )
{
    
}

ON_SIGNAL3( BeeUIDatePicker, CONFIRMED, signal )
{
    self.orderData.time = [signal.object objectForKey:@"date"];
    [self.list asyncReloadData];
}

- (void)showDatePicker
{
    [self.datePickerCell showInView:self.view];
}

#pragma mark -

ON_NOTIFICATION3( AudioRecorder, RECORDING, notification )
{
}

ON_NOTIFICATION3( AudioRecorder, STOPPED, notification )
{
	if ( [AudioRecorder sharedInstance].duration < 3000 )
    {
        [self presentFailureTips:__TEXT(@"record_time_too_short")];
        
        [self recordFailed];
    }
    else
    {
        NSData * amrData = [AudioRecorder sharedInstance].AMRData;
        self.orderData.content.voice = [NSString stringWithFormat:@"%@%@%lld", kTempAudioPrefix, [UserModel sharedInstance].user.id.stringValue,[NSDate timeStamp]];
        [AudioManager saveAudio:amrData name:self.orderData.content.voice];
        
        [self recordSucceed];
    }
}

ON_NOTIFICATION3( AudioRecorder, FAILED, notification )
{
	[self presentFailureTips:@"录音失败"];
}

ON_NOTIFICATION3( AudioPlayer, PLAYING, notification )
{
    [self startAudioPlay];
}

ON_NOTIFICATION3( AudioPlayer, STOPPED, notification )
{
    [self stopAudioPlay];
}

ON_NOTIFICATION3( AudioPlayer, FAILED, notification )
{
}

#pragma mark - record cycle

- (void)startRecord
{
    if ( nil == _cell )
        return;
    
    [_cell startRecord];
}

- (void)recordSucceed
{
    if ( nil == _cell )
        return;
    
    [_cell stopRecord];
    
    [_cell recordSucceed];
}

- (void)recordFailed
{
    if ( nil == _cell )
        return;
    
    [_cell stopRecord];
    
    [_cell recordFailed];
}

- (void)resetRecord
{
    [AudioManager removeAudioWithName:self.orderData.content.voice];
    
    if ( nil == _cell )
        return;
    
    [_cell resetRecord];
}

- (void)cancelRecord
{
    
}

#pragma mark - audio play

- (void)startAudioPlay
{
    if ( nil == _cell )
        return;
    
    [_cell startAudioPlay];
}

- (void)stopAudioPlay
{
    if ( nil == _cell )
        return;
    
    [_cell stopAudioPlay];
}

#pragma mark -

- (void)publish
{
    if ( nil == _cell )
        return;
    
    NSString * price = _cell.price.text.trim;
    NSString * time = _cell.time.text.trim;
    NSString * address = _cell.address.text.trim;
//    NSString * desc = _cell.note.text.trim;
    
    if ( nil == self.orderData.service_type.id )
    {
        [self presentFailureTips:__TEXT(@"select_service")];
        
        return;
    }
    
    if ( 0 == price.length )
    {
        [self presentFailureTips:@"价格不能为空"];
        
        [_cell.price becomeFirstResponder];
        
        return;
    }
    
    if ( 0 == time.length )
    {
        [self presentFailureTips:__TEXT(@"appoint_time")];
        
        [self showDatePicker];
        
        return;
    }
    
    if ( [self.orderData.time timeIntervalSinceNow] < 0 )
    {
        [self presentFailureTips:__TEXT(@"wrong_appoint_time_hint")];
        
        [self showDatePicker];
        
        return;
    }
    
    if ( 0 == address.length )
    {
        [self presentFailureTips:__TEXT(@"appoint_location_hint")];
        
        [_cell.address becomeFirstResponder];
        
        return;
    }
    
//    if ( 0 == desc.length )
//    {
//        [self presentFailureTips:@"描述不能为空"];
//        
//        [_cell.note becomeFirstResponder];
//        
//        return;
//    }
    self.orderData.receiver = self.uid;
    self.orderData.duration = [NSNumber numberWithDouble:([AudioRecorder sharedInstance].duration / 1000.0f)];
    [self.orderPublishModel publish:self.orderData];
}

#pragma mark - LocationModel

ON_SIGNAL3( LocationModel, GET_LOCATION_SUCCEED, signal )
{
    if ( self.locationModel.location )
    {
        self.orderData.location = self.locationModel.location;
    }
    
    [self.list asyncReloadData];
}

ON_SIGNAL3( LocationModel, GET_LOCATION_FAILED, signal )
{
    
}

#pragma mark - OrderPublishModel

ON_SIGNAL3( OrderPublishModel, ORDER_PUBLISHING, signal )
{
    [self presentLoadingTips:@"正在发布"];
}

ON_SIGNAL3( OrderPublishModel, ORDER_PUBLISH_SUCCEED, signal )
{
    [self dismissTips];
    [self.view.window presentSuccessTips:__TEXT(@"public_success")];
    
    if ( self.uid.intValue )
    {
        [self.stack popBoardAnimated:YES];
    }
    else
    {
        C2_OrderDistributeBoard_iPhone * board = [C2_OrderDistributeBoard_iPhone board];
        board.order = self.orderPublishModel.order;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( OrderPublishModel, ORDER_PUBLISH_FAILED, signal )
{
    [self dismissTips];
}

#pragma mark - ServiceTypeListModel

ON_SIGNAL3( ServiceTypeListModel, RELOADING, signal )
{
    
}

ON_SIGNAL3( ServiceTypeListModel, RELOADED, signal )
{
    self.filter.datas = self.serviceTypeListModel.services;
    [self.filter.itemList reloadData];
}

@end
