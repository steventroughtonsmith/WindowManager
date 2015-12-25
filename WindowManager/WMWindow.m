//
//  WMWindow.m
//  WindowManager
//
//  Created by Steven Troughton-Smith on 23/12/2015.
//  Copyright © 2015 High Caffeine Content. All rights reserved.
//

#import "WMWindow.h"

#define kTitleBarHeight 0.0
#define kMoveGrabHeight 44.0

#define kWindowButtonFrameSize 44.0
#define kWindowButtonSize 24.0
#define kWindowResizeGutterSize 8.0
#define kWindowResizeGutterTargetSize 24.0
#define kWindowResizeGutterKnobSize 48.0
#define kWindowResizeGutterKnobWidth 4.0


@implementation WMWindow

-(void)_commonInit
{
	self.windowButtons = @[].mutableCopy;
	
	{
		UIButton *windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
		windowButton.frame = CGRectMake(kWindowResizeGutterSize, kWindowResizeGutterSize, kWindowButtonFrameSize, kWindowButtonFrameSize);
		windowButton.contentMode = UIViewContentModeCenter;
		windowButton.adjustsImageWhenHighlighted = YES;
		
		[windowButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
		
		
		UIColor *fillColor = [UIColor colorWithRed:0.953 green:0.278 blue:0.275 alpha:1.000] ;
		UIColor *strokeColor = [UIColor colorWithRed:0.839 green:0.188 blue:0.192 alpha:1.000];
		
		UIColor *inactiveFillColor = [UIColor colorWithWhite:0.765 alpha:1.000];
		UIColor *inactiveStrokeColor = [UIColor colorWithWhite:0.608 alpha:1.000];
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[fillColor setFill];
		[strokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
		UIGraphicsEndImageContext();
		
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[inactiveFillColor setFill];
		[inactiveStrokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateDisabled];
		UIGraphicsEndImageContext();
		
		[self addSubview:windowButton];
		
		[self.windowButtons addObject:windowButton];
	}
	
	{
		UIButton *windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
		windowButton.frame = CGRectMake(kWindowResizeGutterSize+12+kWindowButtonSize, kWindowResizeGutterSize, kWindowButtonFrameSize, kWindowButtonFrameSize);
		windowButton.contentMode = UIViewContentModeCenter;
		windowButton.adjustsImageWhenHighlighted = YES;
		[windowButton addTarget:self action:@selector(maximize:) forControlEvents:UIControlEventTouchUpInside];
		
		
		UIColor *fillColor = [UIColor colorWithRed:0.188 green:0.769 blue:0.196 alpha:1.000] ;
		UIColor *strokeColor = [UIColor colorWithRed:0.165 green:0.624 blue:0.125 alpha:1.000];
		
		UIColor *inactiveFillColor = [UIColor colorWithWhite:0.765 alpha:1.000];
		UIColor *inactiveStrokeColor = [UIColor colorWithWhite:0.608 alpha:1.000];
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[fillColor setFill];
		[strokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
		UIGraphicsEndImageContext();
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(kWindowButtonSize, kWindowButtonSize), NO, [UIScreen mainScreen].scale);
		
		[inactiveFillColor setFill];
		[inactiveStrokeColor setStroke];
		
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, kWindowButtonSize-2, kWindowButtonSize-2)] stroke];
		
		[windowButton setImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateDisabled];
		UIGraphicsEndImageContext();
		
		[self addSubview:windowButton];
		[self.windowButtons addObject:windowButton];
	}
	
	
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	panRecognizer.delegate = self;
	[self addGestureRecognizer:panRecognizer];
	
	UITapGestureRecognizer *focusRecognizers = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	[self addGestureRecognizer:focusRecognizers];
	
	
	
	self.layer.shadowRadius = 30.0;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.3;
}

-(void)layoutSubviews
{
	UIView *rootView = self.rootViewController.view;
	
	CGRect contentRect = CGRectMake(kWindowResizeGutterSize, kWindowResizeGutterSize+kTitleBarHeight, self.bounds.size.width-(kWindowResizeGutterSize*2), self.bounds.size.height-kTitleBarHeight-(kWindowResizeGutterSize*2));
	
	rootView.frame = contentRect;
	[self adjustMask];
}

-(BOOL)isOpaque
{
	return NO;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self _commonInit];
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self _commonInit];
	}
	return self;
}

-(void)maximize:(id)sender
{
	self.maximized = !self.maximized;
	
	UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
	
	[UIView beginAnimations:nil context:nil];
	if (self.maximized)
	{
		_savedFrame = self.frame;
		self.frame = CGRectMake(-kWindowResizeGutterSize, 20+-kWindowResizeGutterSize, rootWindow.bounds.size.width+(kWindowResizeGutterSize*2), rootWindow.bounds.size.height-20+(kWindowResizeGutterSize*2));
	}
	else
	{
		self.frame = _savedFrame;
	}
	[UIView commitAnimations];
}

-(void)close:(id)sender
{
	[self setHidden:YES];
}

- (void)becomeKeyWindow
{
	[self setNeedsDisplay];
	self.layer.shadowRadius = 30.0;
	for (UIButton *btn in self.windowButtons)
	{
		btn.enabled = YES;
	}
}

- (void)resignKeyWindow
{
	[self setNeedsDisplay];
	self.layer.shadowRadius = 10.0;
	
	for (UIButton *btn in self.windowButtons)
	{
		btn.enabled = NO;
	}
}

-(void)addSubview:(UIView *)view
{
	[super addSubview:view];
	for (UIButton *btn in self.windowButtons)
	{
		[self insertSubview:btn atIndex:UINT_MAX];
	}
}

-(void)didTap:(UIGestureRecognizer *)rec
{
	[self makeKeyAndVisible];
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self setNeedsDisplay];
}

-(void)didPan:(UIPanGestureRecognizer *)recognizer
{
	CGRect titleBarRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, kMoveGrabHeight);
	CGPoint gp = [recognizer locationInView:[UIApplication sharedApplication].windows[0]];
	CGPoint lp = [recognizer locationInView:self];
	
	CGRect leftResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, kWindowResizeGutterTargetSize, self.bounds.size.height);
	CGRect rightResizeRect = CGRectMake(self.bounds.origin.x+self.bounds.size.width-kWindowResizeGutterTargetSize, self.bounds.origin.y, kWindowResizeGutterTargetSize, self.bounds.size.height);
	
	CGRect topResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, kWindowResizeGutterTargetSize);
	CGRect bottomResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+self.bounds.size.height-kWindowResizeGutterTargetSize, self.bounds.size.width, kWindowResizeGutterTargetSize);

	
	
	leftResizeRect = CGRectInset(leftResizeRect, -kWindowResizeGutterTargetSize, -kWindowResizeGutterTargetSize);
	rightResizeRect = CGRectInset(rightResizeRect, -kWindowResizeGutterTargetSize, -kWindowResizeGutterTargetSize);
	bottomResizeRect = CGRectInset(bottomResizeRect, -kWindowResizeGutterTargetSize, -kWindowResizeGutterTargetSize);

	
	if (self.maximized)
		return;
	
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
		_originPoint = lp;
		
		if (CGRectContainsPoint(titleBarRect, lp))
		{
			_inWindowMove = YES;
			_inWindowResize = NO;
			return;
		}
		
		if (!self.isKeyWindow)
			return;
		
		if (CGRectContainsPoint(leftResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeLeft;
		}
		
		if (CGRectContainsPoint(rightResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeRight;
		}
		
		
		if (CGRectContainsPoint(topResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeTop;
		}
		
		if (CGRectContainsPoint(bottomResizeRect, lp))
		{
			_inWindowResize = YES;
			_inWindowMove = NO;
			resizeAxis = WMResizeBottom;
		}
	}
	else if (recognizer.state == UIGestureRecognizerStateChanged)
	{
		
		if (_inWindowMove)
		{
			self.frame = CGRectMake(gp.x-_originPoint.x, gp.y-_originPoint.y, self.frame.size.width, self.frame.size.height);
		}
		if (_inWindowResize)
		{
			if (resizeAxis == WMResizeRight)
			{
				self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, gp.x-self.frame.origin.x, self.frame.size.height);
			}
			
			if (resizeAxis == WMResizeLeft)
			{
				self.frame = CGRectMake(gp.x, self.frame.origin.y, (-gp.x+self.frame.origin.x)+self.frame.size.width, self.frame.size.height);
			}
			
			if (resizeAxis == WMResizeBottom)
			{
				self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,gp.y-self.frame.origin.y);
			}
		}
	}
	else if (recognizer.state == UIGestureRecognizerStateEnded)
	{
		_inWindowMove = NO;
		_inWindowResize = NO;
		[self setNeedsDisplay];
	}
	
	
}

-(void)adjustMask
{
	CGRect contentBounds = self.rootViewController.view.bounds;
	CGRect contentFrame = CGRectMake(self.bounds.origin.x+kWindowResizeGutterSize, self.bounds.origin.y+kWindowResizeGutterSize, self.bounds.size.width-(kWindowResizeGutterSize*2), self.bounds.size.height-(kWindowResizeGutterSize*2));
	
	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:contentBounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)].CGPath;
	
	maskLayer.frame = contentBounds;
	
	self.rootViewController.view.layer.mask = maskLayer;
	
	self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:contentFrame byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)].CGPath;
	self.layer.shadowRadius = 30.0;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 0.3;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (void)drawRect:(CGRect)rect
{
	
#if USE_TITLEBAR
	
	UIColor *lightColor = [UIColor colorWithRed:0.886 green:0.878 blue:0.886 alpha:1.000];
	UIColor *darkColor = [UIColor colorWithRed:0.784 green:0.773 blue:0.784 alpha:1.000];
	UIColor *highlightColor = [UIColor colorWithRed:0.949 green:0.945 blue:0.949 alpha:1.000];
	UIColor *lowlightColor = [UIColor colorWithRed:0.749 green:0.745 blue:0.749 alpha:1.000];
	UIColor *textColor = [UIColor blackColor];
	
	
	UIColor *inactiveLightColor = [UIColor colorWithWhite:0.925 alpha:1.000];
	UIColor *inactiveDarkColor = [UIColor colorWithWhite:0.905 alpha:1.000];
	
	
	if (!self.isKeyWindow)
	{
		lightColor = inactiveLightColor;
		darkColor = inactiveDarkColor;
		textColor = [UIColor colorWithWhite:0.625 alpha:1.000];
	}
	
	{
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		NSArray *gradientColors = [NSArray arrayWithObjects:(id) lightColor.CGColor, darkColor.CGColor, nil];
		
		CGFloat gradientLocations[] = {0, 0.750, 1};
		CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColors, gradientLocations);
		
		CGPoint startPoint = CGPointMake(CGRectGetMidX(titleBarRect), CGRectGetMinY(titleBarRect));
		CGPoint endPoint = CGPointMake(CGRectGetMidX(titleBarRect), CGRectGetMaxY(titleBarRect));
		
		CGContextSaveGState(context);
		CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:contentRect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)].CGPath);
		CGContextClip(context);

		[[UIColor whiteColor] set];
		UIRectFill(self.bounds);
		
		CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
		
		[highlightColor set];
		UIRectFill(CGRectMake(kWindowResizeGutterSize, kWindowResizeGutterSize, titleBarRect.size.width-(kWindowResizeGutterSize*2), 1));
		
		[lowlightColor set];
		UIRectFill(CGRectMake(kWindowResizeGutterSize, kWindowResizeGutterSize+titleBarRect.size.height-1, self.bounds.size.width-(kWindowResizeGutterSize*2), 1));
		
		CGContextRestoreGState(context);
		CGGradientRelease(gradient);
		CGColorSpaceRelease(colorSpace);
	}

	if (kTitleBarHeight > 0)
	{
		NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
		style.alignment = NSTextAlignmentCenter;
		
		NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:textColor};
		
		CGSize sz = [self.title sizeWithAttributes:attr];
		
		[self.title drawInRect:CGRectMake(titleBarRect.origin.x, titleBarRect.origin.y+(titleBarRect.size.height-sz.height)/2, titleBarRect.size.width, sz.height) withAttributes:attr];
	}
#endif
	
	
	if (self.isKeyWindow && !self.maximized)
	{
		if (_inWindowResize)
		{
			CGRect leftResizeRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+kWindowResizeGutterSize, kWindowResizeGutterSize, self.bounds.size.height-(kWindowResizeGutterSize*2));
			CGRect rightResizeRect = CGRectMake(self.bounds.origin.x+self.bounds.size.width-kWindowResizeGutterSize, self.bounds.origin.y+kWindowResizeGutterSize, kWindowResizeGutterSize, self.bounds.size.height-(kWindowResizeGutterSize*2));

			CGRect bottomResizeRect = CGRectMake(self.bounds.origin.x+kWindowResizeGutterSize, self.bounds.origin.y+self.bounds.size.height-kWindowResizeGutterSize, self.bounds.size.width-(kWindowResizeGutterSize*2), kWindowResizeGutterSize);
			
			[[UIColor colorWithWhite:0.0 alpha:0.3] setFill];
			
			if (resizeAxis == WMResizeRight)
			{
				[[UIBezierPath bezierPathWithRoundedRect:rightResizeRect cornerRadius:3.0] fill];
			}
			
			if (resizeAxis == WMResizeLeft)
			{
				[[UIBezierPath bezierPathWithRoundedRect:leftResizeRect cornerRadius:3.0] fill];
			}
			
			if (resizeAxis == WMResizeBottom)
			{
				[[UIBezierPath bezierPathWithRoundedRect:bottomResizeRect cornerRadius:3.0] fill];
			}
		}
		
		
		[[UIColor colorWithWhite:1 alpha:0.3] setFill];
		
		[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMidX(self.bounds)-kWindowResizeGutterKnobSize/2, CGRectGetMaxY(self.bounds)-kWindowResizeGutterKnobWidth-(kWindowResizeGutterSize-kWindowResizeGutterKnobWidth)/2, kWindowResizeGutterKnobSize, kWindowResizeGutterKnobWidth) cornerRadius:2] fill];
		
		[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((kWindowResizeGutterSize-kWindowResizeGutterKnobWidth)/2, CGRectGetMidY(self.bounds)-kWindowResizeGutterKnobSize/2, kWindowResizeGutterKnobWidth, kWindowResizeGutterKnobSize) cornerRadius:2] fill];
		
		[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMaxX(self.bounds)-kWindowResizeGutterKnobWidth-(kWindowResizeGutterSize-kWindowResizeGutterKnobWidth)/2, CGRectGetMidY(self.bounds)-kWindowResizeGutterKnobSize/2, kWindowResizeGutterKnobWidth, kWindowResizeGutterKnobSize) cornerRadius:2] fill];
	}
}


@end
