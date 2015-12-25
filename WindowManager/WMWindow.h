//
//  WMWindow.h
//  WindowManager
//
//  Created by Steven Troughton-Smith on 23/12/2015.
//  Copyright © 2015 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
	WMResizeLeft,
	WMResizeRight,
	WMResizeTop,
	WMResizeBottom
} WMResizeAxis;
@interface WMWindow : UIWindow <UIGestureRecognizerDelegate>
{
	CGRect _savedFrame;
	BOOL _inWindowMove;
	BOOL _inWindowResize;
	CGPoint _originPoint;
	WMResizeAxis resizeAxis;
}

@property NSString *title;

@property NSMutableArray *windowButtons;
@property BOOL maximized;

@end
