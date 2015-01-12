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

#import "Bee_OnceViewModel.h"
#import "O2OMobile.h"

@interface OrderInfoModel : BeeOnceViewModel
@property (nonatomic, retain) IN NSNumber * order_id;
@property (nonatomic, retain) OUT ORDER_INFO * order;
@property (nonatomic, retain) OUT NSArray * records;
@property (nonatomic, assign) int payMode;

AS_SIGNAL( ACCEPT_LOADING )
AS_SIGNAL( DID_ACCEPT )
AS_SIGNAL( DID_ACCEPT_FAIL )
AS_SIGNAL( CANCEL_LOADING )
AS_SIGNAL( DID_CANCEL )
AS_SIGNAL( CONFIRM_PAY_LOADING )
AS_SIGNAL( DID_CONFIRM_PAY )
AS_SIGNAL( HISTORY_LOADING )
AS_SIGNAL( DID_HISTORY )
AS_SIGNAL( PAY_LOADING )
AS_SIGNAL( DID_PAY )
AS_SIGNAL( WORK_DONE_LOADING )
AS_SIGNAL( DID_WORK_DONE )
AS_SIGNAL( OPREATION_FAILED )

AS_SIGNAL( LOADING_VOICE )
AS_SIGNAL( DID_LOAD_VOICE )
AS_SIGNAL( DID_LOAD_VOICE_FAIL )

// download
- (void)download:(NSString *)voice;
- (void)download:(NSString *)message andPlay:(BOOL)play;
- (BOOL)downloading:(NSString *)message;
- (BOOL)downloaded:(NSString *)message;

// 接单
#pragma mark - POST /order/accept
- (void)accept;

// 取消订单
#pragma mark - POST /order/cancel
- (void)cancel;

// 确认付款
#pragma mark - POST /order/confirm-pay
- (void)confirm_pay;

// 订单历史
#pragma mark - POST /order/history
- (void)history;

// 订单详情
#pragma mark - POST /order/info
- (void)info;

// 付款
#pragma mark - POST /order/pay
- (void)payWithMode:(int)mode;

// 订单完成
#pragma mark - POST /order/work-done
- (void)workDoneWithPrice:(NSString *)price;

@end
