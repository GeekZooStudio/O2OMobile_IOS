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

#import "AudioPlayer.h"
#import "AudioManager.h"
#import "OrderInfoModel.h"

@interface OrderInfoModel()
@property (nonatomic, retain) NSString * preaprePlay;
@end

@implementation OrderInfoModel

DEF_SIGNAL( ACCEPT_LOADING )
DEF_SIGNAL( DID_ACCEPT )
DEF_SIGNAL( DID_ACCEPT_FAIL )
DEF_SIGNAL( CANCEL_LOADING )
DEF_SIGNAL( DID_CANCEL )
DEF_SIGNAL( CONFIRM_PAY_LOADING )
DEF_SIGNAL( DID_CONFIRM_PAY )
DEF_SIGNAL( HISTORY_LOADING )
DEF_SIGNAL( DID_HISTORY )
DEF_SIGNAL( PAY_LOADING )
DEF_SIGNAL( DID_PAY )
DEF_SIGNAL( WORK_DONE_LOADING )
DEF_SIGNAL( DID_WORK_DONE )
DEF_SIGNAL( OPREATION_FAILED )

DEF_SIGNAL( LOADING_VOICE )
DEF_SIGNAL( DID_LOAD_VOICE )
DEF_SIGNAL( DID_LOAD_VOICE_FAIL )

- (void)load
{
    [self loadCache];
}

- (void)unload
{
}

- (void)loadCache
{
//    self.order = [self userDefaultsRead:@"order"];
//    
//    if ( self.order )
//    {
//        self.order = [ORDER_INFO objectFromDictionary:[[self userDefaultsRead:@"order"] objectFromJSONString]];
//    }
}

- (void)saveCache
{
//    [self userDefaultsWrite:[self.order objectToString] forKey:@"order"];
}

- (void)clearCache
{
//	[self userDefaultsRemove:@"order"];
    
//    self.order = nil;
}

#pragma mark - 

- (void)reload
{
    [API_ORDER_INFO cancel:self];
    
    API_ORDER_INFO * api = [API_ORDER_INFO apiWithResponder:self];
	
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
	api.req.order_id = self.order_id;
    
	api.whenUpdate = ^
	{
		@normalize(api);
        
		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{            
			if ( api.resp.order_info && api.succeed && api.resp.succeed.boolValue )
			{
				self.order = api.resp.order_info;
                
                self.loaded = (self.order && self.order.id) ? YES : NO;
                
				[self sendUISignal:self.RELOADED];
			}
			else
			{
				[self sendUISignal:self.RELOADED];
			}
		}
	};
	
	[api send];
}

// 接单
#pragma mark - POST /order/accept
- (void)accept
{
    [API_ORDER_ACCEPT cancel:self];
    API_ORDER_ACCEPT * api = [API_ORDER_ACCEPT apiWithResponder:self];
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.order_id = self.order_id;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.ACCEPT_LOADING];
        }
        else
        {
            if ( api.resp.order_info && api.succeed && api.resp.succeed.boolValue )
            {
                self.order = api.resp.order_info;
                [self sendUISignal:self.DID_ACCEPT];
            }    
            else
            {
                [self sendUISignal:self.DID_ACCEPT_FAIL withObject:api.resp.error_desc];
            }
        }
    };

    [api send];
}

// 取消订单
#pragma mark - POST /order/cancel
- (void)cancel
{
    [API_ORDER_CANCEL cancel:self];
    API_ORDER_CANCEL * api = [API_ORDER_CANCEL apiWithResponder:self];
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.order_id = self.order_id;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.CANCEL_LOADING];
        }
        else
        {
            if ( api.resp.order_info && api.succeed && api.resp.succeed.boolValue )
            {
                self.order = api.resp.order_info;
                [self sendUISignal:self.DID_CANCEL];
            }    
            else
            {
                [self sendUISignal:self.OPREATION_FAILED];
            }
        }
    };

    [api send];
}

// 确认付款
#pragma mark - POST /order/confirm-pay
- (void)confirm_pay
{
    [API_ORDER_CONFIRM_PAY cancel:self];
    API_ORDER_CONFIRM_PAY * api = [API_ORDER_CONFIRM_PAY apiWithResponder:self];
    
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.order_id = self.order_id;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.CONFIRM_PAY_LOADING];
        }
        else
        {
            if ( api.resp.order_info && api.succeed && api.resp.succeed.boolValue )
            {
                self.order = api.resp.order_info;
                [self sendUISignal:self.DID_CONFIRM_PAY];
            }    
            else
            {
                [self sendUISignal:self.OPREATION_FAILED];
            }
        }
    };

    [api send];
}

// 订单历史
#pragma mark - POST /order/history
- (void)history
{
    [API_ORDER_HISTORY cancel:self];
    API_ORDER_HISTORY * api = [API_ORDER_HISTORY apiWithResponder:self];
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.order_id = self.order_id;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.RELOADING];
        }
        else
        {
            if ( api.resp.history && api.succeed && api.resp.succeed.boolValue )
            {
                self.records = api.resp.history;
                [self sendUISignal:self.DID_HISTORY];
            }    
            else
            {
                [self sendUISignal:self.OPREATION_FAILED];
            }
        }
    };

    [api send];
}

// 订单详情
#pragma mark - POST /order/info
- (void)info
{
    [API_ORDER_INFO cancel:self];
    API_ORDER_INFO * api = [API_ORDER_INFO apiWithResponder:self];
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.order_id = self.order_id;
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.RELOADING];
        }
        else
        {
            if ( api.resp.order_info && api.succeed && api.resp.succeed.boolValue )
            {
                self.order = api.resp.order_info;
                [self sendUISignal:self.RELOADED];
            }    
            else
            {
                [self sendUISignal:self.RELOADED];
            }
        }
    };

    [api send];
}

// 付款
#pragma mark - POST /order/pay
- (void)payWithMode:(int)mode
{
    self.payMode = mode;
    
    [API_ORDER_PAY cancel:self];
    API_ORDER_PAY * api = [API_ORDER_PAY apiWithResponder:self];
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.order_id = self.order_id;
    api.req.pay_code = @(mode);
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.PAY_LOADING];
        }
        else
        {
            if ( api.resp.order_info && api.succeed && api.resp.succeed.boolValue )
            {
                self.order = api.resp.order_info;
                [self sendUISignal:self.DID_PAY withObject:api.resp.trade_sn
                 ];
            }    
            else
            {
                [self sendUISignal:self.OPREATION_FAILED];
            }
        }
    };

    [api send];
}

// 订单完成

#pragma mark - POST /order/work-done

- (void)workDoneWithPrice:(NSString *)price
{
    [API_ORDER_WORK_DONE cancel:self];
    API_ORDER_WORK_DONE * api = [API_ORDER_WORK_DONE apiWithResponder:self];
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    api.req.order_id = self.order_id;
    
    if ( price && price.length )
    {
        api.req.transaction_price = price;
    }
    
    api.whenUpdate = ^
    {
        @normalize(api);
        
        if ( api.sending )
        {
            [self sendUISignal:self.WORK_DONE_LOADING];
        }
        else
        {
            if ( api.resp.order_info && api.succeed && api.resp.succeed.boolValue )
            {
                self.order = api.resp.order_info;
                [self sendUISignal:self.DID_WORK_DONE];
            }    
            else
            {
                [self sendUISignal:self.OPREATION_FAILED];
            }
        }
    };

    [api send];
}

#pragma mark - voice

- (void)download:(NSString *)voice
{
    [self download:voice andPlay:NO];
}

- (void)download:(NSString *)voice andPlay:(BOOL)play
{
	self.preaprePlay = play ? voice : nil;
	
    NSString *	path = [AudioManager audioPathWithName:voice];
    
	BOOL returnValue = [[NSFileManager defaultManager] fileExistsAtPath:path];
	if ( NO == returnValue )
	{
		self.GET( voice ).SAVE_AS( path ).TIMEOUT( 20.0f ).userObject = voice;
	}
	else
	{
        [[AudioManager sharedInstance] play:voice];
        
        self.preaprePlay = nil;
	}
}

- (BOOL)downloading:(NSString *)voice
{
    return self.REQUESTING_URL(voice);
}

- (BOOL)downloaded:(NSString *)voice
{
    BOOL		isDirectory = NO;
    NSString *	path = [AudioManager audioPathWithName:voice];
	
	BOOL returnValue = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
	if ( NO == returnValue || YES == isDirectory )
		return NO;
    
	return YES;
}

#pragma mark -

- (void)handleRequest:(BeeHTTPRequest *)request
{
	if ( request.sending )
	{
		[self sendUISignal:self.LOADING_VOICE];
	}
	else if ( request.succeed )
    {
		NSString * msg = (NSString *)request.userObject;
		
		if ( msg == self.preaprePlay )
		{
            [[AudioManager sharedInstance] play:msg];
			self.preaprePlay = nil;
		}
        
		[self sendUISignal:self.DID_LOAD_VOICE];
    }
    else if ( request.failed )
    {
		[self sendUISignal:self.DID_LOAD_VOICE_FAIL];
    }
    else if ( request.cancelled )
    {
		[self sendUISignal:self.DID_LOAD_VOICE];
    }
}

@end
