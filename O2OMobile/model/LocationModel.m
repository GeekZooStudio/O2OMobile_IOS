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

#import "LocationModel.h"
#import "model.h"
#import "bee.services.location.h"

#pragma mark -

@interface LocationModel ()
{
    LOCATION * _location;
}
@end

@implementation LocationModel

DEF_SIGNAL( GET_LOCATION_SUCCEED );
DEF_SIGNAL( GET_LOCATION_FAILED );

DEF_SINGLETON( LocationModel )

@dynamic location;

- (void)load
{
    _location = [[[LOCATION alloc] init] autorelease];
}

- (void)unload
{
	self.location = nil;
}

- (void)setLocation:(LOCATION *)location
{
    [location retain];
    [_location release];
    _location = location;
}

- (LOCATION *)location
{
    _location.lat = @(bee.services.location.location.coordinate.latitude);
	_location.lon = @(bee.services.location.location.coordinate.longitude);
    
    return _location;
}

- (void)getLocationInfo
{
    [API_LOCATION_INFO cancel:self];
    
	API_LOCATION_INFO * api = [API_LOCATION_INFO apiWithResponder:self];
    
	@weakify(api);
    
    api.req.lat = self.location.lat;
    api.req.lon = self.location.lon;
    
    api.whenUpdate = ^
    {
		@normalize(api);

        if ( api.sending )
        {
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
                self.location = api.resp.location;
                
                [self sendUISignal:self.GET_LOCATION_SUCCEED];
            }
            else
            {
                [self sendUISignal:self.GET_LOCATION_FAILED];
            }
        }
    };

    [api send];
}

@end
