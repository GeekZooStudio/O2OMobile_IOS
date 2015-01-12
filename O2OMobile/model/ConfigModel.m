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

#import "ConfigModel.h"
#import "model.h"

#pragma mark -

DEF_EXTERNAL( ConfigModel, configModel );

#pragma mark -

@interface ConfigModel()
{
	BOOL _isAirplaying;
}

@end

@implementation ConfigModel

DEF_SINGLETON( ConfigModel );

DEF_SIGNAL( SWITCH_LOADING );
DEF_SIGNAL( SWITCH_SUCCEED );
DEF_SIGNAL( SWITCH_FAILED );

- (void)load
{
    [self loadCache];
	
	[self observeNotification:UIScreenDidDisconnectNotification];
	[self observeNotification:UIScreenDidConnectNotification];
}

- (void)unload
{
	[self unobserveNotification:UIScreenDidDisconnectNotification];
	[self unobserveNotification:UIScreenDidConnectNotification];
	
    [self saveCache];
}

- (void)loadCache
{
    self.config = [CONFIG objectFromDictionary:[[self userDefaultsRead:[self configKey]] objectFromJSONString]];
}

- (void)saveCache
{
    [self userDefaultsWrite:[self.config objectToString] forKey:[self configKey]];
}

- (NSString *)configKey
{
    return [NSString stringWithFormat:@"ConfigModel-%@", bee.ext.userModel.user.id];
}

- (BOOL)isPushEnable
{
    if ( !self.config )
    {
        return YES;
    }
    else
    {
        return [self.config.push boolValue];
    }
}

- (void)pushSwitch:(NSNumber *)push_switch
{
    [API_PUSH_SWITCH cancel:self];
    
	API_PUSH_SWITCH * api = [API_PUSH_SWITCH apiWithResponder:self];
	
	@weakify(api);

    api.req.uid         = bee.ext.userModel.user.id;
    api.req.sid         = bee.ext.userModel.sid;
    api.req.UUID        = [BeeSystemInfo deviceUUID];
    api.req.push_switch = push_switch;
    
    api.whenUpdate = ^
    {
		@normalize(api);

        if ( api.sending )
        {
            [self sendUISignal:self.SWITCH_LOADING];
        }
        else
        {
            if ( api.succeed && api.resp.succeed.boolValue )
            {
                self.config = api.resp.config;
                [self saveCache];
				
				[self sendUISignal:self.SWITCH_SUCCEED];
            }
            else
            {
                [self sendUISignal:self.SWITCH_FAILED];
            }
        }
    };
    
    [api send];
}

- (void)updateWithDeviceToke:(NSString *)deviceToken
{
	if ( !deviceToken || !deviceToken.length )
		return;
	
    [API_PUSH_UPDATE cancel:self];
	
	API_PUSH_UPDATE * api = [API_PUSH_UPDATE apiWithResponder:self];
	
	@weakify(api);

    api.req.uid      = bee.ext.userModel.user.id;
    api.req.sid      = bee.ext.userModel.sid;
    api.req.UUID     = [BeeSystemInfo deviceUUID];
    api.req.platform = @"ios";
    api.req.token    = deviceToken;
    api.req.location = [LocationModel sharedInstance].location;
    
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
                self.config = api.resp.config;
				
                [self saveCache];
            }
        }
    };
    
    [api send];
}

#pragma mark - airplay

ON_NOTIFICATION( notification )
{
	if ( [notification is:UIScreenDidConnectNotification] )
	{
		_isAirplaying = YES;
	}
	else if ( [notification is:UIScreenDidDisconnectNotification] )
	{
		_isAirplaying = NO;
	}
}

- (BOOL)isAirplaying
{
	return _isAirplaying;
}

@end
