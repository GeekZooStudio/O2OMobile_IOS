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

#import "controller.h"
#import "model.h"
#import "ErrorMsg.h"

#pragma mark -

@implementation GlobalController

DEF_SINGLETON( GlobalController )

+ (void)load
{
	[BeeMessage setGlobalExecuter:[GlobalController sharedInstance]];
}

- (void)index:(BeeMessage *)msg
{
	if ( msg.succeed )
	{
		NSDictionary * dict = msg.responseJSONDictionary;
		if ( dict )
		{
			NSNumber * succ = [dict numberAtPath:@"succeed"];
			NSNumber * code = [dict numberAtPath:@"error_code"];
			NSString * desc = [dict stringAtPath:@"error_desc"];
			
            // 服务器返回错误时，succeed字段不一定有，但是error_code和error_desc有值，
            // 之前的判断有漏洞，导致一些loading卡死
            // if ( (succ && NO == succ.boolValue )
			if ( (succ || (code && desc)) && NO == succ.boolValue )
			{
				msg.errorCode = code.intValue;
				msg.errorDesc = desc;
				
				if ( code.intValue == ERROR_CODE_SESSION_EXPIRED || code.intValue == ERROR_CODE_UNKNOWN_ERROR )
				{
					if ( [[UserModel sharedInstance] online] )
					{
						[[UserModel sharedInstance] kickout];
						
						[[UIApplication sharedApplication].keyWindow presentFailureTips:@"请重新登录"];
						
					}
					
					msg.failed = YES;
					return;
				}
                else
                {
                    if ( code.intValue != ErrorMsgCodeReceiveOrderFailed )
                    {
                        [[UIApplication sharedApplication].keyWindow presentFailureTips:desc];
                    }
                }
			}
		}
	}
    else if ( msg.failed )
    {
		ERROR( @"msg.name = %@", msg.message );
		
//		[[UIApplication sharedApplication].keyWindow presentFailureTips:@"网络异常, 请稍后再试"];
    }
}

@end

