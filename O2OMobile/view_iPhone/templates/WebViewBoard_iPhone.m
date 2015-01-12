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

#import "AppBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"

#pragma mark -

@implementation WebViewBoard_iPhone
{
	BOOL _showLoading;
    UIToolbar * _toolbar;
    
    UIBarButtonItem * _back;
    UIBarButtonItem * _stop;
    UIBarButtonItem * _forward;
    UIBarButtonItem * _refresh;
    UIBarButtonItem * _flexible;
	UIBarButtonItem * _fixed;
}

@synthesize showLoading = _showLoading;
@synthesize useHTMLTitle = _useHTMLTitle;

@synthesize toolbar = _toolbar;
@synthesize defaultTitle = _defaultTitle;

@synthesize backBoard = _backBoard;

- (void)load
{
	self.showLoading = YES;
	self.isToolbarHiden = NO;
}

- (void)unload
{
	self.htmlString = nil;
	self.urlString = nil;
	self.defaultTitle = nil;
}

#pragma mark [B] UISignal

ON_CREATE_VIEWS( signal )
{
    self.view.backgroundColor = HEX_RGB( 0xfbfbfb );
    
    self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
    self.navigationBarTitle = @"浏览器";
    
    self.navigationBarShown = YES;
    
    if ( self.defaultTitle && self.defaultTitle.length )
    {
        self.navigationBarTitle = self.defaultTitle;
    }
    
    _webView = [[BeeUIWebView alloc] init];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    if ( !_isToolbarHiden )
    {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _toolbar.backgroundColor = [UIColor clearColor];
        _toolbar.tintColor = [UIColor grayColor];
        _toolbar.translucent = YES;
        
        [self.view addSubview:_toolbar];
    }
    
    [self setupToolbar];
    [self updateUI];
}

ON_DELETE_VIEWS( signal )
{
    [self.webView stopLoading];
    
    SAFE_RELEASE( _back );
    SAFE_RELEASE( _stop );
    SAFE_RELEASE( _forward );
    SAFE_RELEASE( _refresh );
    SAFE_RELEASE( _urlString );
    
    SAFE_RELEASE( _flexible );
    SAFE_RELEASE( _fixed );
    
    SAFE_RELEASE_SUBVIEW( _webView );
}

ON_LAYOUT_VIEWS( signal )
{
    if ( _isToolbarHiden )
    {
        _webView.frame = self.view.bounds;
    }
    else
    {
        int toolbarHeight = 44.0f;
        
        CGRect frame = self.view.frame;
        frame.size.height -= toolbarHeight;
        if ( IOS7_OR_EARLIER )
        {
            frame.origin.y = 0;
        }
        _webView.frame = frame;
        
        frame.origin.y += frame.size.height;
        frame.size.height = toolbarHeight;
        _toolbar.frame = frame;
    }
}

ON_DID_APPEAR( signal )
{
    bee.ext.appBoard.menuShown = NO;
    
    if ( self.firstEnter )
    {
        [self refresh];
    }
    
    if ( self.isPreviousNavbarHidden )
    {
        self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
        self.navigationBarTitle = @"浏览器";
        
        self.navigationBarShown = YES;
        
        if ( self.defaultTitle && self.defaultTitle.length )
        {
            self.navigationBarTitle = self.defaultTitle;
        }
    }
}

ON_WILL_DISAPPEAR( signal )
{
    if ( self.isPreviousNavbarHidden )
    {
        self.navigationBarShown = NO;
    }
}

ON_LEFT_BUTTON_TOUCHED( signal )
{
	if ( self.backBoard )
	{
		[self.stack popToBoard:self.backBoard animated:YES];
	}
	else
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_RIGHT_BUTTON_TOUCHED( signal )
{
}

#pragma mark -

- (void)refresh
{
	if ( self.webView.loadingURL && self.webView.loadingURL.length )
	{
		self.webView.url = self.webView.loadingURL;
	}
	else if ( self.urlString )
    {
        self.webView.url = self.urlString;
    }
    else if ( self.htmlString )
    {
        self.webView.html = self.htmlString;
    }
}

- (void)updateUI
{
	if ( self.useHTMLTitle )
	{
		NSString * title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		if ( title && title.length )
		{
			self.titleString = title;
		}
	}
	
	_back.enabled = self.webView.canGoBack;
	_forward.enabled = self.webView.canGoForward;
    
	if ( _webView.loading )
	{
        [_toolbar setItems:@[ _flexible, _back, _flexible, _forward, _flexible, _flexible, _flexible, _stop, _flexible ] animated:NO];
    }
    else
    {
        [_toolbar setItems:@[ _flexible, _back, _flexible, _forward, _flexible, _flexible, _flexible, _refresh , _flexible] animated:NO];
    }
}

#pragma mark -

- (void)setupToolbar
{
    _flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
    _back = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-back.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(goBack)];
    
    _forward = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-forward.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(goForward)];
    
    _refresh = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-refresh.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(refresh)];
    
    _stop = \
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser-baritem-stop.png"]
                                     style:UIBarButtonItemStylePlain
                                    target:self.webView
                                    action:@selector(stopLoading)];
    
}

#pragma mark - UIWebViewDelegate

ON_SIGNAL2( BeeUIWebView, signal )
{
	[self updateUI];
    
    if ( [signal is:BeeUIWebView.DID_START] )
    {
		if ( _showLoading )
		{
			BeeUIActivityIndicatorView * activity = [BeeUIActivityIndicatorView spawn];
			[activity startAnimating];
			[activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
			[self showBarButton:BeeUINavigationBar.RIGHT custom:activity];
            //			[self presentLoadingTips:__TEXT(@"tips_loading")].useMask = NO;
		}
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_FINISH] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
            //			[self presentSuccessTips:@"加载成功"];
		}
    }
    else if ( [signal is:BeeUIWebView.DID_LOAD_CANCELLED] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
            //			[self presentSuccessTips:@"取消加载"];
		}
    }
    else if( [signal is:BeeUIWebView.DID_LOAD_FAILED] )
    {
		if ( _showLoading )
		{
			[self dismissTips];
			[self hideBarButton:BeeUINavigationBar.RIGHT];
			
			[self presentSuccessTips:@"网络异常, 请稍后再试"];
		}
    }
}

@end
