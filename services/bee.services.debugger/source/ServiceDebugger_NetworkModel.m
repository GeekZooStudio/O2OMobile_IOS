//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "ServiceDebugger_NetworkModel.h"
#import "ServiceDebugger_Unit.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@interface ServiceDebugger_NetworkModel()
{
	NSUInteger			_totalCount;
	
	NSUInteger			_sendLowerBound;
	NSUInteger			_sendUpperBound;
	NSUInteger			_recvLowerBound;
	NSUInteger			_recvUpperBound;

	NSUInteger			_uploadBegin;
	NSUInteger			_uploadBytes;

	NSUInteger			_downloadBegin;
	NSUInteger			_downloadBytes;
	
	NSMutableArray *	_sendPlots;
	NSMutableArray *	_recvPlots;
	
	NSMutableArray *	_history;
	NSUInteger			_bandWidth;
}
@end

#pragma mark -

@implementation ServiceDebugger_NetworkModel

@synthesize totalCount = _totalCount;
@dynamic concurrent;
@dynamic connections;

@synthesize sendLowerBound = _sendLowerBound;
@synthesize sendUpperBound = _sendUpperBound;
@synthesize recvLowerBound = _recvLowerBound;
@synthesize recvUpperBound = _recvUpperBound;

@synthesize sendPlots = _sendPlots;
@synthesize recvPlots = _recvPlots;

@synthesize uploadBytes = _uploadBytes;
@synthesize downloadBytes = _downloadBytes;

@synthesize history = _history;
@synthesize bandWidth = _bandWidth;

DEF_SINGLETON( ServiceDebugger_NetworkModel )

DEF_INT( BANDWIDTH_CURRENT,	0 )
DEF_INT( BANDWIDTH_GPRS,	1 )
DEF_INT( BANDWIDTH_EDGE,	2 )
DEF_INT( BANDWIDTH_3G,		3 )

- (void)load
{
//	[super load];

	_history = [[NSMutableArray alloc] init];

	_uploadBytes = 0;
	_downloadBytes = 0;

	_sendPlots = [[NSMutableArray alloc] init];
	[_sendPlots pushTail:[NSNumber numberWithInt:0]];

	_recvPlots = [[NSMutableArray alloc] init];
	[_recvPlots pushTail:[NSNumber numberWithInt:0]];

	_sendLowerBound = 0;
	_sendUpperBound = 256 * K;

	_recvLowerBound = 0;
	_recvUpperBound = 256 * K;

	[self observeTick];
}

- (void)unload
{
	[self unobserveTick];

	[_sendPlots removeAllObjects];
	[_sendPlots release];
	
	[_recvPlots removeAllObjects];
	[_recvPlots release];
	
	[_history removeAllObjects];
	[_history release];
	
//	[super unload];
}

- (NSUInteger)concurrent
{
	return [BeeRequestQueue sharedInstance].requests.count;
}

- (NSUInteger)connections
{
	NSUInteger conn = 0;
	
	for ( BeeSocket * sock in [BeeSocket sockets] )
	{
		if ( sock.connecting || sock.connected )
		{
			conn += 1;
		}
	}
	
	return conn;
}

ON_TICK( tick )
{
	struct ifaddrs * ifa_list = 0;
	struct ifaddrs * ifa = 0;
	
	if ( getifaddrs(&ifa_list) == -1 )
	{
		return;
	}
	
	uint32_t iBytes = 0;
	uint32_t oBytes = 0;
	
	uint32_t wifiIBytes = 0;
	uint32_t wifiOBytes = 0;
	
	uint32_t wwanIBytes = 0;
	uint32_t wwanOBytes = 0;

	struct timeval time = { 0 };
	
	for ( ifa = ifa_list; ifa; ifa = ifa->ifa_next )
	{
		if (AF_LINK != ifa->ifa_addr->sa_family)
			continue;
		
		if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
			continue;
		
		if (ifa->ifa_data == 0)
			continue;
		
		// Not a loopback device.
		// network flow
		if ( strncmp(ifa->ifa_name, "lo", 2) )
		{
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			iBytes += if_data->ifi_ibytes;
			oBytes += if_data->ifi_obytes;

			time = if_data->ifi_lastchange;
		}

		//wifi flow
		if ( 0 == strcmp(ifa->ifa_name, "en0") )
		{
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			wifiIBytes += if_data->ifi_ibytes;
			wifiOBytes += if_data->ifi_obytes;
		}

		//3G and gprs flow
		if ( 0 == strcmp(ifa->ifa_name, "pdp_ip0") )
		{
			struct if_data *if_data = (struct if_data *)ifa->ifa_data;
			
			wwanIBytes += if_data->ifi_ibytes;
			wwanOBytes += if_data->ifi_obytes;
		}
	}
	
	freeifaddrs( ifa_list );

	if ( 0 == _uploadBegin )
	{
		_uploadBegin = oBytes;
		_uploadBytes = 0;
	}
	else
	{
		_uploadBytes = oBytes - _uploadBegin;
	}

	if ( 0 == _downloadBegin )
	{
		_downloadBegin = iBytes;
		_downloadBytes = 0;
	}
	else
	{
		_downloadBytes = iBytes - _downloadBegin;
	}

	[_sendPlots pushTail:__INT(_uploadBytes)];
	[_sendPlots keepTail:MAX_REQUEST_HISTORY];

	for ( NSNumber * n in _sendPlots )
	{
		if ( n.intValue > _sendUpperBound )
		{
			_sendUpperBound = MAX( n.intValue, _recvUpperBound );
		}
		else if ( n.intValue < _sendLowerBound )
		{
			_sendLowerBound = MIN( n.intValue, _recvLowerBound );
		}
	}

	[_recvPlots pushTail:__INT(_downloadBytes)];
	[_recvPlots keepTail:MAX_REQUEST_HISTORY];

	for ( NSNumber * n in _recvPlots )
	{
		if ( n.intValue > _recvUpperBound )
		{
			_recvUpperBound = MAX( n.intValue, _sendUpperBound );
		}
		else if ( n.intValue < _recvLowerBound )
		{
			_recvLowerBound = MIN( n.intValue, _sendLowerBound );
		}
	}
}

- (void)changeBandWidth:(NSUInteger)bw
{
	if ( bw == _bandWidth )
		return;
	
	_bandWidth = bw;

	if ( self.BANDWIDTH_CURRENT == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:NO];
		[ASIHTTPRequest setMaxBandwidthPerSecond:0];
	}
	else if ( self.BANDWIDTH_GPRS == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:10 * 1024];
	}
	else if ( self.BANDWIDTH_EDGE == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:30 * 1024];
	}
	else if ( self.BANDWIDTH_3G == _bandWidth )
	{
		[ASIHTTPRequest setForceThrottleBandwidth:YES];
		[ASIHTTPRequest setMaxBandwidthPerSecond:300 * 1024];
	}
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
