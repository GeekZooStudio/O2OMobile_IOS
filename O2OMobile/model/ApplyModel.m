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

#import "ApplyModel.h"

#pragma mark -

@implementation ApplyModel

DEF_SIGNAL( TYPE_UPDATING );
DEF_SIGNAL( TYPE_UPDATED );

DEF_SIGNAL( FIRST_UPDATING );
DEF_SIGNAL( FIRST_UPDATED );

DEF_SIGNAL( SECOND_UPDATING );
DEF_SIGNAL( SECOND_UPDATED );

DEF_SIGNAL( APPLY_REQUESTING );
DEF_SIGNAL( APPLY_SUCCEED );
DEF_SIGNAL( APPLY_FAILED );

@synthesize typeList;
@synthesize firstList;
@synthesize secondList;

@synthesize type;
@synthesize first;
@synthesize second;

- (void)load
{
}

- (void)unload
{
	self.typeList = nil;
	self.firstList = nil;
	self.secondList = nil;
	
	self.type = nil;
	self.first = nil;
	self.second = nil;
}

- (void)getTypeList
{
    [API_SERVICETYPE_LIST cancel:self];
    
	API_SERVICETYPE_LIST * api = [API_SERVICETYPE_LIST apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    
	api.req.by_no = @(0);
	api.req.count = @(9999);

    api.whenUpdate = ^
    {
		@normalize(api);

        if ( api.sending )
        {
			[self sendUISignal:self.TYPE_UPDATING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.typeList = api.resp.services;
            }

			[self sendUISignal:self.TYPE_UPDATED];
        }
    };

    [api send];
}

- (void)getFirstList
{
	[API_SERVICECATEGORY_LIST cancel:self];
    
	API_SERVICECATEGORY_LIST * api = [API_SERVICECATEGORY_LIST apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;

	api.req.service_category_id = self.type.id;

    api.whenUpdate = ^
    {
		@normalize(api);
		
        if ( api.sending )
        {
			[self sendUISignal:self.FIRST_UPDATING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.firstList = api.resp.servicecategorys;
            }
			
			[self sendUISignal:self.FIRST_UPDATED];
        }
    };
	
    [api send];
}

- (void)getSecondList
{
	[API_SERVICECATEGORY_LIST cancel:self];
    
	API_SERVICECATEGORY_LIST * api = [API_SERVICECATEGORY_LIST apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;
    
	api.req.service_category_id = self.first.id;

    api.whenUpdate = ^
    {
		@normalize(api);
		
        if ( api.sending )
        {
			[self sendUISignal:self.SECOND_UPDATING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				self.secondList = api.resp.servicecategorys;
            }

			[self sendUISignal:self.SECOND_UPDATED];
        }
    };
	
    [api send];
}

- (void)apply
{
	[API_USER_APPLY_SERVICE cancel:self];
    
	API_USER_APPLY_SERVICE * api = [API_USER_APPLY_SERVICE apiWithResponder:self];
    
	@weakify(api);
    
	api.req.sid = bee.ext.userModel.sid;
    api.req.uid = bee.ext.userModel.user.id;

	api.req.service_type_id = self.type.id;
	api.req.firstclass_service_category_id = self.first.id;
	api.req.secondclass_service_category_id = self.second.id;

    api.whenUpdate = ^
    {
		@normalize(api);
		
        if ( api.sending )
        {
			[self sendUISignal:self.APPLY_REQUESTING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
				[self sendUISignal:self.APPLY_SUCCEED];
            }
			else
			{
				[self sendUISignal:self.APPLY_FAILED];
			}
        }
    };
	
    [api send];
}

@end
