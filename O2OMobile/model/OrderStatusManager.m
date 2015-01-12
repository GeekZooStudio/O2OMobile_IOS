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

#import "OrderStatusManager.h"

// 0: visitor; 1: employer; 2: employee

NSString * const kButtonTitlePublished1    = @"取消订单";
NSString * const kButtonTitlePublished2    = @"马上接单";
NSString * const kButtonTitleKnock_down0   = @"订单已被接"; // disable
NSString * const kButtonTitleKnock_down1   = @"等待对方完成";
NSString * const kButtonTitleKnock_down2   = @"确认完成"; // disable
NSString * const kButtonTitleWork_done1    = @"立即付款";
NSString * const kButtonTitleWork_done2    = @"等待对方支付"; // disable
NSString * const kButtonTitlePayed1        = @"等待对方确认支付"; // disable
NSString * const kButtonTitlePayed2        = @"确认支付";
NSString * const kButtonTitlePay_conformed = @"现在点评";
NSString * const kButtonTitleWaitCommented = @"等待对方评价"; // disable
NSString * const kButtonTitleFinished      = @"分享评价";
NSString * const kButtonTitleCanceled      = @"订单已取消";

@implementation OrderStatusManager

+ (NSArray *)statuses
{
    static NSArray * __statuses = nil;
    
    if ( __statuses == nil )
    {
        __statuses = [@[@"客户发单",
                       @"已确认接单",
                       @"工作完成",
                       @"已付款",
                       @"付款已确认",
                       @"雇员已评价",
                       @"雇主已评价",
                       @"订单结束",
                       __TEXT(@"order_have_canceled"),
                       ] copy];
        
//        ORDER_STATUS_OS_PUBLISHED = 0,
//        ORDER_STATUS_OS_KNOCK_DOWN = 1,
//        ORDER_STATUS_OS_WORK_DONE = 2,
//        ORDER_STATUS_OS_PAYED = 3,
//        ORDER_STATUS_OS_PAY_CONFORMED = 4,
//        ORDER_STATUS_OS_EMPLOYEE_COMMENTED = 5,
//        ORDER_STATUS_OS_EMPLOYER_COMMENTED = 6,
//        ORDER_STATUS_OS_FINISHED = 7,
//        ORDER_STATUS_OS_CANCELED = 8,
    }
    
    return __statuses;
}

+ (NSString *)statusStringFromStatus:(NSUInteger)status
{
    if ( status < [[self statuses] count] )
    {
        NSString * string = [self statuses][status];
        
        if ( string )
        {
            return string;
        }
    }
    
    return @"未知状态";
}

+ (NSString *)statusStringFromOrder:(ORDER_INFO *)order
{
    if ( order.innerRole == BAUserOrderRoleVisitor )
        return @"订单已被接";
    
    if ( order.order_status.intValue < [[self statuses] count] )
    {
        NSString * string = [self statuses][order.order_status.intValue];
        
        if ( nil == string )
        {
            string = @"未知状态";
        }
        
        return string;
    }
    
    return @"未知状态";
}

+ (void)getButtonTitle:(NSString **)title enabled:(BOOL *)enabled fromStatus:(BAUserOrderStatus)status
{
    switch (status) {
        case BAUserOrderStatusUnkown:
        case BAUserOrderStatusVisitorKnockDown:
            *title = kButtonTitleKnock_down0;
            *enabled = NO;
            break;
        case BAUserOrderStatusEmployerPublished:
            *title = kButtonTitlePublished1;
            break;
        case BAUserOrderStatusEmployeePublished:
            *title = kButtonTitlePublished2;
            break;
        case BAUserOrderStatusEmployerKnockDown:
            *title = kButtonTitleKnock_down1;
            *enabled = NO;
            break;
        case BAUserOrderStatusEmployeeKnockDown:
            *title = kButtonTitleKnock_down2;
            break;
        case BAUserOrderStatusEmployerWorkDone:
            *title = kButtonTitleWork_done1;
            break;
        case BAUserOrderStatusEmployeeWorkDone:
            *title = kButtonTitleWork_done2;
            *enabled = NO;
            break;
        case BAUserOrderStatusEmployerPayed:
            *title = kButtonTitlePayed1;
            *enabled = NO;
            break;
        case BAUserOrderStatusEmployeePayed:
            *title = kButtonTitlePayed2;
            break;
        case BAUserOrderStatusEmployerPayConformed:
        case BAUserOrderStatusEmployeePayConformed:
        case BAUserOrderStatusNeedComment:
        case BAUserOrderStatusBothNeedComment:
            *title = kButtonTitlePay_conformed;
            break;
        case BAUserOrderStatusWaitCommented:
            *title = kButtonTitleWaitCommented;
            *enabled = NO;
            break;
        case BAUserOrderStatusFinished:
            *title = kButtonTitleFinished;
            break;
        case BAUserOrderStatusCanceled:
            *title = kButtonTitleCanceled;
            *enabled = NO;
            break;
    }
}

+ (BAUserOrderStatus)innerStatusFromStatus:(NSUInteger)status role:(BAUserOrderRole)role
{
    BAUserOrderStatus innerStatus = BAUserOrderStatusUnkown;

    switch ( status )
    {
        case ORDER_STATUS_OS_PUBLISHED:
        {
            switch (role)
            {
                case BAUserOrderRoleEmployer:
                    innerStatus = BAUserOrderStatusEmployerPublished;
                    break;
                case BAUserOrderRoleVisitor:
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusEmployeePublished;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_KNOCK_DOWN:
        {
            switch (role)
            {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                    innerStatus = BAUserOrderStatusEmployerKnockDown;
                    break;
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusEmployeeKnockDown;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_WORK_DONE:
        {
            switch (role)
            {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                    innerStatus = BAUserOrderStatusEmployerWorkDone;
                    break;
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusEmployeeWorkDone;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_PAYED:
        {
            switch (role)
            {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                    innerStatus = BAUserOrderStatusEmployerPayed;
                    break;
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusEmployeePayed;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_PAY_CONFORMED:
        {
            switch (role) {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                    innerStatus = BAUserOrderStatusEmployerPayConformed;
                    break;
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusEmployeePayConformed;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_EMPLOYEE_COMMENTED:
        {
            switch (role) {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                    innerStatus = BAUserOrderStatusNeedComment;
                    break;
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusWaitCommented;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_EMPLOYER_COMMENTED:
        {
            switch (role) {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                    innerStatus = BAUserOrderStatusWaitCommented;
                    break;
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusNeedComment;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_FINISHED:
        {
            switch (role) {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusFinished;
                    break;
            }
        }
            break;
        case ORDER_STATUS_OS_CANCELED:
        {
            switch (role) {
                case BAUserOrderRoleVisitor:
                    innerStatus = BAUserOrderStatusVisitorKnockDown;
                    break;
                case BAUserOrderRoleEmployer:
                case BAUserOrderRoleEmployee:
                    innerStatus = BAUserOrderStatusCanceled;
                    break;
            }
        }
            break;
    }
    
    return innerStatus;
}

@end
