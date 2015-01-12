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

#import <Foundation/Foundation.h>

// 一个人在一个订单里的角色
typedef NS_ENUM(NSUInteger, BAUserOrderRole) {
    BAUserOrderRoleVisitor = 0,
    BAUserOrderRoleEmployer,
    BAUserOrderRoleEmployee,
};

// 对于一个用户来说，只会遇到属于一个角色的状态，
// 但是对于程序来说，每个状态都有三个不同的角色，
// 考虑到状态太多，所以这里把所有的状态枚举出来，
// 避免了还要同时进行角色和订单状态的判断，
// 这样在使用的时候只需要判断一级就可以了

typedef NS_ENUM(NSUInteger, BAUserOrderStatus) {
    BAUserOrderStatusUnkown = 0,
    BAUserOrderStatusEmployerPublished, // 已发布，雇主
    BAUserOrderStatusEmployeePublished, // 已发布，雇员
    BAUserOrderStatusVisitorKnockDown,  // 已接单，浏览者
    BAUserOrderStatusEmployerKnockDown, // 已接单，雇主
    BAUserOrderStatusEmployeeKnockDown, // 已接单，雇员
    BAUserOrderStatusEmployerWorkDone,  // 已完成，雇主
    BAUserOrderStatusEmployeeWorkDone,  // 已完成，雇员
    BAUserOrderStatusEmployerPayed,     // 已付款，雇主
    BAUserOrderStatusEmployeePayed,     // 已付款，雇员
    BAUserOrderStatusEmployerPayConformed, // 已确认付款，雇主
    BAUserOrderStatusEmployeePayConformed, // 已确认付款，雇员
    BAUserOrderStatusBothNeedComment,   // 需要评价，都未评价
    BAUserOrderStatusNeedComment,       // 需要评价，其中一个评价
    BAUserOrderStatusWaitCommented,     // 等待评价
    BAUserOrderStatusFinished,          // 订单结束
    BAUserOrderStatusCanceled,          // 订单取消
};

@interface OrderStatusManager : NSObject

// 获取订单详情页面，按钮显示的内容
+ (void)getButtonTitle:(NSString **)title enabled:(BOOL *)enabled fromStatus:(BAUserOrderStatus)status;

// 从订单状态
+ (NSString *)statusStringFromOrder:(ORDER_INFO *)order;
+ (NSString *)statusStringFromStatus:(NSUInteger)status;

// 从订单状态和目前的user的角色来获取对于程序的状态
+ (BAUserOrderStatus)innerStatusFromStatus:(NSUInteger)status role:(BAUserOrderRole)role;

@end
