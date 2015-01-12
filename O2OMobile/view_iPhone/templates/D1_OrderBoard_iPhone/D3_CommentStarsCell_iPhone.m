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

#import "D3_CommentStarsCell_iPhone.h"

static int const kStartTag = 1001;

@interface D3_CommentStarsCell_iPhone()
@property (nonatomic, retain) NSMutableArray * buttons;
@end

@implementation D3_CommentStarsCell_iPhone

- (void)dealloc
{
    [self.buttons removeAllObjects];
    self.buttons = nil;
    
    self.whenSelected = nil;
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _starCount = 5;
    _buttons = [[NSMutableArray alloc] init];
    [self setupButtons];
    [self setCurrentIndex:1];
}

- (void)layoutSubviews
{
    for ( UIButton * button in self.buttons )
    {
        int index = button.tag - kStartTag - 1;
        button.frame = CGRectMake( index * 25, 0, 20, 20);
    }
}

- (void)setupButtons
{
    for ( int i=1; i<=_starCount; i++ )
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( (i-1) * 25, 0, 20, 20);
        button.tag = i+kStartTag;
        [button setImage:[UIImage imageNamed:@"b7_star_off.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"b7_star_on.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    for ( UIButton * button in self.buttons )
    {
        int index = button.tag - kStartTag;
        
        if ( index <= currentIndex )
        {
            button.selected = YES;
        }
        else
        {
            button.selected = NO;
        }
    }
}

- (void)touch:(UIButton *)sender
{
    int currentIndex = sender.tag - kStartTag;
    
    [self setCurrentIndex:currentIndex];
    
    if ( self.whenSelected ) {
        self.whenSelected(currentIndex);
    }
}

@end
