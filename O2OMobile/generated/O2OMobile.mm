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

#import "O2OMobile.h"
#import "AppConfig.h"

#pragma mark - CERTIFICATION

@implementation CERTIFICATION

@synthesize id = _id;
@synthesize name = _name;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - COMMENT

@implementation COMMENT

@synthesize content = _content;
@synthesize created_at = _created_at;
@synthesize id = _id;
@synthesize rank = _rank;
@synthesize user = _user;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - CONFIG

@implementation CONFIG

@synthesize push = _push;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - CONTENT

@implementation CONTENT

@synthesize link = _link;
@synthesize photo = _photo;
@synthesize text = _text;
@synthesize video = _video;
@synthesize voice = _voice;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - LOCATION

@implementation LOCATION

@synthesize lat = _lat;
@synthesize lon = _lon;
@synthesize name = _name;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - MESSAGE

@implementation MESSAGE

@synthesize content = _content;
@synthesize created_at = _created_at;
@synthesize is_readed = _is_readed;
@synthesize order_id = _order_id;
@synthesize type = _type;
@synthesize url = _url;
@synthesize user = _user;
@synthesize id = _id;

- (BOOL)validate
{
	if ( nil == self.id || NO == [self.id isKindOfClass:[NSNumber class]] )
	{
		return NO;
	}

	return YES;
}

@end

#pragma mark - MY_CERTIFICATION

@implementation MY_CERTIFICATION

@synthesize certification = _certification;
@synthesize id = _id;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - MY_SERVICE

@implementation MY_SERVICE

@synthesize id = _id;
@synthesize price = _price;
@synthesize service_type = _service_type;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - ORDER_INFO

@implementation ORDER_INFO

@synthesize appointment_time = _appointment_time;
@synthesize content = _content;
@synthesize created_at = _created_at;
@synthesize duration = _duration;
@synthesize employee = _employee;
@synthesize employee_comment = _employee_comment;
@synthesize employer = _employer;
@synthesize employer_comment = _employer_comment;
@synthesize id = _id;
@synthesize location = _location;
@synthesize offer_price = _offer_price;
@synthesize order_sn = _order_sn;
@synthesize order_status = _order_status;
@synthesize push_number = _push_number;
@synthesize service_type = _service_type;
@synthesize transaction_price = _transaction_price;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - ORDER_RECORD

@implementation ORDER_RECORD

@synthesize active = _active;
@synthesize created_at = _created_at;
@synthesize id = _id;
@synthesize note = _note;
@synthesize order_action = _order_action;
@synthesize user = _user;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - PHOTO

@implementation PHOTO

@synthesize height = _height;
@synthesize large = _large;
@synthesize thumb = _thumb;
@synthesize width = _width;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - PUSH_MESSAGE

@implementation PUSH_MESSAGE

@synthesize content = _content;
@synthesize order_id = _order_id;
@synthesize type = _type;
@synthesize url = _url;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - SERVICE_CATEGORY

@implementation SERVICE_CATEGORY

@synthesize father_id = _father_id;
@synthesize id = _id;
@synthesize title = _title;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - SERVICE_TYPE

@implementation SERVICE_TYPE

@synthesize icon = _icon;
@synthesize id = _id;
@synthesize large_icon = _large_icon;
@synthesize title = _title;
@synthesize isSelected = _isSelected;
@synthesize showBottomLine = _showBottomLine;
@synthesize showRightLine = _showRightLine;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - SIMPLE_USER

@implementation SIMPLE_USER

@synthesize avatar = _avatar;
@synthesize comment_count = _comment_count;
@synthesize comment_goodrate = _comment_goodrate;
@synthesize current_service_price = _current_service_price;
@synthesize gender = _gender;
@synthesize id = _id;
@synthesize joined_at = _joined_at;
@synthesize location = _location;
@synthesize mobile_phone = _mobile_phone;
@synthesize nickname = _nickname;
@synthesize user_group = _user_group;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - USER

@implementation USER

@synthesize avatar = _avatar;
@synthesize brief = _brief;
@synthesize comment_count = _comment_count;
@synthesize comment_goodrate = _comment_goodrate;
@synthesize current_service_price = _current_service_price;
@synthesize gender = _gender;
@synthesize id = _id;
@synthesize joined_at = _joined_at;
@synthesize location = _location;
@synthesize mobile_phone = _mobile_phone;
@synthesize my_certification = _my_certification;
@synthesize nickname = _nickname;
@synthesize signature = _signature;
@synthesize user_group = _user_group;

CONVERT_PROPERTY_CLASS( my_certification, MY_CERTIFICATION );

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - WITHDRAW_ORDER

@implementation WITHDRAW_ORDER

@synthesize amount = _amount;
@synthesize created_at = _created_at;
@synthesize state = _state;
@synthesize id = _id;

- (BOOL)validate
{
	if ( nil == self.id || NO == [self.id isKindOfClass:[NSNumber class]] )
	{
		return NO;
	}

	return YES;
}

@end

#pragma mark - POST /comment/list

#pragma mark - REQ_COMMENT_LIST

@implementation REQ_COMMENT_LIST

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize user = _user;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_COMMENT_LIST

@implementation RESP_COMMENT_LIST

@synthesize comments = _comments;
@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( comments, COMMENT );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_COMMENT_LIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_COMMENT_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/comment/list"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_COMMENT_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /comment/send

#pragma mark - REQ_COMMENT_SEND

@implementation REQ_COMMENT_SEND

@synthesize content = _content;
@synthesize order_id = _order_id;
@synthesize rank = _rank;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_COMMENT_SEND

@implementation RESP_COMMENT_SEND

@synthesize comment = _comment;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_COMMENT_SEND

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_COMMENT_SEND alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/comment/send"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_COMMENT_SEND objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /feedback

#pragma mark - REQ_FEEDBACK

@implementation REQ_FEEDBACK

@synthesize content = _content;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_FEEDBACK

@implementation RESP_FEEDBACK

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_FEEDBACK

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_FEEDBACK alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/feedback"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_FEEDBACK objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /location/info

#pragma mark - REQ_LOCATION_INFO

@implementation REQ_LOCATION_INFO

@synthesize lat = _lat;
@synthesize lon = _lon;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_LOCATION_INFO

@implementation RESP_LOCATION_INFO

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize location = _location;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_LOCATION_INFO

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_LOCATION_INFO alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/location/info"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_LOCATION_INFO objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /message/list

#pragma mark - REQ_MESSAGE_LIST

@implementation REQ_MESSAGE_LIST

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_MESSAGE_LIST

@implementation RESP_MESSAGE_LIST

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize messages = _messages;
@synthesize more = _more;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( messages, MESSAGE );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_MESSAGE_LIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_MESSAGE_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/message/list"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_MESSAGE_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /message/read

#pragma mark - REQ_MESSAGE_READ

@implementation REQ_MESSAGE_READ

@synthesize message = _message;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_MESSAGE_READ

@implementation RESP_MESSAGE_READ

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_MESSAGE_READ

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_MESSAGE_READ alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/message/read"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_MESSAGE_READ objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /message/syslist

#pragma mark - REQ_MESSAGE_SYSLIST

@implementation REQ_MESSAGE_SYSLIST

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_MESSAGE_SYSLIST

@implementation RESP_MESSAGE_SYSLIST

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize messages = _messages;
@synthesize more = _more;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( messages, MESSAGE );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_MESSAGE_SYSLIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_MESSAGE_SYSLIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/message/syslist"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_MESSAGE_SYSLIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /message/unread-count

#pragma mark - REQ_MESSAGE_UNREAD_COUNT

@implementation REQ_MESSAGE_UNREAD_COUNT

@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_MESSAGE_UNREAD_COUNT

@implementation RESP_MESSAGE_UNREAD_COUNT

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;
@synthesize unread = _unread;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_MESSAGE_UNREAD_COUNT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_MESSAGE_UNREAD_COUNT alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/message/unread-count"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_MESSAGE_UNREAD_COUNT objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /myservice/list

#pragma mark - REQ_MYSERVICE_LIST

@implementation REQ_MYSERVICE_LIST

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize user = _user;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_MYSERVICE_LIST

@implementation RESP_MYSERVICE_LIST

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize services = _services;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( services, MY_SERVICE );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_MYSERVICE_LIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_MYSERVICE_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/myservice/list"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_MYSERVICE_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /myservice/modify

#pragma mark - REQ_MYSERVICE_MODIFY

@implementation REQ_MYSERVICE_MODIFY

@synthesize price = _price;
@synthesize service_id = _service_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_MYSERVICE_MODIFY

@implementation RESP_MYSERVICE_MODIFY

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize service = _service;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_MYSERVICE_MODIFY

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_MYSERVICE_MODIFY alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/myservice/modify"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_MYSERVICE_MODIFY objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/accept

#pragma mark - REQ_ORDER_ACCEPT

@implementation REQ_ORDER_ACCEPT

@synthesize order_id = _order_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_ACCEPT

@implementation RESP_ORDER_ACCEPT

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_ACCEPT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_ACCEPT alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/accept"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_ACCEPT objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/cancel

#pragma mark - REQ_ORDER_CANCEL

@implementation REQ_ORDER_CANCEL

@synthesize order_id = _order_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_CANCEL

@implementation RESP_ORDER_CANCEL

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_CANCEL

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_CANCEL alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/cancel"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_CANCEL objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/confirm-pay

#pragma mark - REQ_ORDER_CONFIRM_PAY

@implementation REQ_ORDER_CONFIRM_PAY

@synthesize order_id = _order_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_CONFIRM_PAY

@implementation RESP_ORDER_CONFIRM_PAY

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_CONFIRM_PAY

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_CONFIRM_PAY alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/confirm-pay"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_CONFIRM_PAY objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/history

#pragma mark - REQ_ORDER_HISTORY

@implementation REQ_ORDER_HISTORY

@synthesize order_id = _order_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_HISTORY

@implementation RESP_ORDER_HISTORY

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize history = _history;
@synthesize succeed = _succeed;

CONVERT_PROPERTY_CLASS( history, ORDER_RECORD );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_HISTORY

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_HISTORY alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/history"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_HISTORY objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/info

#pragma mark - REQ_ORDER_INFO

@implementation REQ_ORDER_INFO

@synthesize order_id = _order_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_INFO

@implementation RESP_ORDER_INFO

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_INFO

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_INFO alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/info"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_INFO objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/pay

#pragma mark - REQ_ORDER_PAY

@implementation REQ_ORDER_PAY

@synthesize order_id = _order_id;
@synthesize pay_code = _pay_code;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_PAY

@implementation RESP_ORDER_PAY

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;
@synthesize trade_sn = _trade_sn;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_PAY

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_PAY alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/pay"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_PAY objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/publish

#pragma mark - REQ_ORDER_PUBLISH

@implementation REQ_ORDER_PUBLISH

@synthesize content = _content;
@synthesize default_receiver_id = _default_receiver_id;
@synthesize duration = _duration;
@synthesize location = _location;
@synthesize offer_price = _offer_price;
@synthesize service_type_id = _service_type_id;
@synthesize sid = _sid;
@synthesize start_time = _start_time;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_PUBLISH

@implementation RESP_ORDER_PUBLISH

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_PUBLISH

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_PUBLISH alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/publish"];
		NSString * requestBody = [self.req objectToString];

        if ( self.req.content.voice )
        {
            NSData * voice = [AudioManager audioWithName:self.req.content.voice];
            self.HTTP_POST( requestURI )
            .PARAM( @"json", requestBody )
            .FILE( @"voice", voice )
            .TIMEOUT( 120 );
        }
        else
        {
            self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
        }
        
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_PUBLISH objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /order/work-done

#pragma mark - REQ_ORDER_WORK_DONE

@implementation REQ_ORDER_WORK_DONE

@synthesize order_id = _order_id;
@synthesize sid = _sid;
@synthesize transaction_price = _transaction_price;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDER_WORK_DONE

@implementation RESP_ORDER_WORK_DONE

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize order_info = _order_info;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDER_WORK_DONE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDER_WORK_DONE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/order/work-done"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDER_WORK_DONE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /orderlist/around

#pragma mark - REQ_ORDERLIST_AROUND

@implementation REQ_ORDERLIST_AROUND

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize location = _location;
@synthesize sid = _sid;
@synthesize sort_by = _sort_by;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDERLIST_AROUND

@implementation RESP_ORDERLIST_AROUND

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize orders = _orders;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( orders, ORDER_INFO );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDERLIST_AROUND

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDERLIST_AROUND alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/orderlist/around"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDERLIST_AROUND objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /orderlist/published

#pragma mark - REQ_ORDERLIST_PUBLISHED

@implementation REQ_ORDERLIST_PUBLISHED

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize published_order = _published_order;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDERLIST_PUBLISHED

@implementation RESP_ORDERLIST_PUBLISHED

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize orders = _orders;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( orders, ORDER_INFO );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDERLIST_PUBLISHED

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDERLIST_PUBLISHED alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/orderlist/published"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDERLIST_PUBLISHED objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /orderlist/received

#pragma mark - REQ_ORDERLIST_RECEIVED

@implementation REQ_ORDERLIST_RECEIVED

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize sid = _sid;
@synthesize taked_order = _taked_order;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_ORDERLIST_RECEIVED

@implementation RESP_ORDERLIST_RECEIVED

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize orders = _orders;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( orders, ORDER_INFO );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_ORDERLIST_RECEIVED

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_ORDERLIST_RECEIVED alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/orderlist/received"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_ORDERLIST_RECEIVED objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /push/switch

#pragma mark - REQ_PUSH_SWITCH

@implementation REQ_PUSH_SWITCH

@synthesize UUID = _UUID;
@synthesize push_switch = _push_switch;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_PUSH_SWITCH

@implementation RESP_PUSH_SWITCH

@synthesize config = _config;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PUSH_SWITCH

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_PUSH_SWITCH alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/push/switch"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PUSH_SWITCH objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /push/update

#pragma mark - REQ_PUSH_UPDATE

@implementation REQ_PUSH_UPDATE

@synthesize UUID = _UUID;
@synthesize location = _location;
@synthesize platform = _platform;
@synthesize sid = _sid;
@synthesize token = _token;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_PUSH_UPDATE

@implementation RESP_PUSH_UPDATE

@synthesize config = _config;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_PUSH_UPDATE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_PUSH_UPDATE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/push/update"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_PUSH_UPDATE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /report

#pragma mark - REQ_REPORT

@implementation REQ_REPORT

@synthesize content = _content;
@synthesize order_id = _order_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize user = _user;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_REPORT

@implementation RESP_REPORT

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_REPORT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_REPORT alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/report"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_REPORT objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /servicecategory/list

#pragma mark - REQ_SERVICECATEGORY_LIST

@implementation REQ_SERVICECATEGORY_LIST

@synthesize service_category_id = _service_category_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_SERVICECATEGORY_LIST

@implementation RESP_SERVICECATEGORY_LIST

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize servicecategorys = _servicecategorys;
@synthesize succeed = _succeed;

CONVERT_PROPERTY_CLASS( servicecategorys, SERVICE_CATEGORY );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_SERVICECATEGORY_LIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_SERVICECATEGORY_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

            self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/servicecategory/list"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_SERVICECATEGORY_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /servicetype/list

#pragma mark - REQ_SERVICETYPE_LIST

@implementation REQ_SERVICETYPE_LIST

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_SERVICETYPE_LIST

@implementation RESP_SERVICETYPE_LIST

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize services = _services;
@synthesize succeed = _succeed;
@synthesize total = _total;

CONVERT_PROPERTY_CLASS( services, SERVICE_TYPE );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_SERVICETYPE_LIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_SERVICETYPE_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/servicetype/list"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_SERVICETYPE_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/apply-service

#pragma mark - REQ_USER_APPLY_SERVICE

@implementation REQ_USER_APPLY_SERVICE

@synthesize firstclass_service_category_id = _firstclass_service_category_id;
@synthesize secondclass_service_category_id = _secondclass_service_category_id;
@synthesize service_type_id = _service_type_id;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_APPLY_SERVICE

@implementation RESP_USER_APPLY_SERVICE

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_APPLY_SERVICE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_APPLY_SERVICE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/apply-service"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_APPLY_SERVICE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/balance

#pragma mark - REQ_USER_BALANCE

@implementation REQ_USER_BALANCE

@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_BALANCE

@implementation RESP_USER_BALANCE

@synthesize balance = _balance;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_BALANCE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_BALANCE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/balance"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_BALANCE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/certify

#pragma mark - REQ_USER_CERTIFY

@implementation REQ_USER_CERTIFY

@synthesize avatar = _avatar;
@synthesize avatarImage = _avatarImage;
@synthesize bankcard = _bankcard;
@synthesize gender = _gender;
@synthesize identity_card = _identity_card;
@synthesize name = _name;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_CERTIFY

@implementation RESP_USER_CERTIFY

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_CERTIFY

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_CERTIFY alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		UIImage * avatarImage = [self.req.avatarImage retain];
		self.req.avatarImage = nil;
		
		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/certify"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody ).FILE_PNG_ALIAS( @"avatar", avatarImage, self.req.avatar );

		[avatarImage release];
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_CERTIFY objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/change-avatar

#pragma mark - REQ_USER_CHANGE_AVATAR

@implementation REQ_USER_CHANGE_AVATAR

@synthesize avatar = _avatar;
@synthesize avatarImage = _avatarImage;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_CHANGE_AVATAR

@implementation RESP_USER_CHANGE_AVATAR

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;
@synthesize user = _user;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_CHANGE_AVATAR

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_CHANGE_AVATAR alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		UIImage * avatarImage = [self.req.avatarImage retain];
		self.req.avatarImage = nil;
		
		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/change-avatar"];
		NSString * requestBody = [self.req objectToString];
		
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody ).FILE_PNG_ALIAS( @"avatar", avatarImage, self.req.avatar );

		[avatarImage release];
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_CHANGE_AVATAR objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/change-password

#pragma mark - REQ_USER_CHANGE_PASSWORD

@implementation REQ_USER_CHANGE_PASSWORD

@synthesize new_password = _new_password;
@synthesize old_password = _old_password;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_CHANGE_PASSWORD

@implementation RESP_USER_CHANGE_PASSWORD

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_CHANGE_PASSWORD

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_CHANGE_PASSWORD alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/change-password"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_CHANGE_PASSWORD objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/change-profile

#pragma mark - REQ_USER_CHANGE_PROFILE

@implementation REQ_USER_CHANGE_PROFILE

@synthesize brief = _brief;
@synthesize nickname = _nickname;
@synthesize sid = _sid;
@synthesize signature = _signature;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_CHANGE_PROFILE

@implementation RESP_USER_CHANGE_PROFILE

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;
@synthesize user = _user;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_CHANGE_PROFILE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_CHANGE_PROFILE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/change-profile"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_CHANGE_PROFILE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/invite-code

#pragma mark - REQ_USER_INVITE_CODE

@implementation REQ_USER_INVITE_CODE

@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_INVITE_CODE

@implementation RESP_USER_INVITE_CODE

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize invite_code = _invite_code;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_INVITE_CODE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_INVITE_CODE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/invite-code"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_INVITE_CODE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/list

#pragma mark - REQ_USER_LIST

@implementation REQ_USER_LIST

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize location = _location;
@synthesize service_type = _service_type;
@synthesize sid = _sid;
@synthesize sort_by = _sort_by;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_LIST

@implementation RESP_USER_LIST

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize succeed = _succeed;
@synthesize total = _total;
@synthesize users = _users;

CONVERT_PROPERTY_CLASS( users, SIMPLE_USER );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_LIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/list"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/profile

#pragma mark - REQ_USER_PROFILE

@implementation REQ_USER_PROFILE

@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize user = _user;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_PROFILE

@implementation RESP_USER_PROFILE

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;
@synthesize user = _user;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_PROFILE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_PROFILE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/profile"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_PROFILE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/signin

#pragma mark - REQ_USER_SIGNIN

@implementation REQ_USER_SIGNIN

@synthesize UUID = _UUID;
@synthesize location = _location;
@synthesize mobile_phone = _mobile_phone;
@synthesize password = _password;
@synthesize platform = _platform;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_SIGNIN

@implementation RESP_USER_SIGNIN

@synthesize config = _config;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize sid = _sid;
@synthesize succeed = _succeed;
@synthesize user = _user;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_SIGNIN

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_SIGNIN alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/signin"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_SIGNIN objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/signout

#pragma mark - REQ_USER_SIGNOUT

@implementation REQ_USER_SIGNOUT

@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_SIGNOUT

@implementation RESP_USER_SIGNOUT

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_SIGNOUT

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_SIGNOUT alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

                self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/signout"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_SIGNOUT objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/signup

#pragma mark - REQ_USER_SIGNUP

@implementation REQ_USER_SIGNUP

@synthesize invite_code = _invite_code;
@synthesize location = _location;
@synthesize mobile_phone = _mobile_phone;
@synthesize nickname = _nickname;
@synthesize password = _password;
@synthesize platform = _platform;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_SIGNUP

@implementation RESP_USER_SIGNUP

@synthesize config = _config;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize sid = _sid;
@synthesize succeed = _succeed;
@synthesize uid = _uid;
@synthesize user = _user;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_SIGNUP

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_SIGNUP alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/signup"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_SIGNUP objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/validcode

#pragma mark - REQ_USER_VALIDCODE

@implementation REQ_USER_VALIDCODE

@synthesize mobile_phone = _mobile_phone;
@synthesize ver = _ver;
@synthesize verify_code = _verify_code;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_VALIDCODE

@implementation RESP_USER_VALIDCODE

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_VALIDCODE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_VALIDCODE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/validcode"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_VALIDCODE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /user/verifycode

#pragma mark - REQ_USER_VERIFYCODE

@implementation REQ_USER_VERIFYCODE

@synthesize mobile_phone = _mobile_phone;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_USER_VERIFYCODE

@implementation RESP_USER_VERIFYCODE

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;
@synthesize verify_code = _verify_code;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_USER_VERIFYCODE

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_USER_VERIFYCODE alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/user/verifycode"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_USER_VERIFYCODE objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /withdraw/list

#pragma mark - REQ_WITHDRAW_LIST

@implementation REQ_WITHDRAW_LIST

@synthesize by_id = _by_id;
@synthesize by_no = _by_no;
@synthesize count = _count;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_WITHDRAW_LIST

@implementation RESP_WITHDRAW_LIST

@synthesize count = _count;
@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize more = _more;
@synthesize succeed = _succeed;
@synthesize total = _total;
@synthesize withdraws = _withdraws;

CONVERT_PROPERTY_CLASS( withdraws, WITHDRAW_ORDER );

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_WITHDRAW_LIST

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_WITHDRAW_LIST alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/withdraw/list"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_WITHDRAW_LIST objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - POST /withdraw/money

#pragma mark - REQ_WITHDRAW_MONEY

@implementation REQ_WITHDRAW_MONEY

@synthesize amount = _amount;
@synthesize sid = _sid;
@synthesize uid = _uid;
@synthesize ver = _ver;

- (BOOL)validate
{
	return YES;
}

@end

#pragma mark - RESP_WITHDRAW_MONEY

@implementation RESP_WITHDRAW_MONEY

@synthesize error_code = _error_code;
@synthesize error_desc = _error_desc;
@synthesize succeed = _succeed;

- (BOOL)validate
{
	return YES;
}

@end

@implementation API_WITHDRAW_MONEY

@synthesize req = _req;
@synthesize resp = _resp;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.req = [[[REQ_WITHDRAW_MONEY alloc] init] autorelease];
		self.resp = nil;
	}
	return self;
}

- (void)dealloc
{
	self.req = nil;
	self.resp = nil;
	[super dealloc];
}

- (void)routine
{
	if ( self.sending )
	{
		if ( nil == self.req || NO == [self.req validate] )
		{
			self.failed = YES;
			return;
		}

		self.req.ver = API_VERSION;

		NSString * requestURI = [[ServerConfig sharedInstance].url stringByAppendingString:@"/withdraw/money"];
		NSString * requestBody = [self.req objectToString];
		self.HTTP_POST( requestURI ).PARAM( @"json", requestBody );
	}
	else if ( self.succeed )
	{
		NSObject * result = self.responseJSON;

		if ( result && [result isKindOfClass:[NSDictionary class]] )
		{
			self.resp = [RESP_WITHDRAW_MONEY objectFromDictionary:(NSDictionary *)result];
		}

		if ( nil == self.resp || NO == [self.resp validate] )
		{
			self.failed = YES;
			return;
		}
	}
	else if ( self.failed )
	{
		// TODO:
	}
	else if ( self.cancelled )
	{
		// TODO:
	}
}
@end

#pragma mark - config

@implementation ServerConfig

DEF_SINGLETON( ServerConfig )

DEF_INT( CONFIG_DEVELOPMENT,	0 )
DEF_INT( CONFIG_TEST,			1 )
DEF_INT( CONFIG_PRODUCTION,	2 )

@synthesize config = _config;
@dynamic url;
@dynamic testUrl;
@dynamic productionUrl;
@dynamic developmentUrl;

- (NSString *)shareUrl
{
	if ( self.CONFIG_DEVELOPMENT == self.config )
	{
        return [NSString stringWithFormat:@"%@/share/order",APP_DEVELOPMENT_API_URL];
	}

    return [NSString stringWithFormat:@"%@/share/order",APP_PRODUCT_API_URL];
}

- (NSString *)url
{
	NSString * host = nil;

	if ( self.CONFIG_DEVELOPMENT == self.config )
	{
		host = self.developmentUrl;
	}
	else if ( self.CONFIG_TEST == self.config )
	{
		host = self.testUrl;
	}
	else
	{
		host = self.productionUrl;
	}

	if ( NO == [host hasPrefix:@"http://"] && NO == [host hasPrefix:@"https://"] )
	{
		host = [@"http://" stringByAppendingString:host];
	}

	return host;
}

- (NSString *)developmentUrl
{
	return [NSString stringWithFormat:@"%@/api",APP_DEVELOPMENT_API_URL];
}

- (NSString *)testUrl
{
	return [NSString stringWithFormat:@"%@/api",APP_TEST_API_URL];
}

- (NSString *)productionUrl
{
	return [NSString stringWithFormat:@"%@/api",APP_PRODUCT_API_URL];
}

- (NSString *)webUrl
{
	if ( self.CONFIG_DEVELOPMENT == self.config )
	{
		return APP_DEVELOPMENT_API_URL;
	}
	else if ( self.CONFIG_TEST == self.config )
	{
		return APP_TEST_API_URL;
	}
	else
	{
		return APP_PRODUCT_API_URL;
	}
}

@end

