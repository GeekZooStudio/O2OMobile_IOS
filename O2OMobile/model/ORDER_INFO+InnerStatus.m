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

#import "ORDER_INFO+InnerStatus.h"
#import "UserModel.h"

static const char INNER_ROLE_KEY;
static const char INNER_STATUS_KEY;

@implementation ORDER_INFO (InnerStatus)

- (BAUserOrderStatus)innerStatus
{
    NSNumber * statusNumber = objc_getAssociatedObject(self, &INNER_STATUS_KEY);
    
    if ( nil == statusNumber )
    {
        BAUserOrderStatus status = BAUserOrderStatusUnkown;
    
        status = [OrderStatusManager innerStatusFromStatus:self.order_status.intValue role:self.innerRole];
        
        objc_setAssociatedObject(self, &INNER_STATUS_KEY, @(status), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return status;
    }
    else
    {
        return statusNumber.intValue;
    }
}

- (BAUserOrderRole)innerRole
{
    NSNumber * roleNumber = objc_getAssociatedObject(self, &INNER_ROLE_KEY);
    
    if ( nil == roleNumber )
    {
        BAUserOrderRole role = BAUserOrderRoleVisitor;
        
        NSNumber * user_id = [UserModel sharedInstance].user.id;
        
        if ( [self.employer.id isEqualToNumber:user_id] )
        {
            role = BAUserOrderRoleEmployer;
        }
        else if ( [self.employee.id isEqualToNumber:user_id]
                  || self.order_status.intValue == ORDER_STATUS_OS_PUBLISHED )
        {
            role = BAUserOrderRoleEmployee;
        }
        else
    
        objc_setAssociatedObject(self, &INNER_ROLE_KEY, @(role), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return role;
    }
    else
    {
        return roleNumber.intValue;
    }
}

@end
