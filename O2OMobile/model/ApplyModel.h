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

#import "bee.h"
#import "model.h"

@interface ApplyModel : BeeViewModel

AS_SIGNAL( TYPE_UPDATING );
AS_SIGNAL( TYPE_UPDATED );

AS_SIGNAL( FIRST_UPDATING );
AS_SIGNAL( FIRST_UPDATED );

AS_SIGNAL( SECOND_UPDATING );
AS_SIGNAL( SECOND_UPDATED );

AS_SIGNAL( APPLY_REQUESTING );
AS_SIGNAL( APPLY_SUCCEED );
AS_SIGNAL( APPLY_FAILED );

@property (nonatomic, retain) INOUT NSArray * typeList;
@property (nonatomic, retain) INOUT NSArray * firstList;
@property (nonatomic, retain) INOUT NSArray * secondList;

@property (nonatomic, retain) INOUT SERVICE_TYPE *		type;
@property (nonatomic, retain) INOUT SERVICE_CATEGORY *	first;
@property (nonatomic, retain) INOUT SERVICE_CATEGORY *	second;

- (void)getTypeList;
- (void)getFirstList;
- (void)getSecondList;

- (void)apply;

@end
