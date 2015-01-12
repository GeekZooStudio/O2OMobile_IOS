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

#import "Bee.h"

#pragma mark - enums

enum ERROR_CODE
{
	ERROR_CODE_OK = 0,
	ERROR_CODE_UNKNOWN_ERROR = 1,
	ERROR_CODE_SESSION_EXPIRED = 2,
};

enum MESSAGE_TYPE
{
	MESSAGE_TYPE_SYSTEM = 1,
	MESSAGE_TYPE_ORDER = 2,
	MESSAGE_TYPE_OTHER = 3,
};

enum ORDER_ACTION
{
	ORDER_ACTION_OA_PUBLISH = 0,
	ORDER_ACTION_OA_KNOCK_DOWN = 1,
	ORDER_ACTION_OA_WORK_DONE = 2,
	ORDER_ACTION_OA_PAY = 3,
	ORDER_ACTION_OA_PAY_CONFIRM = 4,
	ORDER_ACTION_OA_EMPLOYEE_COMMENTED = 5,
	ORDER_ACTION_OA_EMPLOYER_COMMENTED = 6,
	ORDER_ACTION_OA_FINISHED = 7,
	ORDER_ACTION_OA_CANCEL = 8,
};

enum ORDER_STATUS
{
	ORDER_STATUS_OS_PUBLISHED = 0,
	ORDER_STATUS_OS_KNOCK_DOWN = 1,
	ORDER_STATUS_OS_WORK_DONE = 2,
	ORDER_STATUS_OS_PAYED = 3,
	ORDER_STATUS_OS_PAY_CONFORMED = 4,
	ORDER_STATUS_OS_EMPLOYEE_COMMENTED = 5,
	ORDER_STATUS_OS_EMPLOYER_COMMENTED = 6,
	ORDER_STATUS_OS_FINISHED = 7,
	ORDER_STATUS_OS_CANCELED = 8,
};

enum PAY_CODE
{
	PAY_CODE_PAY_ONLINE = 0,
	PAY_CODE_PAY_OFFLINE = 1,
};

enum PUBLISHED_ORDER_STATE
{
	PUBLISHED_ORDER_STATE_PUBLISHED_ORDER_UNDONE = 0,
	PUBLISHED_ORDER_STATE_PUBLISHED_ORDER_DONE = 1,
	PUBLISHED_ORDER_STATE_PUBLISHED_ORDER_ALL = 2,
};

enum SEARCH_ORDER
{
	SEARCH_ORDER_price_desc = 0,
	SEARCH_ORDER_price_asc = 1,
	SEARCH_ORDER_time_desc = 2,
	SEARCH_ORDER_location_asc = 3,
	SEARCH_ORDER_rank_desc = 4,
	SEARCH_ORDER_rank_asc = 5,
};

enum TAKED_ORDER_STATE
{
	TAKED_ORDER_STATE_TAKED_ORDER_TENDER = 0,
	TAKED_ORDER_STATE_TAKED_ORDER_UNDONE = 1,
	TAKED_ORDER_STATE_TAKED_ORDER_DONE = 2,
	TAKED_ORDER_STATE_TAKED_ORDER_ALL = 3,
};

enum USER_GENDER
{
	USER_GENDER_MAN = 0,
	USER_GENDER_WOMAN = 1,
};

enum USER_GROUP
{
	USER_GROUP_NEWBEE = 0,
	USER_GROUP_FREEMAN_INREVIEW = 1,
	USER_GROUP_FREEMAN = 2,
};

enum WITHDRAW_STATE
{
	WITHDRAW_STATE_Processing = 0,
	WITHDRAW_STATE_WITHDRAW_SUCC = 1,
	WITHDRAW_STATE_WITHDRAW_FAILED = 2,
};

#pragma mark - models

@class CERTIFICATION;
@class COMMENT;
@class CONFIG;
@class CONTENT;
@class LOCATION;
@class MESSAGE;
@class MY_CERTIFICATION;
@class MY_SERVICE;
@class ORDER_INFO;
@class ORDER_RECORD;
@class PHOTO;
@class PUSH_MESSAGE;
@class SERVICE_CATEGORY;
@class SERVICE_TYPE;
@class SIMPLE_USER;
@class USER;
@class WITHDRAW_ORDER;

@interface CERTIFICATION : BeeActiveObject
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			name;
@end

@interface COMMENT : BeeActiveObject
@property (nonatomic, retain) CONTENT *			content;
@property (nonatomic, retain) NSString *			created_at;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSNumber *			rank;
@property (nonatomic, retain) SIMPLE_USER *			user;
@end

@interface CONFIG : BeeActiveObject
@property (nonatomic, retain) NSNumber *			push;
@end

@interface CONTENT : BeeActiveObject
@property (nonatomic, retain) NSString *			link;
@property (nonatomic, retain) PHOTO *			photo;
@property (nonatomic, retain) NSString *			text;
@property (nonatomic, retain) NSString *			video;
@property (nonatomic, retain) NSString *			voice;
@end

@interface LOCATION : BeeActiveObject
@property (nonatomic, retain) NSNumber *			lat;
@property (nonatomic, retain) NSNumber *			lon;
@property (nonatomic, retain) NSString *			name;
@end

@interface MESSAGE : BeeActiveObject
@property (nonatomic, retain) NSString *			content;
@property (nonatomic, retain) NSString *			created_at;
@property (nonatomic, retain) NSNumber *			is_readed;
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSNumber *			type;
@property (nonatomic, retain) NSString *			url;
@property (nonatomic, retain) SIMPLE_USER *			user;
@property (nonatomic, retain) NSNumber *			id;
@end

@interface MY_CERTIFICATION : BeeActiveObject
@property (nonatomic, retain) CERTIFICATION *			certification;
@property (nonatomic, retain) NSNumber *			id;
@end

@interface MY_SERVICE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			price;
@property (nonatomic, retain) SERVICE_TYPE *			service_type;
@end

@interface ORDER_INFO : BeeActiveObject
@property (nonatomic, retain) NSString *			appointment_time;
@property (nonatomic, retain) NSString *			accept_time;
@property (nonatomic, retain) CONTENT *			content;
@property (nonatomic, retain) NSString *			created_at;
@property (nonatomic, retain) NSNumber *			duration;
@property (nonatomic, retain) SIMPLE_USER *			employee;
@property (nonatomic, retain) COMMENT *			employee_comment;
@property (nonatomic, retain) SIMPLE_USER *			employer;
@property (nonatomic, retain) COMMENT *			employer_comment;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			offer_price;
@property (nonatomic, retain) NSString *			order_sn;
@property (nonatomic, retain) NSNumber *			order_status;
@property (nonatomic, retain) NSNumber *			push_number;
@property (nonatomic, retain) SERVICE_TYPE *			service_type;
@property (nonatomic, retain) NSString *			transaction_price;
@end

@interface ORDER_RECORD : BeeActiveObject
@property (nonatomic, retain) NSNumber *			active;
@property (nonatomic, retain) NSString *			created_at;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			note;
@property (nonatomic, retain) NSNumber *			order_action;
@property (nonatomic, retain) SIMPLE_USER *			user;
@end

@interface PHOTO : BeeActiveObject
@property (nonatomic, retain) NSNumber *			height;
@property (nonatomic, retain) NSString *			large;
@property (nonatomic, retain) NSString *			thumb;
@property (nonatomic, retain) NSNumber *			width;
@end

@interface PUSH_MESSAGE : BeeActiveObject
@property (nonatomic, retain) NSString *			content;
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSNumber *			type;
@property (nonatomic, retain) NSString *			url;
@end

@interface SERVICE_CATEGORY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			father_id;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			title;
@end

@interface SERVICE_TYPE : BeeActiveObject
@property (nonatomic, retain) NSString *			icon;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			large_icon;
@property (nonatomic, retain) NSString *			title;
@property (nonatomic, assign)  BOOL 			isSelected;
@property (nonatomic, assign)  BOOL 			showBottomLine;
@property (nonatomic, assign)  BOOL 			showRightLine;
@end

@interface SIMPLE_USER : BeeActiveObject
@property (nonatomic, retain) PHOTO *			avatar;
@property (nonatomic, retain) NSNumber *			comment_count;
@property (nonatomic, retain) NSString *			comment_goodrate;
@property (nonatomic, retain) NSString *			current_service_price;
@property (nonatomic, retain) NSNumber *			gender;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			joined_at;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			mobile_phone;
@property (nonatomic, retain) NSString *			nickname;
@property (nonatomic, retain) NSNumber *			user_group;
@end

@interface USER : BeeActiveObject
@property (nonatomic, retain) PHOTO *			avatar;
@property (nonatomic, retain) NSString *			brief;
@property (nonatomic, retain) NSNumber *			comment_count;
@property (nonatomic, retain) NSString *			comment_goodrate;
@property (nonatomic, retain) NSString *			current_service_price;
@property (nonatomic, retain) NSNumber *			gender;
@property (nonatomic, retain) NSNumber *			id;
@property (nonatomic, retain) NSString *			joined_at;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			mobile_phone;
@property (nonatomic, retain) NSArray *				my_certification;
@property (nonatomic, retain) NSString *			nickname;
@property (nonatomic, retain) NSString *			signature;
@property (nonatomic, retain) NSNumber *			user_group;
@end

@interface WITHDRAW_ORDER : BeeActiveObject
@property (nonatomic, retain) NSNumber *			amount;
@property (nonatomic, retain) NSString *			created_at;
@property (nonatomic, retain) NSNumber *			state;
@property (nonatomic, retain) NSNumber *			id;
@end

#pragma mark - controllers

#pragma mark - POST /comment/list

@interface REQ_COMMENT_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			user;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_COMMENT_LIST : BeeActiveObject
@property (nonatomic, retain) NSArray *				comments;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_COMMENT_LIST : BeeAPI
@property (nonatomic, retain) REQ_COMMENT_LIST *	req;
@property (nonatomic, retain) RESP_COMMENT_LIST *	resp;
@end

#pragma mark - POST /comment/send

@interface REQ_COMMENT_SEND : BeeActiveObject
@property (nonatomic, retain) CONTENT *			content;
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSNumber *			rank;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_COMMENT_SEND : BeeActiveObject
@property (nonatomic, retain) COMMENT *			comment;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_COMMENT_SEND : BeeAPI
@property (nonatomic, retain) REQ_COMMENT_SEND *	req;
@property (nonatomic, retain) RESP_COMMENT_SEND *	resp;
@end

#pragma mark - POST /feedback

@interface REQ_FEEDBACK : BeeActiveObject
@property (nonatomic, retain) CONTENT *			content;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_FEEDBACK : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_FEEDBACK : BeeAPI
@property (nonatomic, retain) REQ_FEEDBACK *	req;
@property (nonatomic, retain) RESP_FEEDBACK *	resp;
@end

#pragma mark - POST /location/info

@interface REQ_LOCATION_INFO : BeeActiveObject
@property (nonatomic, retain) NSNumber *			lat;
@property (nonatomic, retain) NSNumber *			lon;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_LOCATION_INFO : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_LOCATION_INFO : BeeAPI
@property (nonatomic, retain) REQ_LOCATION_INFO *	req;
@property (nonatomic, retain) RESP_LOCATION_INFO *	resp;
@end

#pragma mark - POST /message/list

@interface REQ_MESSAGE_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_MESSAGE_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSArray *				messages;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_MESSAGE_LIST : BeeAPI
@property (nonatomic, retain) REQ_MESSAGE_LIST *	req;
@property (nonatomic, retain) RESP_MESSAGE_LIST *	resp;
@end

#pragma mark - POST /message/read

@interface REQ_MESSAGE_READ : BeeActiveObject
@property (nonatomic, retain) NSNumber *			message;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_MESSAGE_READ : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_MESSAGE_READ : BeeAPI
@property (nonatomic, retain) REQ_MESSAGE_READ *	req;
@property (nonatomic, retain) RESP_MESSAGE_READ *	resp;
@end

#pragma mark - POST /message/syslist

@interface REQ_MESSAGE_SYSLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_MESSAGE_SYSLIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSArray *				messages;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_MESSAGE_SYSLIST : BeeAPI
@property (nonatomic, retain) REQ_MESSAGE_SYSLIST *	req;
@property (nonatomic, retain) RESP_MESSAGE_SYSLIST *	resp;
@end

#pragma mark - POST /message/unread-count

@interface REQ_MESSAGE_UNREAD_COUNT : BeeActiveObject
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_MESSAGE_UNREAD_COUNT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			unread;
@end

@interface API_MESSAGE_UNREAD_COUNT : BeeAPI
@property (nonatomic, retain) REQ_MESSAGE_UNREAD_COUNT *	req;
@property (nonatomic, retain) RESP_MESSAGE_UNREAD_COUNT *	resp;
@end

#pragma mark - POST /myservice/list

@interface REQ_MYSERVICE_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			user;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_MYSERVICE_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSArray *				services;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_MYSERVICE_LIST : BeeAPI
@property (nonatomic, retain) REQ_MYSERVICE_LIST *	req;
@property (nonatomic, retain) RESP_MYSERVICE_LIST *	resp;
@end

#pragma mark - POST /myservice/modify

@interface REQ_MYSERVICE_MODIFY : BeeActiveObject
@property (nonatomic, retain) NSString *			price;
@property (nonatomic, retain) NSNumber *			service_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_MYSERVICE_MODIFY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) MY_SERVICE *			service;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_MYSERVICE_MODIFY : BeeAPI
@property (nonatomic, retain) REQ_MYSERVICE_MODIFY *	req;
@property (nonatomic, retain) RESP_MYSERVICE_MODIFY *	resp;
@end

#pragma mark - POST /order/accept

@interface REQ_ORDER_ACCEPT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_ACCEPT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_ORDER_ACCEPT : BeeAPI
@property (nonatomic, retain) REQ_ORDER_ACCEPT *	req;
@property (nonatomic, retain) RESP_ORDER_ACCEPT *	resp;
@end

#pragma mark - POST /order/cancel

@interface REQ_ORDER_CANCEL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_CANCEL : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_ORDER_CANCEL : BeeAPI
@property (nonatomic, retain) REQ_ORDER_CANCEL *	req;
@property (nonatomic, retain) RESP_ORDER_CANCEL *	resp;
@end

#pragma mark - POST /order/confirm-pay

@interface REQ_ORDER_CONFIRM_PAY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_CONFIRM_PAY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_ORDER_CONFIRM_PAY : BeeAPI
@property (nonatomic, retain) REQ_ORDER_CONFIRM_PAY *	req;
@property (nonatomic, retain) RESP_ORDER_CONFIRM_PAY *	resp;
@end

#pragma mark - POST /order/history

@interface REQ_ORDER_HISTORY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_HISTORY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSArray *				history;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_ORDER_HISTORY : BeeAPI
@property (nonatomic, retain) REQ_ORDER_HISTORY *	req;
@property (nonatomic, retain) RESP_ORDER_HISTORY *	resp;
@end

#pragma mark - POST /order/info

@interface REQ_ORDER_INFO : BeeActiveObject
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_INFO : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_ORDER_INFO : BeeAPI
@property (nonatomic, retain) REQ_ORDER_INFO *	req;
@property (nonatomic, retain) RESP_ORDER_INFO *	resp;
@end

#pragma mark - POST /order/pay

@interface REQ_ORDER_PAY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSNumber *			pay_code;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_PAY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSString *			trade_sn;
@end

@interface API_ORDER_PAY : BeeAPI
@property (nonatomic, retain) REQ_ORDER_PAY *	req;
@property (nonatomic, retain) RESP_ORDER_PAY *	resp;
@end

#pragma mark - POST /order/publish

@interface REQ_ORDER_PUBLISH : BeeActiveObject
@property (nonatomic, retain) CONTENT *			content;
@property (nonatomic, retain) NSNumber *			default_receiver_id;
@property (nonatomic, retain) NSNumber *			duration;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			offer_price;
@property (nonatomic, retain) NSNumber *			service_type_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSString *			start_time;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_PUBLISH : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_ORDER_PUBLISH : BeeAPI
@property (nonatomic, retain) REQ_ORDER_PUBLISH *	req;
@property (nonatomic, retain) RESP_ORDER_PUBLISH *	resp;
@end

#pragma mark - POST /order/work-done

@interface REQ_ORDER_WORK_DONE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSString *			transaction_price;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDER_WORK_DONE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) ORDER_INFO *			order_info;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_ORDER_WORK_DONE : BeeAPI
@property (nonatomic, retain) REQ_ORDER_WORK_DONE *	req;
@property (nonatomic, retain) RESP_ORDER_WORK_DONE *	resp;
@end

#pragma mark - POST /orderlist/around

@interface REQ_ORDERLIST_AROUND : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			sort_by;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDERLIST_AROUND : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSArray *				orders;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_ORDERLIST_AROUND : BeeAPI
@property (nonatomic, retain) REQ_ORDERLIST_AROUND *	req;
@property (nonatomic, retain) RESP_ORDERLIST_AROUND *	resp;
@end

#pragma mark - POST /orderlist/published

@interface REQ_ORDERLIST_PUBLISHED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			published_order;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDERLIST_PUBLISHED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSArray *				orders;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_ORDERLIST_PUBLISHED : BeeAPI
@property (nonatomic, retain) REQ_ORDERLIST_PUBLISHED *	req;
@property (nonatomic, retain) RESP_ORDERLIST_PUBLISHED *	resp;
@end

#pragma mark - POST /orderlist/received

@interface REQ_ORDERLIST_RECEIVED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			taked_order;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_ORDERLIST_RECEIVED : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSArray *				orders;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_ORDERLIST_RECEIVED : BeeAPI
@property (nonatomic, retain) REQ_ORDERLIST_RECEIVED *	req;
@property (nonatomic, retain) RESP_ORDERLIST_RECEIVED *	resp;
@end

#pragma mark - POST /push/switch

@interface REQ_PUSH_SWITCH : BeeActiveObject
@property (nonatomic, retain) NSString *			UUID;
@property (nonatomic, retain) NSNumber *			push_switch;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_PUSH_SWITCH : BeeActiveObject
@property (nonatomic, retain) CONFIG *			config;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_PUSH_SWITCH : BeeAPI
@property (nonatomic, retain) REQ_PUSH_SWITCH *	req;
@property (nonatomic, retain) RESP_PUSH_SWITCH *	resp;
@end

#pragma mark - POST /push/update

@interface REQ_PUSH_UPDATE : BeeActiveObject
@property (nonatomic, retain) NSString *			UUID;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			platform;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSString *			token;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_PUSH_UPDATE : BeeActiveObject
@property (nonatomic, retain) CONFIG *			config;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_PUSH_UPDATE : BeeAPI
@property (nonatomic, retain) REQ_PUSH_UPDATE *	req;
@property (nonatomic, retain) RESP_PUSH_UPDATE *	resp;
@end

#pragma mark - POST /report

@interface REQ_REPORT : BeeActiveObject
@property (nonatomic, retain) CONTENT *			content;
@property (nonatomic, retain) NSNumber *			order_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			user;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_REPORT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_REPORT : BeeAPI
@property (nonatomic, retain) REQ_REPORT *	req;
@property (nonatomic, retain) RESP_REPORT *	resp;
@end

#pragma mark - POST /servicecategory/list

@interface REQ_SERVICECATEGORY_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			service_category_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_SERVICECATEGORY_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSArray *				servicecategorys;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_SERVICECATEGORY_LIST : BeeAPI
@property (nonatomic, retain) REQ_SERVICECATEGORY_LIST *	req;
@property (nonatomic, retain) RESP_SERVICECATEGORY_LIST *	resp;
@end

#pragma mark - POST /servicetype/list

@interface REQ_SERVICETYPE_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_SERVICETYPE_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSArray *				services;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@end

@interface API_SERVICETYPE_LIST : BeeAPI
@property (nonatomic, retain) REQ_SERVICETYPE_LIST *	req;
@property (nonatomic, retain) RESP_SERVICETYPE_LIST *	resp;
@end

#pragma mark - POST /user/apply-service

@interface REQ_USER_APPLY_SERVICE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			firstclass_service_category_id;
@property (nonatomic, retain) NSNumber *			secondclass_service_category_id;
@property (nonatomic, retain) NSNumber *			service_type_id;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_APPLY_SERVICE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_USER_APPLY_SERVICE : BeeAPI
@property (nonatomic, retain) REQ_USER_APPLY_SERVICE *	req;
@property (nonatomic, retain) RESP_USER_APPLY_SERVICE *	resp;
@end

#pragma mark - POST /user/balance

@interface REQ_USER_BALANCE : BeeActiveObject
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_BALANCE : BeeActiveObject
@property (nonatomic, retain) NSString *			balance;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_USER_BALANCE : BeeAPI
@property (nonatomic, retain) REQ_USER_BALANCE *	req;
@property (nonatomic, retain) RESP_USER_BALANCE *	resp;
@end

#pragma mark - POST /user/certify

@interface REQ_USER_CERTIFY : BeeActiveObject
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) UIImage *				avatarImage;
@property (nonatomic, retain) NSString *			bankcard;
@property (nonatomic, retain) NSNumber *			gender;
@property (nonatomic, retain) NSString *			identity_card;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_CERTIFY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_USER_CERTIFY : BeeAPI
@property (nonatomic, retain) REQ_USER_CERTIFY *	req;
@property (nonatomic, retain) RESP_USER_CERTIFY *	resp;
@end

#pragma mark - POST /user/change-avatar

@interface REQ_USER_CHANGE_AVATAR : BeeActiveObject
@property (nonatomic, retain) NSString *			avatar;
@property (nonatomic, retain) UIImage *				avatarImage;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_CHANGE_AVATAR : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) USER *			user;
@end

@interface API_USER_CHANGE_AVATAR : BeeAPI
@property (nonatomic, retain) REQ_USER_CHANGE_AVATAR *	req;
@property (nonatomic, retain) RESP_USER_CHANGE_AVATAR *	resp;
@end

#pragma mark - POST /user/change-password

@interface REQ_USER_CHANGE_PASSWORD : BeeActiveObject
@property (nonatomic, retain) NSString *			new_password;
@property (nonatomic, retain) NSString *			old_password;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_CHANGE_PASSWORD : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_USER_CHANGE_PASSWORD : BeeAPI
@property (nonatomic, retain) REQ_USER_CHANGE_PASSWORD *	req;
@property (nonatomic, retain) RESP_USER_CHANGE_PASSWORD *	resp;
@end

#pragma mark - POST /user/change-profile

@interface REQ_USER_CHANGE_PROFILE : BeeActiveObject
@property (nonatomic, retain) NSString *			brief;
@property (nonatomic, retain) NSString *			nickname;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSString *			signature;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_CHANGE_PROFILE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) USER *			user;
@end

@interface API_USER_CHANGE_PROFILE : BeeAPI
@property (nonatomic, retain) REQ_USER_CHANGE_PROFILE *	req;
@property (nonatomic, retain) RESP_USER_CHANGE_PROFILE *	resp;
@end

#pragma mark - POST /user/invite-code

@interface REQ_USER_INVITE_CODE : BeeActiveObject
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_INVITE_CODE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSString *			invite_code;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_USER_INVITE_CODE : BeeAPI
@property (nonatomic, retain) REQ_USER_INVITE_CODE *	req;
@property (nonatomic, retain) RESP_USER_INVITE_CODE *	resp;
@end

#pragma mark - POST /user/list

@interface REQ_USER_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSNumber *			service_type;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			sort_by;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@property (nonatomic, retain) NSArray *				users;
@end

@interface API_USER_LIST : BeeAPI
@property (nonatomic, retain) REQ_USER_LIST *	req;
@property (nonatomic, retain) RESP_USER_LIST *	resp;
@end

#pragma mark - POST /user/profile

@interface REQ_USER_PROFILE : BeeActiveObject
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			user;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_PROFILE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) USER *			user;
@end

@interface API_USER_PROFILE : BeeAPI
@property (nonatomic, retain) REQ_USER_PROFILE *	req;
@property (nonatomic, retain) RESP_USER_PROFILE *	resp;
@end

#pragma mark - POST /user/signin

@interface REQ_USER_SIGNIN : BeeActiveObject
@property (nonatomic, retain) NSString *			UUID;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			mobile_phone;
@property (nonatomic, retain) NSString *			password;
@property (nonatomic, retain) NSString *			platform;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_SIGNIN : BeeActiveObject
@property (nonatomic, retain) CONFIG *			config;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) USER *			user;
@end

@interface API_USER_SIGNIN : BeeAPI
@property (nonatomic, retain) REQ_USER_SIGNIN *	req;
@property (nonatomic, retain) RESP_USER_SIGNIN *	resp;
@end

#pragma mark - POST /user/signout

@interface REQ_USER_SIGNOUT : BeeActiveObject
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_SIGNOUT : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_USER_SIGNOUT : BeeAPI
@property (nonatomic, retain) REQ_USER_SIGNOUT *	req;
@property (nonatomic, retain) RESP_USER_SIGNOUT *	resp;
@end

#pragma mark - POST /user/signup

@interface REQ_USER_SIGNUP : BeeActiveObject
@property (nonatomic, retain) NSString *			invite_code;
@property (nonatomic, retain) LOCATION *			location;
@property (nonatomic, retain) NSString *			mobile_phone;
@property (nonatomic, retain) NSString *			nickname;
@property (nonatomic, retain) NSString *			password;
@property (nonatomic, retain) NSString *			platform;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_SIGNUP : BeeActiveObject
@property (nonatomic, retain) CONFIG *			config;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) USER *			user;
@end

@interface API_USER_SIGNUP : BeeAPI
@property (nonatomic, retain) REQ_USER_SIGNUP *	req;
@property (nonatomic, retain) RESP_USER_SIGNUP *	resp;
@end

#pragma mark - POST /user/validcode

@interface REQ_USER_VALIDCODE : BeeActiveObject
@property (nonatomic, retain) NSString *			mobile_phone;
@property (nonatomic, retain) NSNumber *			ver;
@property (nonatomic, retain) NSString *			verify_code;
@end

@interface RESP_USER_VALIDCODE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_USER_VALIDCODE : BeeAPI
@property (nonatomic, retain) REQ_USER_VALIDCODE *	req;
@property (nonatomic, retain) RESP_USER_VALIDCODE *	resp;
@end

#pragma mark - POST /user/verifycode

@interface REQ_USER_VERIFYCODE : BeeActiveObject
@property (nonatomic, retain) NSString *			mobile_phone;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_USER_VERIFYCODE : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSString *			verify_code;
@end

@interface API_USER_VERIFYCODE : BeeAPI
@property (nonatomic, retain) REQ_USER_VERIFYCODE *	req;
@property (nonatomic, retain) RESP_USER_VERIFYCODE *	resp;
@end

#pragma mark - POST /withdraw/list

@interface REQ_WITHDRAW_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			by_id;
@property (nonatomic, retain) NSNumber *			by_no;
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_WITHDRAW_LIST : BeeActiveObject
@property (nonatomic, retain) NSNumber *			count;
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			more;
@property (nonatomic, retain) NSNumber *			succeed;
@property (nonatomic, retain) NSNumber *			total;
@property (nonatomic, retain) NSArray *				withdraws;
@end

@interface API_WITHDRAW_LIST : BeeAPI
@property (nonatomic, retain) REQ_WITHDRAW_LIST *	req;
@property (nonatomic, retain) RESP_WITHDRAW_LIST *	resp;
@end

#pragma mark - POST /withdraw/money

@interface REQ_WITHDRAW_MONEY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			amount;
@property (nonatomic, retain) NSString *			sid;
@property (nonatomic, retain) NSNumber *			uid;
@property (nonatomic, retain) NSNumber *			ver;
@end

@interface RESP_WITHDRAW_MONEY : BeeActiveObject
@property (nonatomic, retain) NSNumber *			error_code;
@property (nonatomic, retain) NSString *			error_desc;
@property (nonatomic, retain) NSNumber *			succeed;
@end

@interface API_WITHDRAW_MONEY : BeeAPI
@property (nonatomic, retain) REQ_WITHDRAW_MONEY *	req;
@property (nonatomic, retain) RESP_WITHDRAW_MONEY *	resp;
@end

#pragma mark - config

@interface ServerConfig : NSObject

AS_SINGLETON( ServerConfig )

AS_INT( CONFIG_DEVELOPMENT )
AS_INT( CONFIG_TEST )
AS_INT( CONFIG_PRODUCTION )

@property (nonatomic, assign) NSUInteger			config;

@property (nonatomic, readonly) NSString *			shareUrl;
@property (nonatomic, readonly) NSString *			url;
@property (nonatomic, readonly) NSString *			testUrl;
@property (nonatomic, readonly) NSString *			productionUrl;
@property (nonatomic, readonly) NSString *			developmentUrl;
@property (nonatomic, readonly) NSString *			webUrl;

@end

