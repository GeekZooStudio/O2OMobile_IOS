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
#import "model.h"
#import "ErrorMsg.h"

@implementation ErrorMsg

//1   => '登录过期，请重新登录',        //原：会话过期
//2   => '注册失败',                  //原：未知错误
//3   => '用户不存在',
//5   => '发送失败',
//6   => '密码错误',
//7   => '用户名已经存在',
//8   => '处理失败',
//9   => '信息不存在',                //原：不存在的信息
//10  => '昵称已经存在',              //原: 未绑定
//11  => '邮箱已经存在',
//100 => '请先登录',                  //原：登录过期，请重新登录
//101 => '缺少参数，请检查',           //原：参数错误
//400 => '错误的请求格式',
//500 => '上传的格式不允许',           //原：上传的格式不合法
//600 => '你的账号已被锁定',           //原：账号已被锁定
//700 => '上传失败',                  //新加
//800 => '请检查邮箱和用户名的格式',    //新加


+ (NSDictionary *)errors
{
    static NSMutableDictionary * __errors = nil;
    
    if ( nil == __errors )
    {
        __errors = [[NSMutableDictionary alloc] init];
        
        [__errors setObject:@"登录过期，请重新登录" forKey:@1];
        [__errors setObject:@"注册失败" forKey:@2];
        [__errors setObject:@"手机号不存在" forKey:@(ErrorMsgCodeMobileNotExists)];
        [__errors setObject:@"发布失败" forKey:@5];
        [__errors setObject:__TEXT(@"mobile_phone_or_password_error") forKey:@(ErrorMsgCodePasswordError)];
        [__errors setObject:@"手机号已经存在" forKey:@(ErrorMsgCodeMobileExists)];
        [__errors setObject:@"授权验证失败" forKey:@8];
        [__errors setObject:@"信息不存在" forKey:@9];
        [__errors setObject:@"不是自由人不能接订单" forKey:@(ErrorMsgCodeReceiveOrderFailed)];
        [__errors setObject:@"昵称已经存在" forKey:@(ErrorMsgCodeNicknameExists)];
        [__errors setObject:@"邮箱已经存在" forKey:@(ErrorMsgCodeEmailExists)];
        [__errors setObject:@"请先登录" forKey:@100];
        [__errors setObject:@"缺少参数，请检查" forKey:@101];
        [__errors setObject:@"错误的请求格式" forKey:@400];
        [__errors setObject:@"处理失败" forKey:@500];
        [__errors setObject:@"你的账号已被锁定" forKey:@600];
        [__errors setObject:@"上传失败" forKey:@700];
        [__errors setObject:@"请检查邮箱和用户名的格式" forKey:@800];
    }
    
    return __errors;
}

+ (void)presentErrorCode:(NSNumber *)errorCode
			   errorDesc:(NSString *)errorDesc
				 inBoard:(BeeUIBoard *)board
{
	NSString * tips = nil;
	
    if ( nil == errorCode )
    {
        tips = @"网络异常, 请稍后再试";
    }
    else
    {
        tips = [[self errors] objectForKey:errorCode];
    }

	if ( nil == tips )
	{
		tips = errorDesc;
	}
	
	if ( nil == tips )
	{
		tips = [NSString stringWithFormat:@"未知错误, 代码%@", errorCode];
	}

	if ( board )
	{
		[board presentFailureTips:tips];
	}
	else
	{
		[bee.ui.application.window presentFailureTips:tips];
	}
}

@end
