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

#import "OrderPublishModel.h"

#pragma mark -

@implementation OrderData

@synthesize service_type = _service_type;
@synthesize receiver = _receiver;
@synthesize price = _price;
@synthesize time = _time;
@synthesize content = _content;
@synthesize duration = _duration;
@synthesize location = _location;

- (id)init
{
    if ( self = [super init] )
    {
        self.service_type = [[[SERVICE_TYPE alloc] init] autorelease];
        self.content = [[[CONTENT alloc] init] autorelease];
        self.content.text = @"";
        self.content.voice = @"";
        self.location = [[[LOCATION alloc] init] autorelease];
    }
    
    return self;
}

- (void)load
{
    
}

- (void)unload
{
    self.content = nil;
}

@end

@implementation OrderPublishModel

DEF_SIGNAL( ORDER_PUBLISHING )
DEF_SIGNAL( ORDER_PUBLISH_SUCCEED )
DEF_SIGNAL( ORDER_PUBLISH_FAILED )

- (void)publish:(OrderData *)orderData
{
    [API_ORDER_PUBLISH cancel];
    
    API_ORDER_PUBLISH * api = [API_ORDER_PUBLISH apiWithResponder:self];
    
    @weakify(api);
    
    api.req.sid = bee.ext.userModel.sid;
	api.req.uid = bee.ext.userModel.user.id;
    
    api.req.service_type_id = orderData.service_type.id;
    api.req.default_receiver_id = orderData.receiver;
    api.req.offer_price = orderData.price;
    api.req.start_time = [orderData.time stringWithDateFormat:@"yyyy/MM/dd HH:mm"];
    api.req.content = orderData.content;
    api.req.duration = orderData.duration;
    api.req.location = [LocationModel sharedInstance].location;
    
    api.whenUpdate = ^
    {
		@normalize(api);
        
        if ( api.sending )
		{
			[self sendUISignal:self.ORDER_PUBLISHING];
		}
		else
        {
            if ( api.succeed  && api.resp.succeed.boolValue )
            {
                self.order = api.resp.order_info;
                
                [self sendUISignal:self.ORDER_PUBLISH_SUCCEED];
            }
            else
            {
                [self sendUISignal:self.ORDER_PUBLISH_FAILED withObject:api.resp.error_desc];
            }
        }
    };
    
    [api send];
}

@end
