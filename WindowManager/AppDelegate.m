//
//  AppDelegate.m
//  WindowManager
//
//  Created by Steven Troughton-Smith on 23/12/2015.
//  Copyright © 2015 High Caffeine Content. All rights reserved.
//

#import "AppDelegate.h"

@import MapKit;
@import WebKit;
@import SafariServices;
@import ObjectiveC.runtime;

WMWindow *window1;
WMWindow *window2;
WMWindow *window3;

@implementation UINavigationBar (WMNavigationBar)

/*	Overly simplistic. You'd want to rewrite this */
-(void)layoutSubviews_WM
{
	[self layoutSubviews_WM];
	
	for (UIView *view in self.subviews)
	{
		if (![[view class] isSubclassOfClass:NSClassFromString(@"_UINavigationBarBackground")] && [view class] != NSClassFromString(@"UINavigationItemView"))
		{
			CGRect f = view.frame;
			f.origin.x += 75;
			
			view.frame = f;
		}
	}
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	Class class = [UINavigationBar class];
	
	Method originalMethod = class_getInstanceMethod(class, @selector(layoutSubviews));
	Method categoryMethod = class_getInstanceMethod(class, @selector(layoutSubviews_WM));
	method_exchangeImplementations(originalMethod, categoryMethod);
	
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	self.window.rootViewController = [[UIViewController alloc] init];

	self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wallpaper"]];
	
	[self.window makeKeyAndVisible];
	
	{
		window1 = [[WMWindow alloc] initWithFrame:CGRectMake(50, 50, 400, 300)];
		window1.title = @"Map";
		
		UIViewController *vc1 = [[UIViewController alloc] init];
		vc1.title = @"Root";
		
		UIViewController *vc = [[UIViewController alloc] init];
		vc.title = @"Map";
		
		vc.view = [[MKMapView alloc] init];
		
		window1.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc1];
		vc.navigationItem.hidesBackButton = NO;

		[((UINavigationController *)window1.rootViewController) pushViewController:vc animated:YES]; // testing nav bar behavior
		
		[window1 makeKeyAndVisible];
	}
	
	{
		window2 = [[WMWindow alloc] initWithFrame:CGRectMake(250, 250, 300, 300)];
		window2.title = @"Table";
		
		UITableViewController *vc = [[UITableViewController alloc] init];
		vc.title = @"Table";
		
		window2.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
		
		[window2 makeKeyAndVisible];
	}
	
	{
		window3 = [[WMWindow alloc] initWithFrame:CGRectMake(480, 150, 500, 500)];
		window3.title = @"Text";
		
		UIViewController *vc = [[UIViewController alloc] init];
		vc.view = [[UITextView alloc] init];
		vc.title = @"Text";
		
		
		UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
		
		((UITextView *)vc.view).text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
		
		window3.rootViewController = navC;

		[window3 makeKeyAndVisible];

	}
	
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#pragma clang diagnostic pop

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
