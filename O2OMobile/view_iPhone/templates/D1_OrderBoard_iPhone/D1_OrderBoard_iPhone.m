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

#import "D1_OrderBoard_iPhone.h"
#import "D1_OrderInfoCell_iPhone.h"
#import "D1_OrderEmployerCell_iPhone.h"
#import "D1_OrderStatusCell.h"
#import "D1_OrderNotifyCell.h"
#import "D1_OrderEmployeeCell_iPhone.h"
#import "D1_OrderButton_iPhone.h"
#import "D1_OrderCommentCell_iPhone.h"
#import "D1_OrderVoiceCell_iPhone.h"
#import "D1_OrderWorkDoneCell_iPhone.h"
#import "D2_OrderHistoryBoard_iPhone.h"
#import "D3_OrderCommentBoard_iPhone.h"
#import "D4_OrderCommentListBoard_iPhone.h"
#import "D1_OrderPaymentCell_iPhone.h"
#import "HeaderLoader_iPhone.h"
#import "AudioManager.h"
#import "AppBoard_iPhone.h"
#import "BeeAlertView.h"
#import "G0_ReportBoard_iPhone.h"
#import "F0_ProfileBoard_iPhone.h"
#import "D1_OrderInfoPriceCell_iPhone.h"

#pragma mark -

@interface D1_OrderBoard_iPhone()
@property (nonatomic, retain) D1_OrderWorkDoneCell_iPhone * workDoneCell;
@property (nonatomic, retain) D1_OrderPaymentCell_iPhone * paymentCell;
@property (nonatomic, retain) NSString * workPrice;
@end

@implementation D1_OrderBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( OrderInfoModel, orderInfoModel )
DEF_OUTLET( BeeUIScrollView, list )
DEF_OUTLET( D1_OrderButton_iPhone, action )

- (void)load
{
    self.orderInfoModel = [OrderInfoModel modelWithObserver:self];
}

- (void)unload
{
    SAFE_RELEASE_MODEL( self.orderInfoModel );
}

- (void)setOrder:(ORDER_INFO *)order
{
    self.orderInfoModel.order = order;
    self.orderInfoModel.order_id = order.id;
}

- (void)setOrder_id:(NSNumber *)order_id
{
    [_order_id release];
    [order_id retain];
    
    _order_id = order_id;
    
    self.orderInfoModel.order_id = order_id;
}

- (ORDER_INFO *)order
{
    return self.orderInfoModel.order;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
    self.title = __TEXT(@"order_detail");
    self.navigationBarShown = YES;
    self.view.backgroundColor = HEX_RGB(0xffffff);
    
    self.list.lineCount = 1;
	self.list.animationDuration = 0.25f;
	self.list.baseInsets = bee.ui.config.baseInsets;
    
    self.list.headerClass = [HeaderLoader_iPhone class];
    self.list.headerShown = YES;
    
    @weakify(self);
    
    self.list.whenHeaderRefresh = ^
    {
        @normalize(self);
        
        [self.orderInfoModel reload];
    };
    
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
    self.navigationBarRight = __TEXT(@"complain");
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
    [self.orderInfoModel reload];
}

ON_DID_APPEAR( signal )
{
}

ON_WILL_DISAPPEAR( signal )
{
    [[AudioManager sharedInstance] stop];
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
    G0_ReportBoard_iPhone * board = [G0_ReportBoard_iPhone board];
    board.order_id = self.order_id;
    [self.stack pushBoard:board animated:YES];
}

- (void)reloadData
{
    ORDER_INFO * order = self.orderInfoModel.order;
    
    @weakify( self )
    
    if ( order.innerStatus == BAUserOrderStatusEmployeeKnockDown )
    {
        self.cancel.alpha = 1.f;
        self.cancel.enabled = YES;
        self.list.baseInsets = UIEdgeInsetsMake(0, 0, 56, 0);
        self.cancel.hidden = NO;
    }
    else
    {
        self.cancel.hidden = YES;
        self.list.baseInsets = bee.ui.config.baseInsets;
    }
    
    self.list.whenReloading = ^
	{
		@normalize( self );
        
        if (!order)
            return;

        Class orderInfoClazz;
        
        switch ( order.innerStatus )
        {
            case BAUserOrderStatusEmployerWorkDone:
            case BAUserOrderStatusEmployeeWorkDone:
            case BAUserOrderStatusEmployerPayed:
            case BAUserOrderStatusEmployeePayed:
            case BAUserOrderStatusEmployerPayConformed:
            case BAUserOrderStatusEmployeePayConformed:
            case BAUserOrderStatusBothNeedComment:
            case BAUserOrderStatusNeedComment:
            case BAUserOrderStatusWaitCommented:
            case BAUserOrderStatusFinished:
                orderInfoClazz = [D1_OrderInfoPriceCell_iPhone class];
                break;
            default:
                orderInfoClazz = [D1_OrderInfoCell_iPhone class];
                break;
        }
        
        switch (order.innerStatus) {
            case BAUserOrderStatusUnkown:
                return;
                break;
            case BAUserOrderStatusEmployerPublished: // 1234
            {
                BeeUIScrollItem * employer = self.list.firstItem;
                employer.size = CGSizeAuto;
                employer.clazz = [D1_OrderEmployerCell_iPhone class];
                employer.data = order;
                
                BeeUIScrollItem * info = self.list.nextItem;
                info.size = CGSizeAuto;
                info.clazz = orderInfoClazz;
                info.data = order;
                
                if ( order.content.voice && order.content.voice.length )
                {
                    BeeUIScrollItem * voice = self.list.nextItem;
                    voice.size = CGSizeAuto;
                    voice.clazz = [D1_OrderVoiceCell_iPhone class];
                    voice.data = order;
                }
                
                BeeUIScrollItem * status = self.list.nextItem;
                status.size = CGSizeAuto;
                status.clazz = [D1_OrderStatusCell class];
                status.data = order;
                
                BeeUIScrollItem * notify = self.list.nextItem;
                notify.size = CGSizeAuto;
                notify.clazz = [D1_OrderNotifyCell class];
                notify.data = order;
            }
                break;
            case BAUserOrderStatusVisitorKnockDown:
            {
                self.action.hidden = YES;
                // NO Break!
            }
            case BAUserOrderStatusEmployeePublished: // 123
            {
                BeeUIScrollItem * employer = self.list.firstItem;
                employer.size = CGSizeAuto;
                employer.clazz = [D1_OrderEmployerCell_iPhone class];
                employer.data = order;
                
                BeeUIScrollItem * info = self.list.nextItem;
                info.size = CGSizeAuto;
                info.clazz = orderInfoClazz;
                info.data = order;
                
                if ( order.content.voice && order.content.voice.length )
                {
                    BeeUIScrollItem * voice = self.list.nextItem;
                    voice.size = CGSizeAuto;
                    voice.clazz = [D1_OrderVoiceCell_iPhone class];
                    voice.data = order;
                }
                
                BeeUIScrollItem * status = self.list.nextItem;
                status.size = CGSizeAuto;
                status.clazz = [D1_OrderStatusCell class];
                status.data = order;
            }
                break;
            case BAUserOrderStatusCanceled: // 123
            {
                BeeUIScrollItem * employer = self.list.firstItem;
                employer.size = CGSizeAuto;
                employer.clazz = [D1_OrderEmployerCell_iPhone class];
                employer.data = order;
                
                BeeUIScrollItem * info = self.list.nextItem;
                info.size = CGSizeAuto;
                info.clazz = orderInfoClazz;
                info.data = order;
                
                if ( order.content.voice && order.content.voice.length )
                {
                    BeeUIScrollItem * voice = self.list.nextItem;
                    voice.size = CGSizeAuto;
                    voice.clazz = [D1_OrderVoiceCell_iPhone class];
                    voice.data = order;
                }
                
                BeeUIScrollItem * status = self.list.nextItem;
                status.size = CGSizeAuto;
                status.clazz = [D1_OrderStatusCell class];
                status.data = order;
                
                if ( order.employee )
                {
                    BeeUIScrollItem * employee = self.list.nextItem;
                    employee.size = CGSizeAuto;
                    employee.clazz = [D1_OrderEmployeeCell_iPhone class];
                    employee.data = order;
                }
                
                self.action.hidden = YES;
            }
                break;
            case BAUserOrderStatusNeedComment:
            case BAUserOrderStatusWaitCommented:
            case BAUserOrderStatusFinished: // 12345
            {
                BeeUIScrollItem * employer = self.list.firstItem;
                employer.size = CGSizeAuto;
                employer.clazz = [D1_OrderEmployerCell_iPhone class];
                employer.data = order;
                
                BeeUIScrollItem * info = self.list.nextItem;
                info.size = CGSizeAuto;
                info.clazz = orderInfoClazz;
                info.data = order;
                
                if ( order.content.voice && order.content.voice.length )
                {
                    BeeUIScrollItem * voice = self.list.nextItem;
                    voice.size = CGSizeAuto;
                    voice.clazz = [D1_OrderVoiceCell_iPhone class];
                    voice.data = order;
                }
                
                BeeUIScrollItem * status = self.list.nextItem;
                status.size = CGSizeAuto;
                status.clazz = [D1_OrderStatusCell class];
                status.data = order;
                
                BeeUIScrollItem * employee = self.list.nextItem;
                employee.size = CGSizeAuto;
                employee.clazz = [D1_OrderEmployeeCell_iPhone class];
                employee.data = order;
                
                BeeUIScrollItem * comment = self.list.nextItem;
                comment.size = CGSizeAuto;
                comment.clazz = [D1_OrderCommentCell_iPhone class];
                comment.data = order;
            }
                break;
            case BAUserOrderStatusEmployeeKnockDown: // 1234
            {
                BeeUIScrollItem * employer = self.list.firstItem;
                employer.size = CGSizeAuto;
                employer.clazz = [D1_OrderEmployerCell_iPhone class];
                employer.data = order;
                
                BeeUIScrollItem * info = self.list.nextItem;
                info.size = CGSizeAuto;
                info.clazz = orderInfoClazz;
                info.data = order;
                
                if ( order.content.voice && order.content.voice.length )
                {
                    BeeUIScrollItem * voice = self.list.nextItem;
                    voice.size = CGSizeAuto;
                    voice.clazz = [D1_OrderVoiceCell_iPhone class];
                    voice.data = order;
                }
                
                BeeUIScrollItem * status = self.list.nextItem;
                status.size = CGSizeAuto;
                status.clazz = [D1_OrderStatusCell class];
                status.data = order;
                
                BeeUIScrollItem * employee = self.list.nextItem;
                employee.size = CGSizeAuto;
                employee.clazz = [D1_OrderEmployeeCell_iPhone class];
                employee.data = order;
            }
                break;
            default:
            {
                BeeUIScrollItem * employer = self.list.firstItem;
                employer.size = CGSizeAuto;
                employer.clazz = [D1_OrderEmployerCell_iPhone class];
                employer.data = order;
                
                BeeUIScrollItem * info = self.list.nextItem;
                info.size = CGSizeAuto;
                info.clazz = orderInfoClazz;
                info.data = order;
                
                if ( order.content.voice && order.content.voice.length )
                {
                    BeeUIScrollItem * voice = self.list.nextItem;
                    voice.size = CGSizeAuto;
                    voice.clazz = [D1_OrderVoiceCell_iPhone class];
                    voice.data = order;
                }
                
                BeeUIScrollItem * status = self.list.nextItem;
                status.size = CGSizeAuto;
                status.clazz = [D1_OrderStatusCell class];
                status.data = order;
                
                BeeUIScrollItem * employee = self.list.nextItem;
                employee.size = CGSizeAuto;
                employee.clazz = [D1_OrderEmployeeCell_iPhone class];
                employee.data = order;
                
                self.cancel.hidden = YES;
            }
                break;
        }
        
        self.action.status = order.innerStatus;
    };
    
    [self.list reloadData];
}

#pragma mark - OrderFlow [ 确认完成 ]

ON_SIGNAL3( D1_OrderWorkDoneCell_iPhone, mask, signal )
{
    [self hideWorkDone];
}

ON_SIGNAL3( D1_OrderWorkDoneCell_iPhone, cancel, signal )
{
    [self hideWorkDone];
}

ON_SIGNAL3( D1_OrderWorkDoneCell_iPhone, work_done, signal )
{
    [self.orderInfoModel workDoneWithPrice:self.workDoneCell.money.text];
    [   self hideWorkDone];
}

- (void)showWorkDone
{
    if ( nil == self.workDoneCell )
    {
        self.workDoneCell = [[D1_OrderWorkDoneCell_iPhone alloc] init];
        self.workDoneCell.FROM_NAME(@"D1_OrderWorkDoneCell_iPhone.xml");
        self.workDoneCell.frame = self.view.bounds;
    }
    self.workDoneCell.data = self.order;
    
    [self transitionFade];
    [self.view addSubview:self.workDoneCell];
}

- (void)hideWorkDone
{
    [self transitionFade];
    [self.workDoneCell removeFromSuperview];
}

#pragma mark - OrderFlow [ 支付 ]

ON_SIGNAL3( D1_OrderPayBottomCell_iPhone, pay_cancel, signal )
{
    [self hidePayment];
}

ON_SIGNAL3( D1_OrderPayBottomCell_iPhone, pay_online, signal )
{
    [self hidePayment];
    
    // TODO: add function (pay online)
    [self presentMessageTips:__TEXT(@"share_content")];
}

ON_SIGNAL3( D1_OrderPayBottomCell_iPhone, pay_offline, signal )
{
    [self hidePayment];
    
    [self.orderInfoModel payWithMode:PAY_CODE_PAY_OFFLINE];
}

- (void)showPayment
{
    if ( nil == self.paymentCell )
    {
        self.paymentCell = [[D1_OrderPaymentCell_iPhone alloc] init];
        self.paymentCell.FROM_NAME(@"D1_OrderPaymentCell_iPhone.xml");
        self.paymentCell.frame = self.view.bounds;
    }
    
    self.paymentCell.data = self.order;
    [self.view addSubview:self.paymentCell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paymentCell show];
    });
}

- (void)hidePayment
{
    [self.paymentCell hideWithCompeltionBlock:^{
        [self.paymentCell removeFromSuperview];
    }];
}

#pragma mark - D1_OrderEmployerCell_iPhone

ON_SIGNAL3( D1_OrderEmployerCell_iPhone, avatar, signal )
{
    SIMPLE_USER * user = self.order.employer;
    
    if ( [user.id isEqualToNumber:[UserModel sharedInstance].user.id] )
    {
        [self.stack pushBoard:[F0_MyProfileBoard_iPhone sharedInstance] animated:YES];
    }
    else
    {
        F0_OtherProfileBoard_iPhone * board = [F0_OtherProfileBoard_iPhone board];
        board.uid = user.id;
        [self.stack pushBoard:board animated:YES];
    }
}

// 雇主电话
ON_SIGNAL3( D1_OrderEmployerCell_iPhone, phone, signal )
{
    [AppBoard_iPhone openTelephone:self.order.employer.mobile_phone];
}

#pragma mark - D1_OrderEmployeeCell_iPhone

ON_SIGNAL3( D1_OrderEmployeeCell_iPhone, avatar, signal )
{
    SIMPLE_USER * user = self.order.employee;
    
    if ( [user.id isEqualToNumber:[UserModel sharedInstance].user.id] )
    {
        [self.stack pushBoard:[F0_MyProfileBoard_iPhone sharedInstance] animated:YES];
    }
    else
    {
        F0_OtherProfileBoard_iPhone * board = [F0_OtherProfileBoard_iPhone board];
        board.uid = user.id;
        [self.stack pushBoard:board animated:YES];
    }
}

// 雇员电话
ON_SIGNAL3( D1_OrderEmployeeCell_iPhone, phone, signal )
{
    [AppBoard_iPhone openTelephone:self.order.employee.mobile_phone];
}

#pragma mark - D1_OrderVoiceCell_iPhone
// 听声音
ON_SIGNAL3( D1_OrderVoiceCell_iPhone, mask, signal )
{
    [self.orderInfoModel download:self.order.content.voice andPlay:YES];
}

#pragma mark - D1_OrderStatusCell
// 查看订单状态
ON_SIGNAL3( D1_OrderStatusCell, mask, signal )
{
    D2_OrderHistoryBoard_iPhone * board = [D2_OrderHistoryBoard_iPhone board];
    board.order = self.order;
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL3( D1_OrderCommentCell_iPhone, mask, signal )
{
    D4_OrderCommentListBoard_iPhone * board = [D4_OrderCommentListBoard_iPhone board];
    board.order = self.order;
    [self.stack pushBoard:board animated:YES];
}

// 各种动作
ON_SIGNAL3( D1_OrderButton_iPhone, action, signal )
{
    switch ( self.order.order_status.intValue )
    {
        case ORDER_STATUS_OS_PUBLISHED:
        {
            if ( self.order.innerRole == BAUserOrderRoleEmployer )
            {
                [self cancelOrder];
            }
            else
            {
                [self.orderInfoModel accept];
            }
        }
            break;
        case ORDER_STATUS_OS_KNOCK_DOWN:
        {
            [self showWorkDone];
        }
            break;
        case ORDER_STATUS_OS_WORK_DONE:
        {
            [self showPayment];
        }
            break;
        case ORDER_STATUS_OS_PAYED:
        {
            [self.orderInfoModel confirm_pay];
        }
            break;
        case ORDER_STATUS_OS_PAY_CONFORMED:
        case ORDER_STATUS_OS_EMPLOYEE_COMMENTED:
        case ORDER_STATUS_OS_EMPLOYER_COMMENTED:
        case ORDER_STATUS_OS_FINISHED:
        {
            D3_OrderCommentBoard_iPhone * board = [D3_OrderCommentBoard_iPhone board];
            board.order = self.order;
            [self.stack pushBoard:board animated:YES];
        }
            break;
        case ORDER_STATUS_OS_CANCELED:
        {
            
        }
            break;
    }
}

ON_SIGNAL3( D1_OrderButton_iPhone, cancel, signal )
{
    [self cancelOrder]; // TODO:
}

#pragma mark -

- (void)cancelOrder
{
    BeeUIAlertView * alert = [[[BeeUIAlertView alloc] init] autorelease];
    alert.title = @"是否取消订单？";
    [alert addCancelTitle:@"取消"];
    [alert addButtonTitle:@"确定" signal:@"cancel_order"];
    [alert showInView:self.view];
}

ON_SIGNAL2( cancel_order, signal )
{
    [self.orderInfoModel cancel];
}

#pragma mark - OrderInfoModel

ON_SIGNAL3( OrderInfoModel, RELOADING, signal )
{
    if ( !self.orderInfoModel.loaded )
    {
        [self presentLoadingTips:@"正在加载"];
    }
}

ON_SIGNAL3( OrderInfoModel, RELOADED, signal )
{
    [self dismissTips];
    
    if ( self.orderInfoModel.order )
    {
        [self reloadData];
    }
    
    self.list.headerLoading = NO;
}

ON_SIGNAL3( OrderInfoModel, OPREATION_FAILED, signal )
{
    [self dismissTips];
    [self presentFailureTips:@"操作失败"];
}

ON_SIGNAL3( OrderInfoModel, ACCEPT_LOADING, signal )
{
    [self presentLoadingTips:@"正在接单"];
}

ON_SIGNAL3( OrderInfoModel, DID_ACCEPT, signal )
{
    [self dismissTips];
    BeeAlertView * alert = [BeeAlertView alertWithType:BeeAlertViewTypeSuccess title:__TEXT(@"receive_order_success")];
    [self.view transitionFade];
    [alert showInContainer:self];
    [self reloadData];
}

ON_SIGNAL3( OrderInfoModel, DID_ACCEPT_FAIL, signal )
{
    [self dismissTips];
    BeeAlertView * alert = [BeeAlertView alertWithType:BeeAlertViewTypeFailure title:__TEXT(@"receive_order_fail") message:signal.object];
    [self.view transitionFade];
    [alert showInContainer:self];
    [self reloadData];
}

ON_SIGNAL3( OrderInfoModel, CANCEL_LOADING, signal )
{
    [self presentLoadingTips:@"正在取消订单"];
}

ON_SIGNAL3( OrderInfoModel, DID_CANCEL, signal )
{
    [self dismissTips];
    BeeAlertView * alert = [BeeAlertView alertWithType:BeeAlertViewTypeSuccess title:@"取消成功"];
    [self.view transitionFade];
    [alert showInContainer:self];
    [self reloadData];
}

ON_SIGNAL3( OrderInfoModel, CONFIRM_PAY_LOADING, signal )
{
    [self presentLoadingTips:@"正在确认订单"];
}

ON_SIGNAL3( OrderInfoModel, DID_CONFIRM_PAY, signal )
{
    [self dismissTips];
    BeeAlertView * alert = [BeeAlertView alertWithType:BeeAlertViewTypeSuccess title:@"确认成功"];
    [self.view transitionFade];
    [alert showInContainer:self];
    [self reloadData];
}

ON_SIGNAL3( OrderInfoModel, PAY_LOADING, signal )
{
    [self presentLoadingTips:__TEXT(@"please_later_on")];
}

ON_SIGNAL3( OrderInfoModel, DID_PAY, signal )
{
    [self dismissTips];
    
    if ( self.orderInfoModel.payMode == PAY_CODE_PAY_ONLINE )
    {
        // TODO: add function (pay online)
    }
    else
    {
        [self reloadData];
    }
}

ON_SIGNAL3( OrderInfoModel, WORK_DONE_LOADING, signal )
{
    [self presentLoadingTips:@"正在确认完成"];
}

ON_SIGNAL3( OrderInfoModel, DID_WORK_DONE, signal )
{
    [self dismissTips];
    BeeAlertView * alert = [BeeAlertView alertWithType:BeeAlertViewTypeSuccess title:@"确认成功"];
    [self.view transitionFade];
    [alert showInContainer:self];
    [self reloadData];
}

ON_SIGNAL3( OrderInfoModel, LOAD_FAIL_VOICE_LOADING, signal )
{
}

ON_SIGNAL3( OrderInfoModel, DID_LOAD_FAIL_VOICE, signal )
{
    [self presentFailureTips:@"播放声音失败"];
}

@end
