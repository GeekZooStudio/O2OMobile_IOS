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

#import "C1_TypeFilterCell_iPhone.h"
#import "C1_TypeFilterItemCell_iPhone.h"

#pragma mark -

@implementation C1_TypeFilterCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIButton, mask )
DEF_OUTLET( BeeUIScrollView, itemList )

- (void)load
{
    self.backgroundColor = HEX_RGBA( 0xFFFFFF, 0.9 );

    if ( nil == self.currentServiceType )
    {
        self.currentServiceType = @0;
    }
    
    @weakify(self);
    
    self.itemList.lineCount = 1;
    self.itemList.animationDuration = 0.25f;
    self.itemList.baseInsets = bee.ui.config.baseInsets;
    
    self.itemList.whenReloading = ^
    {
        @normalize(self);
        
        self.itemList.total = self.datas.count;
        
        for ( int i = 0; i < self.itemList.total; i++ )
        {
            BeeUIScrollItem * item = self.itemList.items[i];
            item.clazz = [C1_TypeFilterItemCell_iPhone class];
            item.size = CGSizeMake( self.itemList.width, 50 );
            
            if ( [[self.datas safeObjectAtIndex:i] isKindOfClass:[SERVICE_TYPE class]] )
            {
                SERVICE_TYPE * service_type = [self.datas safeObjectAtIndex:i];
                if ( [service_type.id isEqualToNumber:self.currentServiceType] )
                {
                    service_type.isSelected = YES;
                }
                else
                {
                    service_type.isSelected = NO;
                }
                item.data = service_type;
            }
            else if ( [[self.datas safeObjectAtIndex:i] isKindOfClass:[MY_SERVICE class]] )
            {
                MY_SERVICE * my_service = [self.datas safeObjectAtIndex:i];
                if ( [my_service.service_type.id isEqualToNumber:self.currentServiceType] )
                {
                    my_service.service_type.isSelected = YES;
                }
                else
                {
                    my_service.service_type.isSelected = NO;
                }
                item.data = my_service.service_type;
            }
            item.rule = BeeUIScrollLayoutRule_Tile;
        }
    };
    
    _expanded = YES;
    self.expanded = NO;
}

- (void)unload
{
}

- (void)dataDidChanged
{
}

- (void)layoutDidFinish
{
}

#pragma mark -

ON_SIGNAL3( C1_TypeFilterItemCell_iPhone, mask, signal )
{
    SERVICE_TYPE * service_type = signal.sourceCell.data;
    self.currentServiceType = service_type.id;
}

#pragma mark - expanded

- (void)setExpanded:(BOOL)expanded
{
    if ( expanded == _expanded )
        return;
    
    _expanded = expanded;
    
    if ( _expanded )
    {
        self.height = self.superview.height;
        self.hidden = NO;
        [UIView animateWithDuration:0.35f animations:^{
            self.itemList.height = self.height;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.35f animations:^{
            self.itemList.height = 0.0f;
            self.hidden = YES;
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
